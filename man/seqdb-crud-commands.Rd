\name{seqdb-crud-commands}
\alias{seqdb_allele_crud_command}
\alias{seqdb_ast_measurement_crud_command}
\alias{seqdb_ast_prediction_crud_command}
\alias{seqdb_contact_crud_command}
\alias{seqdb_data_collection_crud_command}
\alias{seqdb_data_collection_set_crud_command}
\alias{seqdb_data_collection_set_member_crud_command}
\alias{seqdb_file_crud_command}
\alias{seqdb_identifier_issuer_crud_command}
\alias{seqdb_locus_crud_command}
\alias{seqdb_locus_code_map_crud_command}
\alias{seqdb_locus_set_crud_command}
\alias{seqdb_organization_crud_command}
\alias{seqdb_organization_admin_policy_crud_command}
\alias{seqdb_organization_identifier_issuer_link_crud_command}
\alias{seqdb_organization_set_crud_command}
\alias{seqdb_organization_set_member_crud_command}
\alias{seqdb_outage_crud_command}
\alias{seqdb_pcr_measurement_crud_command}
\alias{seqdb_protocol_crud_command}
\alias{seqdb_protocol_set_crud_command}
\alias{seqdb_protocol_set_member_crud_command}
\alias{seqdb_read_set_crud_command}
\alias{seqdb_read_set_identifier_crud_command}
\alias{seqdb_ref_allele_crud_command}
\alias{seqdb_ref_seq_crud_command}
\alias{seqdb_sample_crud_command}
\alias{seqdb_sample_data_collection_link_crud_command}
\alias{seqdb_sample_identifier_crud_command}
\alias{seqdb_seq_crud_command}
\alias{seqdb_seq_category_crud_command}
\alias{seqdb_seq_category_set_crud_command}
\alias{seqdb_seq_classification_crud_command}
\alias{seqdb_seq_distance_crud_command}
\alias{seqdb_seq_identifier_crud_command}
\alias{seqdb_seq_profile_crud_command}
\alias{seqdb_seq_profile_identifier_crud_command}
\alias{seqdb_seq_taxonomy_crud_command}
\alias{seqdb_site_crud_command}
\alias{seqdb_taxon_crud_command}
\alias{seqdb_taxon_set_crud_command}
\alias{seqdb_taxon_set_member_crud_command}
\alias{seqdb_tree_algorithm_crud_command}
\alias{seqdb_tree_algorithm_class_crud_command}
\alias{seqdb_user_crud_command}
\alias{seqdb_user_invitation_crud_command}
\title{SEQDB CRUD commands}
\description{Construct CRUD commands for entities exposed by the named Gen-EpiX application. Pass the result to \code{execute_crud_command()} to send a request.}
\usage{
seqdb_allele_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_ast_measurement_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_ast_prediction_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_contact_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_data_collection_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_data_collection_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_data_collection_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_file_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_identifier_issuer_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_locus_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_locus_code_map_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_locus_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_organization_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_organization_admin_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_organization_identifier_issuer_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_organization_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_organization_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_outage_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_pcr_measurement_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_protocol_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_protocol_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_protocol_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_read_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_read_set_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_ref_allele_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_ref_seq_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_sample_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_sample_data_collection_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_sample_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_category_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_category_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_classification_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_distance_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_profile_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_profile_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_seq_taxonomy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_site_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_taxon_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_taxon_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_taxon_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_tree_algorithm_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_tree_algorithm_class_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_user_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
seqdb_user_invitation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
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
