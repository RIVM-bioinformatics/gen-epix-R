# Interactive end-to-end test for the CASEDB R client.
#
# Set GEN_EPIX_RUN_E2E=true before running this script. The required values are:
# - GEN_EPIX_CASEDB_URL: CASEDB API URL
# - GEN_EPIX_LOGIN_URL: CASEDB web application URL, unless a token is supplied
# - GEN_EPIX_CASE_TYPE_ID: case type to query
# - GEN_EPIX_ACCESS_TOKEN: optional non-interactive bearer token
# - GEN_EPIX_GENETIC_DISTANCE_COL_ID: column used for the tree request

if (!identical(Sys.getenv("GEN_EPIX_RUN_E2E"), "true")) {
    message("Skipping CASEDB end-to-end test; set GEN_EPIX_RUN_E2E=true to run it.")
} else {
    if (!requireNamespace("genepixR", quietly = TRUE)) {
        stop("Install the genepixR package before running the end-to-end test.")
    }

    casedb_url <- Sys.getenv("GEN_EPIX_CASEDB_URL")
    case_type_id <- Sys.getenv("GEN_EPIX_CASE_TYPE_ID")
    distance_col_id <- Sys.getenv("GEN_EPIX_GENETIC_DISTANCE_COL_ID")
    access_token <- Sys.getenv("GEN_EPIX_ACCESS_TOKEN")

    required_values <- c(casedb_url, case_type_id, distance_col_id)
    if (any(!nzchar(required_values))) {
        stop(
            paste(
                "GEN_EPIX_CASEDB_URL, GEN_EPIX_CASE_TYPE_ID, and",
                "GEN_EPIX_GENETIC_DISTANCE_COL_ID are required."
            ),
            call. = FALSE
        )
    }
    if (!nzchar(access_token)) {
        login_url <- Sys.getenv("GEN_EPIX_LOGIN_URL")
        if (!nzchar(login_url)) {
            stop(
                "Set GEN_EPIX_ACCESS_TOKEN or GEN_EPIX_LOGIN_URL.",
                call. = FALSE
            )
        }
        access_token <- genepixR::login_with_chromote(login_url)
    }

    query_result <- genepixR::retrieve_cases_by_query(
        casedb_url,
        access_token,
        case_type_id = case_type_id
    )
    case_ids <- unlist(query_result$case_ids, use.names = FALSE)
    cases <- if (length(case_ids) == 0L) {
        list()
    } else {
        genepixR::retrieve_cases_by_id(
            casedb_url,
            access_token,
            case_ids = case_ids,
            case_type_id = case_type_id
        )
    }

    cat("\nCASEDB R end-to-end test succeeded.\n")
    cat("Cases matched:", length(case_ids), "\n")
    cat("Cases retrieved:", length(cases), "\n")
}
