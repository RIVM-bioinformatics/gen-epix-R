if (requireNamespace("genepixR", quietly = TRUE)) {
    retrieve_cases_by_query <- genepixR::retrieve_cases_by_query
    retrieve_cases_by_id <- genepixR::retrieve_cases_by_id
    retrieve_phylogenetic_tree_by_cases <-
        genepixR::retrieve_phylogenetic_tree_by_cases
    commondb_url <- genepixR::commondb_url
    chromote_access_token_value <- genepixR:::chromote_access_token_value
    read_chromote_access_token_during_login <-
        genepixR:::read_chromote_access_token_during_login
} else {
    repo_root <- if (dir.exists("R")) "." else ".."
    source(file.path(repo_root, "R", "commondb-client.R"))
    source(file.path(repo_root, "R", "casedb-client.R"))
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

distances_response <- list(list(marker = "preserved"))
distances_request <- retrieve_seq_distances_by_cases(
    base_url = "http://localhost:8000",
    access_token = "test-token",
    case_ids = case_ids,
    genetic_distance_col_id = "distance-column-x",
    case_type_id = case_type_id,
    timeout_seconds = 12,
    post_json = record_request
)
stopifnot(
    identical(
        distances_request$url,
        "http://localhost:8000/v1/retrieve/seq_distances_by_cases"
    ),
    identical(
        distances_request$body,
        list(
            case_type_id = case_type_id,
            case_ids = case_ids,
            genetic_distance_col_id = "distance-column-x",
            filter_other_cases = TRUE
        )
    ),
    identical(distances_request$access_token, "test-token"),
    identical(distances_request$timeout_seconds, 12)
)

explicit_filter_request <- retrieve_seq_distances_by_cases(
    base_url = "http://localhost:8000",
    access_token = "test-token",
    case_ids = case_ids,
    genetic_distance_col_id = "distance-column-x",
    case_type_id = case_type_id,
    filter_other_cases = FALSE,
    post_json = function(url, body, access_token, timeout_seconds) {
        list(
            result = record_request(url, body, access_token, timeout_seconds),
            response = distances_response
        )
    }
)
stopifnot(
    identical(explicit_filter_request$response, distances_response),
    identical(explicit_filter_request$result$body$filter_other_cases, FALSE)
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

cat("genepixR unit tests passed.\n")
