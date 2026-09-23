\name{commondb_post_json}
\alias{commondb_post_json}
\title{Send an authenticated JSON POST request}
\description{Send an authenticated JSON POST request to a Gen-EpiX endpoint.}
\usage{
commondb_post_json(url, body, access_token, timeout_seconds = 45)
}
\arguments{
  \item{url}{Complete request URL.}
  \item{body}{List to encode as a JSON request body.}
  \item{access_token}{Bearer access token.}
  \item{timeout_seconds}{Request timeout in seconds.}
}
\value{The decoded JSON response as an R object.}
