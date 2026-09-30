\name{retrieve_user_me}
\alias{retrieve_user_me}
\title{Retrieve the authenticated user}
\description{
Retrieve the user that the access token maps to. Every Gen-EpiX application
exposes this endpoint, which makes it a cheap connection check.
}
\usage{
retrieve_user_me(base_url, access_token, timeout_seconds = 45,
                 request_json = commondb_request_json)
}
\arguments{
  \item{base_url}{Gen-EpiX application base URL.}
  \item{access_token}{Bearer access token.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{request_json}{Function used to send the request; useful for testing
  or custom HTTP clients.}
}
\value{The decoded user object.}
