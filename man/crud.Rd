\name{crud}
\alias{crud}
\alias{crud_read_all}
\alias{crud_read_one}
\alias{crud_create}
\alias{crud_update}
\alias{crud_delete}
\title{Generic CRUD requests for Gen-EpiX entities}
\description{
Gen-EpiX exposes every CRUD-enabled entity under \code{/v1/<entity>}, where
\code{<entity>} is the snake_case plural endpoint name, e.g.
\code{organization_sets} or \code{case_types}. These functions send the
corresponding CRUD command.
}
\usage{
crud_read_all(base_url, access_token, entity, timeout_seconds = 45,
              request_json = commondb_request_json)
crud_read_one(base_url, access_token, entity, object_id,
              timeout_seconds = 45, request_json = commondb_request_json)
crud_create(base_url, access_token, entity, obj, timeout_seconds = 45,
            request_json = commondb_request_json)
crud_update(base_url, access_token, entity, object_id, obj,
            timeout_seconds = 45, request_json = commondb_request_json)
crud_delete(base_url, access_token, entity, object_id,
            timeout_seconds = 45, request_json = commondb_request_json)
}
\arguments{
  \item{base_url}{Gen-EpiX application base URL.}
  \item{access_token}{Bearer access token.}
  \item{entity}{Snake_case plural endpoint name of the entity.}
  \item{object_id}{Identifier of a single object.}
  \item{obj}{List with the object fields to create or update. For updates,
  its \code{id} field is set to \code{object_id}.}
  \item{timeout_seconds}{Request timeout in seconds.}
  \item{request_json}{Function used to send the request; useful for testing
  or custom HTTP clients.}
}
\value{
\code{crud_read_all()} returns a list of objects; \code{crud_read_one()},
\code{crud_create()}, and \code{crud_update()} return a single object;
\code{crud_delete()} returns the ID of the deleted object.
}
