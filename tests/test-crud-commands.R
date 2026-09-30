# Validate one constructor per composed API CRUD command and the shared executor.
repo_root <- Filter(
    function(path) file.exists(file.path(path, "R", "crud-command-client.R")),
    c(".", "..")
)
if (length(repo_root) > 0L) {
    root <- repo_root[[1L]]
    for (source_file in list.files(
        file.path(root, "R"), pattern = "\\.R$", full.names = TRUE
    )) {
        source(source_file)
    }
    catalog_path <- file.path(root, "inst", "extdata", "crud-commands.csv")
} else {
    package_namespace <- asNamespace("genepixR")
    for (name in ls(package_namespace)) {
        assign(name, get(name, envir = package_namespace))
    }
    catalog_path <- system.file(
        "extdata", "crud-commands.csv", package = "genepixR"
    )
}

commands <- utils::read.csv(
    catalog_path, stringsAsFactors = FALSE, check.names = FALSE
)
stopifnot(
    nrow(commands) > 0L,
    identical(sort(unique(commands$app)), sort(c(
        "commondb", "casedb", "seqdb", "omopdb"
    ))),
    !anyDuplicated(commands[["function"]]),
    all(vapply(commands[["function"]], exists, logical(1), mode = "function"))
)

for (index in seq_len(nrow(commands))) {
    entry <- commands[index, ]
    command <- do.call(get(entry[["function"]]), list(operation = "READ_ALL"))
    stopifnot(
        inherits(command, "genepix_crud_command"),
        identical(command$app, entry$app),
        identical(command$command_name, entry$command),
        identical(command$path, entry$path),
        identical(command$id_field, entry$id_field),
        identical(command$available_routes, strsplit(entry$routes, ";", fixed = TRUE)[[1L]]),
        identical(command$operation, "READ_ALL")
    )
}

record_request <- function(url, access_token, method, body, timeout_seconds) {
    list(
        url = url,
        access_token = access_token,
        method = method,
        body = body,
        timeout_seconds = timeout_seconds
    )
}
execute <- function(operation, ..., constructor = commondb_contact_crud_command) {
    command <- constructor(operation = operation, ...)
    execute_crud_command(
        "https://api.example/", "test-token", command,
        request_json = record_request
    )
}
assert_request <- function(result, path, method, body = NULL) {
    stopifnot(
        identical(result$url, paste0("https://api.example", path)),
        identical(result$method, method),
        identical(result$body, body),
        identical(result$access_token, "test-token"),
        identical(result$timeout_seconds, 45)
    )
}
expect_error <- function(expr, fragment) {
    message <- tryCatch({
        force(expr)
        NULL
    }, error = function(error) conditionMessage(error))
    stopifnot(is.character(message), grepl(fragment, message, fixed = TRUE))
}

base <- "/v1/contacts"
obj <- list(id = "object-1", name = "example")
objs <- list(obj, list(id = "object-2", name = "other"))
ids <- c("object-1", "object-2")
filter <- list(type = "equals_uuid", key = "id", value = "object-1")

assert_request(execute("CREATE_ONE", objs = obj), base, "POST", obj)
assert_request(execute("CREATE_SOME", objs = objs), paste0(base, "/batch"), "POST", objs)
assert_request(execute("READ_ALL", limit = 5L, offset = 2L),
    paste0(base, "?limit=5&offset=2"), "GET")
assert_request(execute("READ_SOME", obj_ids = ids),
    paste0(base, "/batch?ids=object-1%2Cobject-2"), "GET")
assert_request(execute("READ_ONE", obj_ids = "object-1"),
    paste0(base, "/object-1"), "GET")
assert_request(execute("READ_ALL", query_filter = filter),
    paste0(base, "/query"), "POST", filter)
assert_request(execute("READ_ALL", query_filter = filter, return_id = TRUE),
    paste0(base, "/query/ids"), "POST", filter)
assert_request(execute("UPDATE_ONE", objs = obj),
    paste0(base, "/object-1"), "PUT", obj)
assert_request(execute("UPDATE_SOME", objs = objs),
    paste0(base, "/batch"), "PUT", objs)
assert_request(execute("DELETE_ONE", obj_ids = "object-1"),
    paste0(base, "/object-1"), "DELETE")
assert_request(execute("DELETE_SOME", obj_ids = ids),
    paste0(base, "/batch?ids=object-1%2Cobject-2"), "DELETE")
assert_request(execute("DELETE_ALL", limit = 5L, offset = 2L),
    paste0(base, "?limit=5&offset=2"), "DELETE")

# OMOP commands use entity-specific ID fields rather than a universal `id`.
omop_obj <- list(concept_id = "concept-1", concept_name = "example")
assert_request(execute("UPDATE_ONE", objs = omop_obj,
    constructor = omopdb_concept_crud_command),
    "/v1/Concepts/concept-1", "PUT", omop_obj)

expect_error(execute("UPSERT_ONE", objs = obj), "not exposed")
expect_error(execute("EXISTS_ONE", obj_ids = "object-1"), "not exposed")
expect_error(execute("DELETE_ALL", query_filter = filter), "only for READ_ALL")
expect_error(execute("READ_ALL", return_id = TRUE), "requires a READ_ALL query filter")
expect_error(execute("UPDATE_ONE", objs = list(name = "missing id")),
    "A single object ID is required")

cat("Validated", nrow(commands), "CRUD constructors and executor routes.\n")
