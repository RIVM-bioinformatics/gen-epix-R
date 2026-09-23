\name{retrieve_cases_by_query}
\alias{retrieve_cases_by_query}
\title{Retrieve case IDs for a case type}
\description{
Retrieve the IDs of cases visible to the authenticated user for a supplied
case type.
}
\usage{
retrieve_cases_by_query(base_url, access_token, case_type_id,
                        timeout_seconds = 45,
                        post_json = commondb_post_json)
}
\arguments{
  \item{base_url}{Gen-EpiX CASEDB base URL.}
  \item{access_token}{Bearer access token.}
  \item{case_type_id}{Case-type identifier to query.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{post_json}{Function used to send the request; useful for testing or
  custom HTTP clients.}
}
\value{The decoded CASEDB response, including its \code{case_ids} field.}
\seealso{\code{\link{retrieve_cases_by_id}}}
