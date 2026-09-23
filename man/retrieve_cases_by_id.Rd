\name{retrieve_cases_by_id}
\alias{retrieve_cases_by_id}
\title{Retrieve case data by case IDs}
\description{Retrieve case data for a set of IDs from a case type.}
\usage{
retrieve_cases_by_id(base_url, access_token, case_ids, case_type_id,
                     timeout_seconds = 45,
                     post_json = commondb_post_json)
}
\arguments{
  \item{base_url}{Gen-EpiX CASEDB base URL.}
  \item{access_token}{Bearer access token.}
  \item{case_ids}{Case identifiers to retrieve.}
  \item{case_type_id}{Case-type identifier containing the cases.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{post_json}{Function used to send the request; useful for testing or
  custom HTTP clients.}
}
\value{A decoded CASEDB response containing the requested cases.}
