# API base URL
GUIDELINELY_API_BASE <- "https://guidelines.1681248.com/api/v1"

#' Check if the API service is running
#'
#' Lightweight health check that returns 200 OK if the service is running.
#' Does not check dependencies.
#'
#' @return A character string indicating service status.
#' @export
#' @examples
#' \dontrun{
#' # Check if API is running
#' health_check()
#' }
health_check <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/health")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Check if the API is ready to handle requests
#'
#' Readiness check that verifies the service can handle requests
#' (database is accessible).
#'
#' @return A character string indicating service readiness.
#' @export
#' @examples
#' \dontrun{
#' # Check if API is ready
#' readiness_check()
#' }
readiness_check <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/ready")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' List all available chemical parameters
#'
#' Get complete list of all available chemical parameters in the database.
#'
#' @return A character vector of parameter names.
#' @export
#' @examples
#' \dontrun{
#' # Get all parameters
#' params <- list_parameters()
#' }
list_parameters <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/parameters")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Search for chemical parameters
#'
#' Search for chemical parameters using case-insensitive substring matching.
#'
#' @param q Search query string. Empty string returns all parameters.
#' @param media Optional vector of media types to filter by (e.g., "surface_water", "soil").
#' @return A character vector of matching parameter names.
#' @export
#' @examples
#' \dontrun{
#' # Find all ammonia-related parameters
#' ammonia_params <- search_parameters("ammon")
#' 
#' # Find copper in surface water
#' copper_sw <- search_parameters("copper", media = "surface_water")
#' }
search_parameters <- function(q = "", media = NULL) {
  req <- httr2::request(paste0(GUIDELINELY_API_BASE, "/parameters/search")) |>
    httr2::req_url_query(q = q) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    })
  
  if (!is.null(media)) {
    req <- req |> httr2::req_body_json(list(media = media))
  }
  
  req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' List all environmental media types
#'
#' Get list of all available environmental media types (water, soil, air, etc.).
#'
#' @return A named list mapping enum names to display names.
#' @export
#' @examples
#' \dontrun{
#' # Get all media types
#' media <- list_media()
#' }
list_media <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/media")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' List all guideline sources and documents
#'
#' Get list of all guideline sources and their associated documents.
#'
#' @return A list of sources with nested document information.
#' @export
#' @examples
#' \dontrun{
#' # Get all sources
#' sources <- list_sources()
#' }
list_sources <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/sources")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Get database statistics
#'
#' Get statistics about the guideline database (counts of sources, documents, etc.).
#'
#' @return A list with database statistics.
#' @export
#' @examples
#' \dontrun{
#' # Get stats
#' stats <- get_stats()
#' }
get_stats <- function() {
  httr2::request(paste0(GUIDELINELY_API_BASE, "/stats")) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    }) |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Calculate guidelines for a parameter
#'
#' Calculate guideline values for a specific parameter in a given media type
#' with environmental context.
#'
#' @param parameter Chemical parameter name (e.g., "Aluminum", "Copper").
#' @param media Media type (e.g., "surface_water", "soil", "sediment").
#' @param context Named list of environmental parameters as strings with units.
#'   For water: pH ("7.0 1"), hardness ("100 mg/L"), temperature ("20 °C"), chloride ("50 mg/L").
#'   For soil: pH ("6.5 1"), organic_matter ("3.5 %"), cation_exchange_capacity ("15 meq/100g").
#' @param target_unit Optional unit to convert result to (e.g., "mg/L", "μg/L").
#' @param api_key Optional API key. If NULL, will use GUIDELINELY_API_KEY environment variable.
#' @return A list containing results, context, and total_count.
#' @export
#' @examples
#' \dontrun{
#' # Set API key
#' Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")
#' 
#' # Calculate aluminum in surface water
#' result <- calculate_guidelines(
#'   parameter = "Aluminum",
#'   media = "surface_water",
#'   context = list(pH = "7.0 1", hardness = "100 mg/L")
#' )
#' 
#' # Access results as tibble
#' library(tibble)
#' as_tibble(result$results)
#' }
calculate_guidelines <- function(parameter, media, context = NULL, target_unit = NULL, api_key = NULL) {
  api_key <- get_api_key(api_key)
  
  body <- list(
    parameter = parameter,
    media = media
  )
  
  if (!is.null(context)) body$context <- context
  if (!is.null(target_unit)) body$target_unit <- target_unit
  
  req <- httr2::request(paste0(GUIDELINELY_API_BASE, "/calculate")) |>
    httr2::req_body_json(body) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    })
  
  if (!is.null(api_key)) {
    req <- req |> httr2::req_headers("X-API-KEY" = api_key)
  }
  
  req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}

#' Batch calculate guidelines for multiple parameters
#'
#' Calculate guideline values for multiple parameters in a given media type
#' with shared environmental context. More efficient than multiple individual calls.
#'
#' @param parameters Character vector of parameter names, or list mixing strings
#'   and lists with 'name' and 'target_unit' fields.
#' @param media Media type (e.g., "surface_water", "soil").
#' @param context Named list of environmental parameters as strings with units.
#' @param api_key Optional API key. If NULL, will use GUIDELINELY_API_KEY environment variable.
#' @return A list containing results, context, and total_count.
#' @export
#' @examples
#' \dontrun{
#' # Set API key
#' Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")
#' 
#' # Calculate multiple metals in surface water
#' results <- calculate_batch(
#'   parameters = c("Aluminum", "Copper", "Lead"),
#'   media = "surface_water",
#'   context = list(pH = "7.0 1", hardness = "100 mg/L")
#' )
#' 
#' # With per-parameter unit conversion
#' results <- calculate_batch(
#'   parameters = list(
#'     "Aluminum",
#'     list(name = "Copper", target_unit = "μg/L"),
#'     list(name = "Lead", target_unit = "mg/L")
#'   ),
#'   media = "surface_water",
#'   context = list(pH = "7.0 1", hardness = "100 mg/L", temperature = "20 °C")
#' )
#' }
calculate_batch <- function(parameters, media, context = NULL, api_key = NULL) {
  if (length(parameters) > 50) {
    stop("Maximum 50 parameters per batch request", call. = FALSE)
  }
  
  api_key <- get_api_key(api_key)
  
  body <- list(
    parameters = parameters,
    media = media
  )
  
  if (!is.null(context)) body$context <- context
  
  req <- httr2::request(paste0(GUIDELINELY_API_BASE, "/calculate/batch")) |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    httr2::req_error(body = function(resp) {
      msg <- httr2::resp_body_json(resp)$message
      if (!is.null(msg)) msg else "API request failed"
    })
  
  if (!is.null(api_key)) {
    req <- req |> httr2::req_headers("X-API-KEY" = api_key)
  }
  
  req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
