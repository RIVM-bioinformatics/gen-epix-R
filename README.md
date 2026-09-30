# genepixR

`genepixR` is an R package for calling the Gen-EpiX API. It contains only
generic API-client code so RIVM-specific analysis scripts can depend on the
package without importing the Gen-EpiX backend repository.

## Install

Install the package from the private GitHub repository:

```r
install.packages("remotes")
remotes::install_github("RIVM-bioinformatics/gen-epix-R")
```

The package uses `httr2` for HTTP requests. Install `chromote` as well when
interactive browser login is needed:

```r
install.packages(c("httr2", "chromote"))
```

## Use the CASEDB client

The case type and column identifiers are deliberately supplied by the caller;
the package does not contain disease- or organization-specific identifiers.

```r
library(genepixR)

case_type_id <- "case-type-id"
case_db_url <- "https://casedb.example"
login_url <- "https://casedb.example"

access_token <- login_with_chromote(login_url)
query_result <- retrieve_cases_by_query(
    case_db_url,
    access_token,
    case_type_id = case_type_id
)
case_ids <- unlist(query_result$case_ids, use.names = FALSE)
cases <- retrieve_cases_by_id(
    case_db_url,
    access_token,
    case_ids = case_ids,
    case_type_id = case_type_id
)
```

For non-interactive jobs, provide an access token through the job's secret
management and call the client functions directly, or obtain one with the
OAuth 2.0 client-credentials grant:

```r
access_token <- login_with_client_credentials(
    "https://idp.example/.well-known/openid-configuration",
    client_id = Sys.getenv("GEN_EPIX_CLIENT_ID"),
    client_secret = Sys.getenv("GEN_EPIX_CLIENT_SECRET")
)
```

## Use the generic clients

`retrieve_user_me()` and `retrieve_own_permissions()` work against every
Gen-EpiX application. The `crud_*()` functions send CRUD commands for any
entity exposed under `/v1/<entity>`:

```r
app_url <- "https://casedb.example"
organization_set <- crud_create(
    app_url,
    access_token,
    "organization_sets",
    obj = list(name = "Example set")
)
crud_read_one(app_url, access_token, "organization_sets", organization_set$id)
crud_update(
    app_url,
    access_token,
    "organization_sets",
    organization_set$id,
    obj = list(name = "Example set", description = "Updated")
)
crud_delete(app_url, access_token, "organization_sets", organization_set$id)
```

## Retrieve all cases from the command line

After installing the package, the generic example script is available in the
repository at `inst/scripts/retrieve_all_cases.R`. It retrieves all visible
cases for one case type and stores the result as an RDS file:

```console
export GEN_EPIX_ACCESS_TOKEN="..."
Rscript inst/scripts/retrieve_all_cases.R \
    "https://casedb.example" \
    "case-type-id" \
    "cases.rds"
```

For interactive authentication, omit `GEN_EPIX_ACCESS_TOKEN` and set
`GEN_EPIX_LOGIN_URL` to the web application URL. The script will open a
Chromote browser window and wait for login.

## Tests

Run the unit tests from the repository root:

```console
Rscript tests/test-client.R
```

The interactive CASEDB test is kept separate and runs only when explicitly
enabled:

```console
GEN_EPIX_RUN_E2E=true Rscript tests/test-client-e2e.R
```

### Automated integration test

`tests/test-integration.R` needs no browser interaction. It authenticates
with the client-credentials grant, connects to an application as the
authenticated user, creates, reads, updates, and deletes an organization set
and retrieves the case sets, logging at most the first five (CRUD commands),
and retrieves the user's permissions (a non-CRUD command). Because case sets
are a CASEDB entity, `GEN_EPIX_APP_URL` must point to CASEDB. The test runs
only when explicitly enabled.

Its defaults match the `docker-compose.sql.idp.yml` stack of the
[gen-epix-api](https://github.com/RIVM-bioinformatics/gen-epix-api)
repository, in which the `mock` OAuth client maps to the root user:

```console
# In gen-epix-api
docker compose -f docker-compose.sql.idp.yml up -d --wait

# In gen-epix-R
GEN_EPIX_RUN_INTEGRATION=true Rscript tests/test-integration.R
```

Override the defaults to target another application or identity provider:

| Variable | Default |
| --- | --- |
| `GEN_EPIX_APP_URL` | `http://localhost:8000` (CASEDB) |
| `GEN_EPIX_OIDC_DISCOVERY_URL` | `http://localhost:8080/.well-known/openid-configuration` |
| `GEN_EPIX_CLIENT_ID` | `mock` |
| `GEN_EPIX_CLIENT_SECRET` | `mock` |
| `GEN_EPIX_OIDC_SCOPE` | none |

The OAuth client must map to a user that may create, update, and delete
organization sets. For HTTPS endpoints with a self-signed certificate, point
`CURL_CA_BUNDLE` to that certificate.
