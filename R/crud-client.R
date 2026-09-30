crud_request <- function(
    base_url,
    access_token,
    entity,
    object_id = NULL,
    method,
    body = NULL,
    timeout_seconds,
    request_json
) {
    if (!is_single_string(entity) || !grepl("^[a-z0-9_]+$", entity)) {
        stop(
            "The entity must be a snake_case endpoint name such as 'organization_sets'.",
            call. = FALSE
        )
    }
    path <- paste0("/v1/", entity)
    if (!is.null(object_id)) {
        if (!is_single_string(object_id)) {
            stop("A non-empty object ID is required.", call. = FALSE)
        }
        path <- paste0(path, "/", utils::URLencode(object_id, reserved = TRUE))
    }
    request_json(
        url = commondb_url(base_url, path),
        access_token = access_token,
        method = method,
        body = body,
        timeout_seconds = timeout_seconds
    )
}

#' Generic CRUD requests for Gen-EpiX entities.
#'
#' Gen-EpiX exposes every CRUD-enabled entity under `/v1/<entity>`, where
#' `<entity>` is the snake_case plural endpoint name, e.g. `organization_sets`
#' or `case_types`. These functions send the corresponding CRUD command.
#'
#' @param base_url Gen-EpiX application base URL.
#' @param access_token Bearer access token.
#' @param entity Snake_case plural endpoint name of the entity.
#' @param object_id Identifier of a single object.
#' @param obj List with the object fields to create or update.
#' @param timeout_seconds Request timeout in seconds.
#' @param request_json Function used to send the request; useful for testing
#'   or custom HTTP clients.
#' @return `crud_read_all()` returns a list of objects; `crud_read_one()`,
#'   `crud_create()`, and `crud_update()` return a single object;
#'   `crud_delete()` returns the ID of the deleted object.
#' @name crud
NULL

#' @rdname crud
#' @export
crud_read_all <- function(
    base_url,
    access_token,
    entity,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    crud_request(
        base_url,
        access_token,
        entity,
        method = "GET",
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}

#' @rdname crud
#' @export
crud_read_one <- function(
    base_url,
    access_token,
    entity,
    object_id,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    crud_request(
        base_url,
        access_token,
        entity,
        object_id = object_id,
        method = "GET",
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}

#' @rdname crud
#' @export
crud_create <- function(
    base_url,
    access_token,
    entity,
    obj,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    crud_request(
        base_url,
        access_token,
        entity,
        method = "POST",
        body = obj,
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}

#' @rdname crud
#' @export
crud_update <- function(
    base_url,
    access_token,
    entity,
    object_id,
    obj,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    obj$id <- object_id
    crud_request(
        base_url,
        access_token,
        entity,
        object_id = object_id,
        method = "PUT",
        body = obj,
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}

#' @rdname crud
#' @export
crud_delete <- function(
    base_url,
    access_token,
    entity,
    object_id,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    crud_request(
        base_url,
        access_token,
        entity,
        object_id = object_id,
        method = "DELETE",
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}
