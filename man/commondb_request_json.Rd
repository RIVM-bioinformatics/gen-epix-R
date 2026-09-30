\name{commondb_request_json}
\alias{commondb_request_json}
\title{Send an authenticated JSON request}
\description{Send an authenticated JSON request to a Gen-EpiX endpoint.}
\usage{
commondb_request_json(url, access_token, method = "GET", body = NULL,
                      timeout_seconds = 45)
}
\arguments{
  \item{url}{Complete request URL.}
  \item{access_token}{Bearer access token.}
  \item{method}{HTTP method, such as \code{GET}, \code{POST}, \code{PUT},
  or \code{DELETE}.}
  \item{body}{Optional list to encode as a JSON request body.}
  \item{timeout_seconds}{Request timeout in seconds.}
}
\value{The decoded JSON response as an R object, or \code{NULL} when the
response has no body.}
\seealso{\code{\link{commondb_post_json}}}
