\name{retrieve_seq_distances_by_cases}
\alias{retrieve_seq_distances_by_cases}
\title{Retrieve sequence distances for cases}
\description{Retrieve sequence distances for cases.}
\usage{
retrieve_seq_distances_by_cases(base_url, access_token, case_ids,
                                genetic_distance_col_id, case_type_id,
                                filter_other_cases = TRUE,
                                timeout_seconds = 45,
                                post_json = commondb_post_json)
}
\arguments{
  \item{base_url}{Gen-EpiX CASEDB base URL.}
  \item{access_token}{Bearer access token.}
  \item{case_ids}{Case identifiers for which to retrieve sequence distances.}
  \item{genetic_distance_col_id}{Case-type column containing genetic
  distances.}
  \item{case_type_id}{Case-type identifier containing the cases.}
  \item{filter_other_cases}{Whether to omit distances to cases not in
  \code{case_ids}, defaulting to \code{TRUE}.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{post_json}{Function used to send the request; useful for testing or
  custom HTTP clients.}
}
\value{The decoded CASEDB response containing sequence distances.}
