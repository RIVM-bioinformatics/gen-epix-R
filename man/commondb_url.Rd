\name{commondb_url}
\alias{commondb_url}
\title{Join a Gen-EpiX base URL and API path}
\description{Join a Gen-EpiX base URL and API path with one separator slash.}
\usage{
commondb_url(base_url, path)
}
\arguments{
  \item{base_url}{Gen-EpiX application base URL.}
  \item{path}{Absolute or relative API path.}
}
\value{A URL with exactly one slash between the base URL and path.}
