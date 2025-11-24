# guidelinely

<!-- badges: start -->
<!-- badges: end -->

R client for the [Guidelinely API](https://guidelines.1681248.com/docs), an environmental guideline calculation and search API. Calculate guideline values for chemical parameters in various environmental media (water, soil, sediment) based on environmental context such as pH, hardness, and temperature.

## Installation

You can install the development version of guidelinely from GitHub using the `remotes` package:

```r
# install.packages("remotes")
remotes::install_github("mpdavison/envguidelines")
```

## Quick Start

The main API endpoints **do not require authentication**:

```r
library(guidelinely)

# Check API health status
health_check()
readiness_check()

# List all available chemical parameters
params <- list_parameters()

# Search for specific parameters
ammonia_params <- search_parameters("ammonia")

# Get available media types
media <- list_media()
```

## Calculating Guidelines

Calculate environmental guidelines for specific parameters and environmental conditions:

```r
# Set API key first
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")

# Calculate aluminum guidelines in surface water
result <- calculate_guidelines(
  parameter = "Aluminum",
  media = "surface_water",
  context = list(
    pH = "7.0 1",
    hardness = "100 mg/L",
    temperature = "20 °C"
  )
)

# Access results
library(tibble)
guidelines <- as_tibble(result$results)
```

### Batch Calculations

Calculate multiple parameters efficiently in one call:

```r
# Calculate multiple metals
results <- calculate_batch(
  parameters = list("Aluminum", "Copper", "Lead", "Zinc"),
  media = "surface_water",
  context = list(
    pH = "7.0 1",
    hardness = "100 mg/L"
  )
)

# With per-parameter unit conversion
results <- calculate_batch(
  parameters = list(
    "Aluminum",
    list(name = "Copper", target_unit = "μg/L"),
    list(name = "Lead", target_unit = "mg/L")
  ),
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L")
)
```

## Environmental Context

Different media types require different environmental context parameters. **Context values must be strings with units** (using Pint unit format).

### Water (surface_water, groundwater)

```r
context = list(
  pH = "7.0 1",              # Dimensionless (use "1" as unit)
  hardness = "100 mg/L",     # mg/L as CaCO3
  temperature = "20 °C",     # Degrees Celsius
  chloride = "50 mg/L"       # mg/L
)
```

### Soil

```r
context = list(
  pH = "6.5 1",                                # Dimensionless
  organic_matter = "3.5 %",                    # Percent
  cation_exchange_capacity = "15 meq/100g"     # meq per 100g
)
```

### Sediment

```r
context = list(
  pH = "7.0 1",              # Dimensionless
  organic_matter = "2.5 %",  # Percent
  grain_size = "0.5 mm"      # Millimeters
)
```

## Metadata Functions

Query available data and sources:

```r
# List all sources and documents
sources <- list_sources()

# Get database statistics
stats <- get_stats()

# List all media types
media <- list_media()
```

## Data Format

Guideline values are returned in [PostgreSQL `unitrange` format](https://github.com/df7cb/postgresql-unit):
- `[10 μg/L,100 μg/L]` - Range from 10 to 100 μg/L
- `(,87.0 μg/L]` - Upper limit only (≤87.0 μg/L)
- `[5.0 mg/L,)` - Lower limit only (≥5.0 mg/L)
Additionally, upper and lower bounds are returned as separate `float` values.

Results include:
- Calculated guideline values (when formulas exist)
- Static guideline values (from database)
- Source and document information
- SVG-rendered calculation formulas

## API Documentation

For complete API documentation, visit: https://guidelines.1681248.com/docs or https://guidelines.1681248.com/redoc.