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
    if (!requireNamespace("httr2", quietly = TRUE)) {
        stop("Package 'httr2' is required for HTTP requests.", call. = FALSE)
    }
    is_valid_access_token <- is.character(access_token) &&
        length(access_token) == 1L &&
        nzchar(access_token)
    if (!is_valid_access_token) {
        stop("A non-empty access token is required.", call. = FALSE)
    }

    request <- httr2::request(url)
    request <- httr2::req_headers(
        request,
        Authorization = paste("Bearer", access_token)
    )
    request <- httr2::req_body_json(request, body, auto_unbox = TRUE)
    request <- httr2::req_timeout(request, timeout_seconds)

    response <- httr2::req_perform(request)
    httr2::resp_body_json(response, simplifyVector = FALSE)
}
