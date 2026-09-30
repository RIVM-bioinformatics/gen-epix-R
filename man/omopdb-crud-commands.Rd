\name{omopdb-crud-commands}
\alias{omopdb_care_site_crud_command}
\alias{omopdb_cdm_source_crud_command}
\alias{omopdb_cohort_crud_command}
\alias{omopdb_cohort_definition_crud_command}
\alias{omopdb_concept_crud_command}
\alias{omopdb_concept_ancestor_crud_command}
\alias{omopdb_concept_class_crud_command}
\alias{omopdb_concept_relationship_crud_command}
\alias{omopdb_concept_synonym_crud_command}
\alias{omopdb_condition_era_crud_command}
\alias{omopdb_condition_occurrence_crud_command}
\alias{omopdb_condition_occurrence_identifier_crud_command}
\alias{omopdb_contact_crud_command}
\alias{omopdb_cost_crud_command}
\alias{omopdb_data_collection_crud_command}
\alias{omopdb_data_collection_set_crud_command}
\alias{omopdb_data_collection_set_member_crud_command}
\alias{omopdb_death_crud_command}
\alias{omopdb_death_identifier_crud_command}
\alias{omopdb_device_exposure_crud_command}
\alias{omopdb_device_exposure_identifier_crud_command}
\alias{omopdb_domain_crud_command}
\alias{omopdb_dose_era_crud_command}
\alias{omopdb_drug_era_crud_command}
\alias{omopdb_drug_exposure_crud_command}
\alias{omopdb_drug_exposure_identifier_crud_command}
\alias{omopdb_drug_strength_crud_command}
\alias{omopdb_episode_crud_command}
\alias{omopdb_episode_event_crud_command}
\alias{omopdb_fact_relationship_crud_command}
\alias{omopdb_identifier_issuer_crud_command}
\alias{omopdb_location_crud_command}
\alias{omopdb_measurement_crud_command}
\alias{omopdb_measurement_identifier_crud_command}
\alias{omopdb_measurement_relation_crud_command}
\alias{omopdb_measurement_relation_identifier_crud_command}
\alias{omopdb_metadata_crud_command}
\alias{omopdb_note_crud_command}
\alias{omopdb_note_identifier_crud_command}
\alias{omopdb_note_nlp_crud_command}
\alias{omopdb_note_nlp_identifier_crud_command}
\alias{omopdb_observation_crud_command}
\alias{omopdb_observation_identifier_crud_command}
\alias{omopdb_observation_period_crud_command}
\alias{omopdb_observation_period_identifier_crud_command}
\alias{omopdb_organization_crud_command}
\alias{omopdb_organization_admin_policy_crud_command}
\alias{omopdb_organization_identifier_issuer_link_crud_command}
\alias{omopdb_organization_set_crud_command}
\alias{omopdb_organization_set_member_crud_command}
\alias{omopdb_outage_crud_command}
\alias{omopdb_payer_plan_period_crud_command}
\alias{omopdb_person_crud_command}
\alias{omopdb_person_identifier_crud_command}
\alias{omopdb_procedure_occurrence_crud_command}
\alias{omopdb_procedure_occurrence_identifier_crud_command}
\alias{omopdb_provider_crud_command}
\alias{omopdb_relationship_crud_command}
\alias{omopdb_site_crud_command}
\alias{omopdb_source_to_concept_map_crud_command}
\alias{omopdb_specimen_crud_command}
\alias{omopdb_specimen_identifier_crud_command}
\alias{omopdb_user_crud_command}
\alias{omopdb_user_invitation_crud_command}
\alias{omopdb_visit_detail_crud_command}
\alias{omopdb_visit_detail_identifier_crud_command}
\alias{omopdb_visit_occurrence_crud_command}
\alias{omopdb_visit_occurrence_identifier_crud_command}
\alias{omopdb_vocabulary_crud_command}
\title{OMOPDB CRUD commands}
\description{Construct CRUD commands for entities exposed by the named Gen-EpiX application. Pass the result to \code{execute_crud_command()} to send a request.}
\usage{
omopdb_care_site_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_cdm_source_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_cohort_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_cohort_definition_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_concept_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_concept_ancestor_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_concept_class_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_concept_relationship_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_concept_synonym_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_condition_era_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_condition_occurrence_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_condition_occurrence_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_contact_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_cost_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_data_collection_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_data_collection_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_data_collection_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_death_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_death_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_device_exposure_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_device_exposure_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_domain_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_dose_era_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_drug_era_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_drug_exposure_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_drug_exposure_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_drug_strength_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_episode_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_episode_event_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_fact_relationship_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_identifier_issuer_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_location_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_measurement_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_measurement_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_measurement_relation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_measurement_relation_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_metadata_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_note_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_note_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_note_nlp_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_note_nlp_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_observation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_observation_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_observation_period_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_observation_period_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_organization_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_organization_admin_policy_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_organization_identifier_issuer_link_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_organization_set_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_organization_set_member_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_outage_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_payer_plan_period_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_person_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_person_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_procedure_occurrence_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_procedure_occurrence_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_provider_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_relationship_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_site_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_source_to_concept_map_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_specimen_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_specimen_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_user_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_user_invitation_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_visit_detail_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_visit_detail_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_visit_occurrence_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_visit_occurrence_identifier_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
omopdb_vocabulary_crud_command(operation, obj_ids = NULL, objs = NULL, query_filter = NULL, return_id = FALSE, limit = NULL, offset = NULL)
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
