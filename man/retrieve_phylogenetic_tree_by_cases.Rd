\name{retrieve_phylogenetic_tree_by_cases}
\alias{retrieve_phylogenetic_tree_by_cases}
\title{Calculate a phylogenetic tree for cases}
\description{Calculate a phylogenetic tree for a set of cases.}
\usage{
retrieve_phylogenetic_tree_by_cases(base_url, access_token, case_ids,
                                    genetic_distance_col_id,
                                    tree_algorithm_code = "SLINK",
                                    case_type_id, timeout_seconds = 45,
                                    post_json = commondb_post_json)
}
\arguments{
  \item{base_url}{Gen-EpiX CASEDB base URL.}
  \item{access_token}{Bearer access token.}
  \item{case_ids}{Case identifiers to include in the tree.}
  \item{genetic_distance_col_id}{Case-type column containing genetic
  distances.}
  \item{tree_algorithm_code}{Tree algorithm code, defaulting to \code{SLINK}.}
  \item{case_type_id}{Case-type identifier containing the cases.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{post_json}{Function used to send the request; useful for testing or
  custom HTTP clients.}
}
\value{The decoded CASEDB phylogenetic-tree response.}
