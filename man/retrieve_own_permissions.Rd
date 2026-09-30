\name{retrieve_own_permissions}
\alias{retrieve_own_permissions}
\title{Retrieve the permissions of the authenticated user}
\description{
Retrieve the command permissions of the authenticated user.
}
\usage{
retrieve_own_permissions(base_url, access_token, timeout_seconds = 45,
                         request_json = commondb_request_json)
}
\arguments{
  \item{base_url}{Gen-EpiX application base URL.}
  \item{access_token}{Bearer access token.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{request_json}{Function used to send the request; useful for testing
  or custom HTTP clients.}
}
\value{A list of permissions, each with \code{command_name} and
\code{permission_type} fields.}
