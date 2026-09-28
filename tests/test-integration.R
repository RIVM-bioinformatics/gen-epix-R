# Automated integration test for the Gen-EpiX R client.
#
# Unlike tests/test-client-e2e.R, this test needs no browser interaction: it
# authenticates with the OAuth 2.0 client-credentials grant and then
# (1) connects to a Gen-EpiX application as the authenticated user,
# (2) runs a create/read/update/delete cycle of CRUD commands, and
# (3) runs a non-CRUD command.
#
# Set GEN_EPIX_RUN_INTEGRATION=true to run it. The defaults match the
# docker-compose.sql.idp.yml stack of the gen-epix-api repository:
# - GEN_EPIX_APP_URL: application URL (default http://localhost:8000)
# - GEN_EPIX_OIDC_DISCOVERY_URL: OIDC discovery document
#   (default http://localhost:8080/.well-known/openid-configuration)
# - GEN_EPIX_CLIENT_ID / GEN_EPIX_CLIENT_SECRET: OAuth client (default mock)
# - GEN_EPIX_OIDC_SCOPE: optional space-separated scopes
#
# The OAuth client must map to a Gen-EpiX user that may create, update, and
# delete organization sets, such as the root user.

if (!identical(Sys.getenv("GEN_EPIX_RUN_INTEGRATION"), "true")) {
    message(
        "Skipping Gen-EpiX integration test; ",
        "set GEN_EPIX_RUN_INTEGRATION=true to run it."
    )
} else {
    repo_root <- Filter(
        function(path) file.exists(file.path(path, "R", "commondb-client.R")),
        c(".", "..")
    )
    if (length(repo_root) > 0L) {
        for (source_file in list.files(
            file.path(repo_root[[1L]], "R"),
            pattern = "\\.R$",
            full.names = TRUE
        )) {
            source(source_file)
        }
    } else if (requireNamespace("genepixR", quietly = TRUE)) {
        package_namespace <- asNamespace("genepixR")
        for (name in ls(package_namespace)) {
            assign(name, get(name, envir = package_namespace))
        }
    } else {
        stop("Install the genepixR package before running the integration test.")
    }

    env_or_default <- function(name, default) {
        value <- Sys.getenv(name, unset = "")
        if (nzchar(value)) value else default
    }

    expect <- function(condition, failure_message) {
        if (!isTRUE(condition)) {
            stop(failure_message, call. = FALSE)
        }
    }

    app_url <- env_or_default("GEN_EPIX_APP_URL", "http://localhost:8000")
    discovery_url <- env_or_default(
        "GEN_EPIX_OIDC_DISCOVERY_URL",
        "http://localhost:8080/.well-known/openid-configuration"
    )
    client_id <- env_or_default("GEN_EPIX_CLIENT_ID", "mock")
    client_secret <- env_or_default("GEN_EPIX_CLIENT_SECRET", "mock")
    scope <- env_or_default("GEN_EPIX_OIDC_SCOPE", NULL)

    # (1) Authenticate and connect to the application.
    access_token <- login_with_client_credentials(
        discovery_url,
        client_id = client_id,
        client_secret = client_secret,
        scope = scope
    )
    user <- retrieve_user_me(app_url, access_token)
    expect(
        is_single_string(user$id) && isTRUE(user$is_active),
        "The application did not return an active authenticated user."
    )
    cat("Connected to", app_url, "as user", user$id, "\n")

    # (2) Execute CRUD commands on a disposable organization set.
    entity <- "organization_sets"
    name <- sprintf(
        "genepixR integration test %s %05d",
        format(Sys.time(), "%Y%m%d%H%M%S"),
        sample.int(99999L, 1L)
    )
    created <- crud_create(
        app_url,
        access_token,
        entity,
        obj = list(name = name, description = "created")
    )
    expect(
        is_single_string(created$id) && identical(created$name, name),
        "Creating the organization set failed."
    )
    object_id <- created$id
    deleted <- FALSE
    tryCatch(
        {
            read <- crud_read_one(app_url, access_token, entity, object_id)
            expect(
                identical(read$id, object_id) && identical(read$name, name),
                "Reading the created organization set failed."
            )

            updated <- crud_update(
                app_url,
                access_token,
                entity,
                object_id,
                obj = list(name = name, description = "updated")
            )
            expect(
                identical(updated$description, "updated"),
                "Updating the organization set failed."
            )

            deleted_id <- crud_delete(app_url, access_token, entity, object_id)
            deleted <- TRUE
            expect(
                identical(deleted_id, object_id),
                "Deleting the organization set returned an unexpected ID."
            )

            remaining_ids <- vapply(
                crud_read_all(app_url, access_token, entity),
                function(obj) obj$id,
                character(1)
            )
            expect(
                !object_id %in% remaining_ids,
                "The deleted organization set is still returned."
            )
        },
        finally = if (!deleted) {
            try(
                crud_delete(app_url, access_token, entity, object_id),
                silent = TRUE
            )
        }
    )
    cat("Created, read, updated, and deleted organization set", object_id, "\n")

    # (3) Execute a non-CRUD command.
    permissions <- retrieve_own_permissions(app_url, access_token)
    permission_keys <- vapply(
        permissions,
        function(permission) {
            paste(permission$command_name, permission$permission_type)
        },
        character(1)
    )
    expect(
        "OrganizationSetCrudCommand CREATE" %in% permission_keys,
        "The retrieved permissions do not match the executed CRUD commands."
    )
    cat("Retrieved", length(permissions), "permissions of the user\n")

    cat("\nGen-EpiX R integration test succeeded.\n")
}
