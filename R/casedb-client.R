casedb_post <- function(
    base_url,
    path,
    body,
    access_token,
    timeout_seconds,
    post_json
) {
    url <- commondb_url(base_url, paste0("/v1", path))
    post_json(
        url = url,
        body = body,
        access_token = access_token,
        timeout_seconds = timeout_seconds
    )
}

#' Retrieve the IDs of cases matching a case type.
#'
#' This request returns the cases visible to the authenticated user for the
#' supplied case type. Use [retrieve_cases_by_id()] to fetch their data.
#'
#' @param base_url Gen-EpiX CASEDB base URL.
#' @param access_token Bearer access token.
#' @param case_type_id Case-type identifier to query.
#' @param timeout_seconds Request timeout in seconds.
#' @param post_json Function used to send the request; useful for testing or
#'   custom HTTP clients.
#' @return The decoded CASEDB response, including its `case_ids` field.
#' @export
retrieve_cases_by_query <- function(
    base_url,
    access_token,
    case_type_id,
    timeout_seconds = 45,
    post_json = commondb_post_json
) {
    body <- list(case_type_id = case_type_id)
    casedb_post(
        base_url,
        "/retrieve/case_ids_by_query",
        body,
        access_token,
        timeout_seconds,
        post_json
    )
}

#' Retrieve case data by case IDs.
#'
#' @param base_url Gen-EpiX CASEDB base URL.
#' @param access_token Bearer access token.
#' @param case_ids Case identifiers to retrieve.
#' @param case_type_id Case-type identifier containing the cases.
#' @param timeout_seconds Request timeout in seconds.
#' @param post_json Function used to send the request; useful for testing or
#'   custom HTTP clients.
#' @return A decoded CASEDB response containing the requested cases.
#' @export
retrieve_cases_by_id <- function(
    base_url,
    access_token,
    case_ids,
    case_type_id,
    timeout_seconds = 45,
    post_json = commondb_post_json
) {
    body <- list(case_type_id = case_type_id, case_ids = case_ids)
    casedb_post(
        base_url,
        "/retrieve/cases_by_ids",
        body,
        access_token,
        timeout_seconds,
        post_json
    )
}

#' Retrieve sequence distances for cases.
#'
#' @param base_url Gen-EpiX CASEDB base URL.
#' @param access_token Bearer access token.
#' @param case_ids Case identifiers for which to retrieve sequence distances.
#' @param genetic_distance_col_id Case-type column containing genetic distances.
#' @param case_type_id Case-type identifier containing the cases.
#' @param filter_other_cases Whether to omit distances to cases not in
#'   `case_ids`, defaulting to `TRUE`.
#' @param timeout_seconds Request timeout in seconds.
#' @param post_json Function used to send the request; useful for testing or
#'   custom HTTP clients.
#' @return The decoded CASEDB response containing sequence distances.
#' @export
retrieve_seq_distances_by_cases <- function(
    base_url,
    access_token,
    case_ids,
    genetic_distance_col_id,
    case_type_id,
    filter_other_cases = TRUE,
    timeout_seconds = 45,
    post_json = commondb_post_json
) {
    body <- list(
        case_type_id = case_type_id,
        case_ids = case_ids,
        genetic_distance_col_id = genetic_distance_col_id,
        filter_other_cases = filter_other_cases
    )
    casedb_post(
        base_url,
        "/retrieve/seq_distances_by_cases",
        body,
        access_token,
        timeout_seconds,
        post_json
    )
}

#' Calculate a phylogenetic tree for a set of cases.
#'
#' @param base_url Gen-EpiX CASEDB base URL.
#' @param access_token Bearer access token.
#' @param case_ids Case identifiers to include in the tree.
#' @param genetic_distance_col_id Case-type column containing genetic distances.
#' @param tree_algorithm_code Tree algorithm code, defaulting to `SLINK`.
#' @param case_type_id Case-type identifier containing the cases.
#' @param timeout_seconds Request timeout in seconds.
#' @param post_json Function used to send the request; useful for testing or
#'   custom HTTP clients.
#' @return The decoded CASEDB phylogenetic-tree response.
#' @export
retrieve_phylogenetic_tree_by_cases <- function(
    base_url,
    access_token,
    case_ids,
    genetic_distance_col_id,
    tree_algorithm_code = "SLINK",
    case_type_id,
    timeout_seconds = 45,
    post_json = commondb_post_json
) {
    body <- list(
        case_type_id = case_type_id,
        genetic_distance_col_id = genetic_distance_col_id,
        tree_algorithm_code = tree_algorithm_code,
        case_ids = case_ids
    )
    casedb_post(
        base_url,
        "/calculate/phylogenetic_tree",
        body,
        access_token,
        timeout_seconds,
        post_json
    )
}
