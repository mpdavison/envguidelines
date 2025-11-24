# Authentication helpers for analytics endpoints (optional)
# The main API endpoints do not require authentication

#' Get API key from environment or argument
#'
#' Optional helper for analytics endpoints that require authentication.
#' Main guideline endpoints do not require authentication.
#'
#' @param api_key Optional API key. If NULL, will look for GUIDELINELY_API_KEY
#'   environment variable.
#' @return API key string or NULL if not provided
#' @keywords internal
#' @noRd
get_api_key <- function(api_key = NULL) {
  api_key <- api_key %||% Sys.getenv("GUIDELINELY_API_KEY")
  if (api_key == "") return(NULL)
  api_key
}
