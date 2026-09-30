\name{login_with_client_credentials}
\alias{login_with_client_credentials}
\title{Log in with the OAuth 2.0 client-credentials grant}
\description{
Obtain an access token without browser interaction. The token endpoint is read
from the identity provider's OpenID Connect discovery document and the client
authenticates with HTTP Basic credentials. Use this for automated jobs and
tests.
}
\usage{
login_with_client_credentials(discovery_url, client_id, client_secret,
                              scope = NULL, timeout_seconds = 45)
}
\arguments{
  \item{discovery_url}{URL of the OpenID Connect discovery document.}
  \item{client_id}{OAuth client identifier.}
  \item{client_secret}{OAuth client secret.}
  \item{scope}{Optional space-separated scopes to request.}
  \item{timeout_seconds}{Request timeout in seconds.}
}
\value{A single access-token string.}
\seealso{\code{\link{login_with_chromote}}}
