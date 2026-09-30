#' Execute a Gen-EpiX CRUD command.
#'
#' Construct a command with an app-prefixed `<entity>_crud_command()` function,
#' then pass it to this function. A constructor records the operation and
#' request data; execution sends the HTTP request.
#'
#' @param base_url Base URL of the application named by the command.
#' @param access_token Bearer access token.
#' @param command A Gen-EpiX CRUD command returned by a named constructor.
#' @param timeout_seconds HTTP request timeout in seconds.
#' @param request_json Function used to send the HTTP request.
#' @return The decoded response from the corresponding API endpoint.
#' @export
execute_crud_command <- function(
    base_url,
    access_token,
    command,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    if (!inherits(command, "genepix_crud_command")) {
        stop("A Gen-EpiX CRUD command is required.", call. = FALSE)
    }

    operation <- command$operation
    operation_routes <- c(
        CREATE_ONE = "create_one", CREATE_SOME = "create_some",
        READ_ALL = "read_all", READ_SOME = "read_some", READ_ONE = "read_one",
        UPDATE_ONE = "update_one", UPDATE_SOME = "update_some",
        DELETE_ONE = "delete_one", DELETE_SOME = "delete_some",
        DELETE_ALL = "delete_all"
    )
    if (!is_single_string(operation) || !operation %in% names(operation_routes)) {
        stop("The CRUD operation is not exposed by the API.", call. = FALSE)
    }
    route <- unname(operation_routes[[operation]])
    if (!is.null(command$query_filter)) {
        if (!identical(operation, "READ_ALL") || !is.list(command$query_filter)) {
            stop("A query filter is supported only for READ_ALL.", call. = FALSE)
        }
        route <- if (isTRUE(command$return_id)) "read_query_ids" else "read_query"
    } else if (isTRUE(command$return_id)) {
        stop("return_id requires a READ_ALL query filter.", call. = FALSE)
    }
    if (!route %in% command$available_routes) {
        stop("This CRUD route is not exposed for the entity.", call. = FALSE)
    }
    if ((!is.null(command$limit) || !is.null(command$offset)) &&
        !operation %in% c("READ_ALL", "DELETE_ALL")) {
        stop("limit and offset are supported only for READ_ALL or DELETE_ALL.", call. = FALSE)
    }

    path <- command$path
    method <- switch(
        operation,
        CREATE_ONE = "POST", CREATE_SOME = "POST",
        READ_ALL = if (is.null(command$query_filter)) "GET" else "POST",
        READ_SOME = "GET", READ_ONE = "GET",
        UPDATE_ONE = "PUT", UPDATE_SOME = "PUT",
        DELETE_ONE = "DELETE", DELETE_SOME = "DELETE", DELETE_ALL = "DELETE"
    )
    body <- NULL
    object_id <- NULL
    object_ids <- NULL
    if (route %in% c("create_some", "read_some", "update_some", "delete_some")) {
        path <- paste0(path, "/batch")
    } else if (route == "read_query") {
        path <- paste0(path, "/query")
    } else if (route == "read_query_ids") {
        path <- paste0(path, "/query/ids")
    } else if (route %in% c("read_one", "update_one", "delete_one")) {
        path <- paste0(path, "/{object_id}")
    }

    if (operation %in% c("CREATE_ONE", "CREATE_SOME", "UPDATE_ONE", "UPDATE_SOME")) {
        body <- command$objs
        if (!is.list(body)) {
            stop("objs must contain the object or objects to write.", call. = FALSE)
        }
    } else if (route %in% c("read_query", "read_query_ids")) {
        body <- command$query_filter
    }
    if (operation %in% c("READ_ONE", "DELETE_ONE")) {
        object_id <- command$obj_ids
    } else if (operation %in% c("READ_SOME", "DELETE_SOME")) {
        object_ids <- command$obj_ids
    } else if (operation == "UPDATE_ONE") {
        object_id <- body[[command$id_field]]
    }
    if (operation %in% c("READ_ONE", "UPDATE_ONE", "DELETE_ONE") &&
        !is_single_string(object_id)) {
        stop("A single object ID is required.", call. = FALSE)
    }

    crud_command_request(
        base_url = base_url,
        access_token = access_token,
        path = path,
        method = method,
        body = body,
        object_id = object_id,
        object_ids = object_ids,
        limit = command$limit,
        offset = command$offset,
        timeout_seconds = timeout_seconds,
        request_json = request_json
    )
}

make_crud_command_constructor <- function(
    app, command_name, path, id_field, available_routes
) {
    function(
        operation, obj_ids = NULL, objs = NULL, query_filter = NULL,
        return_id = FALSE, limit = NULL, offset = NULL
    ) {
        new_crud_command(
            app = app, command_name = command_name, path = path,
            id_field = id_field, available_routes = available_routes,
            operation = operation, obj_ids = obj_ids, objs = objs,
            query_filter = query_filter, return_id = return_id,
            limit = limit, offset = offset
        )
    }
}

new_crud_command <- function(
    app,
    command_name,
    path,
    id_field,
    available_routes,
    operation,
    obj_ids = NULL,
    objs = NULL,
    query_filter = NULL,
    return_id = FALSE,
    limit = NULL,
    offset = NULL
) {
    structure(
        list(
            app = app,
            command_name = command_name,
            path = path,
            id_field = id_field,
            available_routes = available_routes,
            operation = operation,
            obj_ids = obj_ids,
            objs = objs,
            query_filter = query_filter,
            return_id = return_id,
            limit = limit,
            offset = offset
        ),
        class = "genepix_crud_command"
    )
}

crud_command_request <- function(
    base_url,
    access_token,
    path,
    method,
    body = NULL,
    object_id = NULL,
    object_ids = NULL,
    limit = NULL,
    offset = NULL,
    timeout_seconds = 45,
    request_json = commondb_request_json
) {
    if (!is.null(object_id)) {
        path <- sub(
            "{object_id}", utils::URLencode(object_id, reserved = TRUE),
            path, fixed = TRUE
        )
    }
    query <- character()
    if (!is.null(object_ids)) {
        if (!is.character(object_ids) || length(object_ids) == 0L ||
            anyNA(object_ids) || any(!nzchar(object_ids))) {
            stop("A non-empty character vector of object IDs is required.", call. = FALSE)
        }
        query <- c(query, paste0(
            "ids=", utils::URLencode(paste(object_ids, collapse = ","), reserved = TRUE)
        ))
    }
    for (name in c("limit", "offset")) {
        value <- get(name)
        if (!is.null(value)) {
            query <- c(query, paste0(name, "=", utils::URLencode(
                as.character(value), reserved = TRUE
            )))
        }
    }
    if (length(query) > 0L) {
        path <- paste0(path, "?", paste(query, collapse = "&"))
    }
    request_json(
        url = commondb_url(base_url, path),
        access_token = access_token,
        method = method,
        body = body,
        timeout_seconds = timeout_seconds
    )
}
