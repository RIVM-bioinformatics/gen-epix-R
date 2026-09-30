\name{commondb-crud-commands}
\alias{commondb_contact_crud_command}
\alias{commondb_data_collection_crud_command}
\alias{commondb_data_collection_set_crud_command}
\alias{commondb_data_collection_set_member_crud_command}
\alias{commondb_identifier_issuer_crud_command}
\alias{commondb_organization_crud_command}
\alias{commondb_organization_admin_policy_crud_command}
\alias{commondb_organization_identifier_issuer_link_crud_command}
\alias{commondb_organization_set_crud_command}
\alias{commondb_organization_set_member_crud_command}
\alias{commondb_outage_crud_command}
\alias{commondb_site_crud_command}
\alias{commondb_user_crud_command}
\alias{commondb_user_invitation_crud_command}
\title{COMMONDB CRUD commands}
\description{Construct CRUD commands for entities exposed by the named Gen-EpiX application. Pass the result to \code{execute_crud_command()} to send a request.}
\usage{
commondb_contact_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_data_collection_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_data_collection_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_data_collection_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_identifier_issuer_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_organization_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_organization_admin_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_organization_identifier_issuer_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_organization_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_organization_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_outage_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_site_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_user_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
commondb_user_invitation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
}
\arguments{
  \item{operation}{API CRUD operation, such as \code{READ_ONE} or \code{CREATE_SOME}.}
  \item{obj_ids}{One ID for read/delete-one, or a character vector for read/delete-some.}
  \item{objs}{A named object list for create/update-one, or a list of objects for create/update-some. UPDATE_ONE requires the entity's ID field.}
  \item{query_filter}{Optional Gen-EpiX filter as a named R list for READ_ALL.}
  \item{return_id}{Return matching IDs for a filtered READ_ALL request.}
  \item{limit}{Optional limit for READ_ALL or DELETE_ALL.}
  \item{offset}{Optional offset for READ_ALL or DELETE_ALL.}
}
\value{A \code{genepix_crud_command} object.}
