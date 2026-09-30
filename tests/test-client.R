repo_root <- Filter(
    function(path) file.exists(file.path(path, "R", "commondb-client.R")),
    c(".", "..")
)
if (length(repo_root) > 0L) {
    for (source_file in list.files(
        file.path(repo_root[[1L]], "R"),
        pattern = "\\.R$",
        full.names = TRUE
    )) {
        source(source_file)
    }
} else {
    package_namespace <- asNamespace("genepixR")
    for (name in ls(package_namespace)) {
        assign(name, get(name, envir = package_namespace))
    }
}

record_request <- function(url, body, access_token, timeout_seconds) {
    list(
        url = url,
        body = body,
        access_token = access_token,
        timeout_seconds = timeout_seconds
    )
}

case_type_id <- "case-type-x"
case_ids <- c("case-1", "case-2")

query_request <- retrieve_cases_by_query(
    base_url = "http://localhost:8000/",
    access_token = "test-token",
    case_type_id = case_type_id,
    post_json = record_request
)
stopifnot(
    identical(query_request$url, "http://localhost:8000/v1/retrieve/case_ids_by_query"),
    identical(query_request$body, list(case_type_id = case_type_id)),
    identical(query_request$access_token, "test-token")
)

cases_request <- retrieve_cases_by_id(
    base_url = "http://localhost:8000",
    access_token = "test-token",
    case_ids = case_ids,
    case_type_id = case_type_id,
    post_json = record_request
)
stopifnot(
    identical(cases_request$url, "http://localhost:8000/v1/retrieve/cases_by_ids"),
    identical(
        cases_request$body,
        list(case_type_id = case_type_id, case_ids = case_ids)
    )
)

tree_request <- retrieve_phylogenetic_tree_by_cases(
    base_url = "http://localhost:8000",
    access_token = "test-token",
    case_ids = case_ids,
    genetic_distance_col_id = "distance-column-x",
    case_type_id = case_type_id,
    post_json = record_request
)
stopifnot(
    identical(tree_request$url, "http://localhost:8000/v1/calculate/phylogenetic_tree"),
    identical(tree_request$body$case_type_id, case_type_id),
    identical(tree_request$body$genetic_distance_col_id, "distance-column-x"),
    identical(tree_request$body$tree_algorithm_code, "SLINK"),
    identical(tree_request$body$case_ids, case_ids)
)

stopifnot(
    identical(
        commondb_url("http://localhost:8000/", "v1/retrieve"),
        "http://localhost:8000/v1/retrieve"
    )
)

token_result <- list(result = list(value = "browser-token"))
stopifnot(identical(chromote_access_token_value(token_result), "browser-token"))

missing_token_result <- list(result = list(subtype = "null"))
stopifnot(is.null(chromote_access_token_value(missing_token_result)))

timed_out_runtime <- new.env()
timed_out_runtime$evaluate <- function(...) {
    stop("Chromote: timed out waiting for response to command Runtime.evaluate")
}
timed_out_session <- list(Runtime = timed_out_runtime)
stopifnot(is.null(read_chromote_access_token_during_login(timed_out_session)))

disconnected_runtime <- new.env()
disconnected_runtime$evaluate <- function(...) {
    stop("Chromote: websocket disconnected")
}
disconnected_session <- list(Runtime = disconnected_runtime)
capture_error_message <- function(error) conditionMessage(error)
disconnected_error <- tryCatch(
    read_chromote_access_token_during_login(disconnected_session),
    error = capture_error_message
)
stopifnot(identical(disconnected_error, "Chromote: websocket disconnected"))

record_json_request <- function(url, access_token, method, body, timeout_seconds) {
    list(
        url = url,
        access_token = access_token,
        method = method,
        body = body,
        timeout_seconds = timeout_seconds
    )
}

user_me_request <- retrieve_user_me(
    "http://localhost:8000/",
    "test-token",
    request_json = record_json_request
)
stopifnot(
    identical(user_me_request$url, "http://localhost:8000/v1/user_me"),
    identical(user_me_request$method, "GET"),
    is.null(user_me_request$body)
)

permissions_request <- retrieve_own_permissions(
    "http://localhost:8000",
    "test-token",
    request_json = record_json_request
)
stopifnot(
    identical(
        permissions_request$url,
        "http://localhost:8000/v1/user_me/permissions"
    ),
    identical(permissions_request$method, "GET")
)

crud_base_url <- "http://localhost:8000/v1/organization_sets"
read_all_request <- crud_read_all(
    "http://localhost:8000",
    "test-token",
    "organization_sets",
    request_json = record_json_request
)
stopifnot(
    identical(read_all_request$url, crud_base_url),
    identical(read_all_request$method, "GET")
)

read_one_request <- crud_read_one(
    "http://localhost:8000",
    "test-token",
    "organization_sets",
    "object-1",
    request_json = record_json_request
)
stopifnot(
    identical(read_one_request$url, paste0(crud_base_url, "/object-1")),
    identical(read_one_request$method, "GET")
)

create_request <- crud_create(
    "http://localhost:8000",
    "test-token",
    "organization_sets",
    obj = list(name = "set"),
    request_json = record_json_request
)
stopifnot(
    identical(create_request$url, crud_base_url),
    identical(create_request$method, "POST"),
    identical(create_request$body, list(name = "set"))
)

update_request <- crud_update(
    "http://localhost:8000",
    "test-token",
    "organization_sets",
    "object-1",
    obj = list(name = "set"),
    request_json = record_json_request
)
stopifnot(
    identical(update_request$url, paste0(crud_base_url, "/object-1")),
    identical(update_request$method, "PUT"),
    identical(update_request$body, list(name = "set", id = "object-1"))
)

delete_request <- crud_delete(
    "http://localhost:8000",
    "test-token",
    "organization_sets",
    "object-1",
    request_json = record_json_request
)
stopifnot(
    identical(delete_request$url, paste0(crud_base_url, "/object-1")),
    identical(delete_request$method, "DELETE"),
    is.null(delete_request$body)
)

invalid_entity_error <- tryCatch(
    crud_read_all(
        "http://localhost:8000",
        "test-token",
        "../user_me",
        request_json = record_json_request
    ),
    error = capture_error_message
)
stopifnot(grepl("snake_case endpoint name", invalid_entity_error, fixed = TRUE))

json_response <- function(body) {
    httr2::response(
        status_code = 200L,
        headers = list(`Content-Type` = "application/json"),
        body = charToRaw(body)
    )
}

captured_requests <- list()
mock_identity_provider <- function(req) {
    captured_requests[[length(captured_requests) + 1L]] <<- req
    if (grepl("openid-configuration$", req$url)) {
        return(json_response('{"token_endpoint": "https://idp.test/token"}'))
    }
    json_response('{"access_token": "client-token", "token_type": "Bearer"}')
}
client_token <- httr2::with_mocked_responses(
    mock_identity_provider,
    login_with_client_credentials(
        "https://idp.test/.well-known/openid-configuration",
        client_id = "client",
        client_secret = "secret",
        scope = "openid"
    )
)
token_request <- captured_requests[[2L]]
token_request_body <- httr2::req_get_body(token_request)
stopifnot(
    identical(client_token, "client-token"),
    identical(token_request$url, "https://idp.test/token"),
    identical(
        httr2::req_get_headers(token_request, "reveal")$Authorization,
        "Basic Y2xpZW50OnNlY3JldA=="
    ),
    identical(as.character(token_request_body$grant_type), "client_credentials"),
    identical(as.character(token_request_body$scope), "openid")
)

captured_requests <- list()
mock_application <- function(req) {
    captured_requests[[length(captured_requests) + 1L]] <<- req
    json_response('"object-1"')
}
deleted_id <- httr2::with_mocked_responses(
    mock_application,
    commondb_request_json(
        "http://localhost:8000/v1/organization_sets/object-1",
        "test-token",
        method = "DELETE"
    )
)
stopifnot(
    identical(deleted_id, "object-1"),
    identical(httr2::req_get_method(captured_requests[[1L]]), "DELETE"),
    identical(
        httr2::req_get_headers(captured_requests[[1L]], "reveal")$Authorization,
        "Bearer test-token"
    )
)

cat("genepixR unit tests passed.\n")
