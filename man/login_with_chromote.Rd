\name{login_with_chromote}
\alias{login_with_chromote}
\title{Log in through an interactive browser session}
\description{
Open a Chromote viewer at a Gen-EpiX login page and poll the browser's OIDC
session storage until an access token is available.
}
\usage{
login_with_chromote(login_url, timeout_seconds = 300,
                    poll_interval_seconds = 1)
}
\arguments{
  \item{login_url}{URL of the Gen-EpiX web application login page.}
  \item{timeout_seconds}{Maximum time to wait for login completion.}
  \item{poll_interval_seconds}{Time between browser-session polls.}
}
\value{A single access-token string.}
