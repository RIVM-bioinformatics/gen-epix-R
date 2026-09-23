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
management and call the client functions directly.

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
