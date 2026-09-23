#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3L) {
    stop(
        paste(
            "Usage: Rscript retrieve_all_cases.R",
            "<casedb-url> <case-type-id> <output-rds>"
        ),
        call. = FALSE
    )
}

if (!requireNamespace("genepixR", quietly = TRUE)) {
    stop(
        "Install the genepixR package before running this script.",
        call. = FALSE
    )
}

base_url <- args[[1L]]
case_type_id <- args[[2L]]
output_path <- args[[3L]]
access_token <- Sys.getenv("GEN_EPIX_ACCESS_TOKEN", unset = "")

if (!nzchar(access_token)) {
    login_url <- Sys.getenv("GEN_EPIX_LOGIN_URL", unset = "")
    if (!nzchar(login_url)) {
        stop(
            paste(
                "Set GEN_EPIX_ACCESS_TOKEN for non-interactive use,",
                "or set GEN_EPIX_LOGIN_URL for browser login."
            ),
            call. = FALSE
        )
    }
    access_token <- genepixR::login_with_chromote(login_url)
}

query_result <- genepixR::retrieve_cases_by_query(
    base_url,
    access_token,
    case_type_id = case_type_id
)
case_ids <- unlist(query_result$case_ids, use.names = FALSE)

cases <- if (length(case_ids) == 0L) {
    list()
} else {
    genepixR::retrieve_cases_by_id(
        base_url,
        access_token,
        case_ids = case_ids,
        case_type_id = case_type_id
    )
}

saveRDS(cases, output_path)
cat("Retrieved", length(case_ids), "cases to", output_path, "\n")
