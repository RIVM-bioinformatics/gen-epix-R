\name{execute_crud_command}
\alias{execute_crud_command}
\title{Execute a Gen-EpiX CRUD command}
\description{Send the API request represented by a CRUD command returned by an app-prefixed constructor.}
\usage{
execute_crud_command(base_url, access_token, command,
                     timeout_seconds = 45,
                     request_json = commondb_request_json)
}
\arguments{
  \item{base_url}{Base URL of the application named by the command.}
  \item{access_token}{Bearer access token.}
  \item{command}{A Gen-EpiX CRUD command returned by a named constructor.}
  \item{timeout_seconds}{HTTP request timeout in seconds.}
  \item{request_json}{Function used to send the HTTP request.}
}
\value{The decoded response from the corresponding API endpoint.}
