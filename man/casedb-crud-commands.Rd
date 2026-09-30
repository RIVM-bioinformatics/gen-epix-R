\name{casedb-crud-commands}
\alias{casedb_case_crud_command}
\alias{casedb_case_data_collection_link_crud_command}
\alias{casedb_case_identifier_crud_command}
\alias{casedb_case_set_crud_command}
\alias{casedb_case_set_category_crud_command}
\alias{casedb_case_set_data_collection_link_crud_command}
\alias{casedb_case_set_member_crud_command}
\alias{casedb_case_set_status_crud_command}
\alias{casedb_case_type_crud_command}
\alias{casedb_case_type_set_crud_command}
\alias{casedb_case_type_set_category_crud_command}
\alias{casedb_case_type_set_member_crud_command}
\alias{casedb_col_crud_command}
\alias{casedb_col_set_crud_command}
\alias{casedb_col_set_member_crud_command}
\alias{casedb_concept_crud_command}
\alias{casedb_concept_relation_crud_command}
\alias{casedb_concept_set_crud_command}
\alias{casedb_contact_crud_command}
\alias{casedb_data_collection_crud_command}
\alias{casedb_data_collection_set_crud_command}
\alias{casedb_data_collection_set_member_crud_command}
\alias{casedb_dim_crud_command}
\alias{casedb_disease_crud_command}
\alias{casedb_etiological_agent_crud_command}
\alias{casedb_etiology_crud_command}
\alias{casedb_genetic_distance_protocol_crud_command}
\alias{casedb_identifier_issuer_crud_command}
\alias{casedb_organization_crud_command}
\alias{casedb_organization_access_case_policy_crud_command}
\alias{casedb_organization_admin_policy_crud_command}
\alias{casedb_organization_identifier_issuer_link_crud_command}
\alias{casedb_organization_set_crud_command}
\alias{casedb_organization_set_member_crud_command}
\alias{casedb_organization_share_case_policy_crud_command}
\alias{casedb_outage_crud_command}
\alias{casedb_ref_col_crud_command}
\alias{casedb_ref_dim_crud_command}
\alias{casedb_region_crud_command}
\alias{casedb_region_relation_crud_command}
\alias{casedb_region_set_crud_command}
\alias{casedb_region_set_shape_crud_command}
\alias{casedb_site_crud_command}
\alias{casedb_tree_algorithm_crud_command}
\alias{casedb_tree_algorithm_class_crud_command}
\alias{casedb_user_crud_command}
\alias{casedb_user_access_case_policy_crud_command}
\alias{casedb_user_invitation_crud_command}
\alias{casedb_user_share_case_policy_crud_command}
\title{CASEDB CRUD commands}
\description{Construct CRUD commands for entities exposed by the named Gen-EpiX application. Pass the result to \code{execute_crud_command()} to send a request.}
\usage{
casedb_case_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_data_collection_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_set_category_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_set_data_collection_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_set_status_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_type_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_type_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_type_set_category_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_case_type_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_col_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_col_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_col_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_concept_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_concept_relation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_concept_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_contact_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_data_collection_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_data_collection_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_data_collection_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_dim_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_disease_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_etiological_agent_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_etiology_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_genetic_distance_protocol_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_identifier_issuer_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_access_case_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_admin_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_identifier_issuer_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_organization_share_case_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_outage_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_ref_col_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_ref_dim_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_region_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_region_relation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_region_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_region_set_shape_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_site_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_tree_algorithm_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_tree_algorithm_class_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_user_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_user_access_case_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_user_invitation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
casedb_user_share_case_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
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
