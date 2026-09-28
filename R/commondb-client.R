#' JavaScript used to read the OIDC access token from a browser session.
#'
#' @keywords internal
CHROMOTE_ACCESS_TOKEN_SCRIPT <- paste0(
    "(() => {",
    "const key = Object.keys(sessionStorage)",
    ".find((key) => key.startsWith('oidc.user:'));",
    "if (!key) return null;",
    "const user = JSON.parse(sessionStorage.getItem(key));",
    "return user.access_token || null;",
    "})()"
)

chromote_access_token_value <- function(evaluation_result) {
    access_token <- tryCatch(
        evaluation_result$result$value,
        error = function(error) NULL
    )
    if (!is.character(access_token) || length(access_token) != 1L) {
        return(NULL)
    }
    if (!nzchar(access_token)) {
        return(NULL)
    }
    access_token
}

read_chromote_access_token <- function(
    chromote_session,
    timeout_seconds = 2
) {
    evaluation_result <- chromote_session$Runtime$evaluate(
        CHROMOTE_ACCESS_TOKEN_SCRIPT,
        returnByValue = TRUE,
        timeout_ = timeout_seconds
    )
    chromote_access_token_value(evaluation_result)
}

is_chromote_navigation_error <- function(error) {
    message <- conditionMessage(error)
    transient_messages <- c(
        "timed out waiting for response to command Runtime.evaluate",
        "Cannot find context with specified id",
        "Execution context was destroyed"
    )
    any(vapply(transient_messages, grepl, logical(1), x = message, fixed = TRUE))
}

handle_chromote_login_read_error <- function(error) {
    if (is_chromote_navigation_error(error)) {
        return(NULL)
    }
    stop(error)
}

read_chromote_access_token_during_login <- function(chromote_session) {
    tryCatch(
        read_chromote_access_token(chromote_session),
        error = handle_chromote_login_read_error
    )
}

#' Log in to a Gen-EpiX application through an interactive browser session.
#'
#' The function opens a Chromote viewer at `login_url` and polls the browser's
#' OIDC session storage until an access token is available.
#'
#' @param login_url URL of the Gen-EpiX web application login page.
#' @param timeout_seconds Maximum time to wait for login completion.
#' @param poll_interval_seconds Time between browser-session polls.
#' @return A single access-token string.
#' @export
login_with_chromote <- function(
    login_url,
    timeout_seconds = 300,
    poll_interval_seconds = 1
) {
    if (!requireNamespace("chromote", quietly = TRUE)) {
        stop("Package 'chromote' is required for browser login.", call. = FALSE)
    }

    chromote_session <- chromote::ChromoteSession$new()
    on.exit(chromote_session$close(), add = TRUE)
    chromote_session$go_to(login_url)
    chromote_session$view()
    message("Complete the login in the Chromote viewer.")

    deadline <- Sys.time() + timeout_seconds
    while (Sys.time() < deadline) {
        access_token <- read_chromote_access_token_during_login(chromote_session)
        if (!is.null(access_token)) {
            return(access_token)
        }
        Sys.sleep(poll_interval_seconds)
    }

    stop("Timed out waiting for the browser login to complete.", call. = FALSE)
}

#' Join a Gen-EpiX base URL and API path.
#'
#' @param base_url Gen-EpiX application base URL.
#' @param path Absolute or relative API path.
#' @return A URL with exactly one slash between the base URL and path.
#' @export
commondb_url <- function(base_url, path) {
    normalized_base_url <- sub("/+$", "", base_url)
    normalized_path <- sub("^/*", "/", path)
    paste0(normalized_base_url, normalized_path)
}

#' Send an authenticated JSON POST request to a Gen-EpiX endpoint.
#'
#' @param url Complete request URL.
#' @param body List to encode as a JSON request body.
#' @param access_token Bearer access token.
#' @param timeout_seconds Request timeout in seconds.
#' @return The decoded JSON response as an R object.
#' @export
commondb_post_json <- function(
    url,
    body,
    access_token,
    timeout_seconds = 45
) {
    commondb_request_json(
        url = url,
        access_token = access_token,
        method = "POST",
        body = body,
        timeout_seconds = timeout_seconds
    )
}

require_httr2 <- function() {
    if (!requireNamespace("httr2", quietly = TRUE)) {
        stop("Package 'httr2' is required for HTTP requests.", call. = FALSE)
    }
}

is_single_string <- function(value) {
    is.character(value) && length(value) == 1L && !is.na(value) && nzchar(value)
}

#' Send an authenticated JSON request to a Gen-EpiX endpoint.
#'
#' @param url Complete request URL.
#' @param access_token Bearer access token.
#' @param method HTTP method, such as `GET`, `POST`, `PUT`, or `DELETE`.
#' @param body Optional list to encode as a JSON request body.
#' @param timeout_seconds Request timeout in seconds.
#' @return The decoded JSON response as an R object, or `NULL` when the
#'   response has no body.
#' @export
commondb_request_json <- function(
    url,
    access_token,
    method = "GET",
    body = NULL,
    timeout_seconds = 45
) {
    require_httr2()
    if (!is_single_string(access_token)) {
        stop("A non-empty access token is required.", call. = FALSE)
    }

    request <- httr2::request(url)
    request <- httr2::req_method(request, method)
    request <- httr2::req_headers(
        request,
        Authorization = paste("Bearer", access_token)
    )
    if (!is.null(body)) {
        request <- httr2::req_body_json(request, body, auto_unbox = TRUE)
    }
    request <- httr2::req_timeout(request, timeout_seconds)

    response <- httr2::req_perform(request)
    if (!httr2::resp_has_body(response)) {
        return(NULL)
    }
    httr2::resp_body_json(response, simplifyVector = FALSE)
}

#' Obtain an access token with the OAuth 2.0 client-credentials grant.
#'
#' The token endpoint is read from the identity provider's OpenID Connect
#' discovery document. The client authenticates with HTTP Basic credentials,
#' so no browser interaction is needed; use this for automated jobs and tests.
#'
#' @param discovery_url URL of the OpenID Connect discovery document.
#' @param client_id OAuth client identifier.
#' @param client_secret OAuth client secret.
#' @param scope Optional space-separated scopes to request.
#' @param timeout_seconds Request timeout in seconds.
#' @return A single access-token string.
#' @export
login_with_client_credentials <- function(
    discovery_url,
    client_id,
    client_secret,
    scope = NULL,
    timeout_seconds = 45
) {
    require_httr2()
    if (!is_single_string(client_id) || !is_single_string(client_secret)) {
        stop("A non-empty client ID and client secret are required.", call. = FALSE)
    }

    discovery_request <- httr2::request(discovery_url)
    discovery_request <- httr2::req_timeout(discovery_request, timeout_seconds)
    discovery <- httr2::resp_body_json(httr2::req_perform(discovery_request))
    token_endpoint <- discovery$token_endpoint
    if (!is_single_string(token_endpoint)) {
        stop(
            "The discovery document does not contain a token endpoint.",
            call. = FALSE
        )
    }

    form <- list(grant_type = "client_credentials")
    if (!is.null(scope)) {
        form$scope <- scope
    }
    token_request <- httr2::request(token_endpoint)
    token_request <- httr2::req_auth_basic(token_request, client_id, client_secret)
    token_request <- do.call(httr2::req_body_form, c(list(token_request), form))
    token_request <- httr2::req_timeout(token_request, timeout_seconds)
    token_response <- httr2::resp_body_json(httr2::req_perform(token_request))

    access_token <- token_response$access_token
    if (!is_single_string(access_token)) {
        stop("The token response does not contain an access token.", call. = FALSE)
    }
    access_token
}

commondb_get <- function(
    base_url,
    path,
    access_token,
    timeout_seconds,
    request_json
) {
    request_json(
        url = commondb_url(base_url, paste0("/v1", path)),
        access_token = access_token,
        method = "GET",
        body = NULL,
        timeout_seconds = timeout_seconds
    )
}

#' Retrieve the authenticated user.
#'
#' Every Gen-EpiX application exposes this endpoint, which makes it a cheap
#' check that the access token is accepted and maps to a registered user.
#'
#' @param base_url Gen-EpiX application base URL.
#' @param access_token Bearer access token.
#' @param timeout_seconds Request timeout in seconds.
#' @param request_json Function used to send the request; useful for testing
#'   or custom HTTP clients.
#' @return The decoded user object.
#' @export
retrieve_user_me <- function(
    base_url,
    access_token,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    commondb_get(base_url, "/user_me", access_token, timeout_seconds, request_json)
}

#' Retrieve the command permissions of the authenticated user.
#'
#' @param base_url Gen-EpiX application base URL.
#' @param access_token Bearer access token.
#' @param timeout_seconds Request timeout in seconds.
#' @param request_json Function used to send the request; useful for testing
#'   or custom HTTP clients.
#' @return A list of permissions, each with `command_name` and
#'   `permission_type` fields.
#' @export
retrieve_own_permissions <- function(
    base_url,
    access_token,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    commondb_get(
        base_url,
        "/user_me/permissions",
        access_token,
        timeout_seconds,
        request_json
    )
}
