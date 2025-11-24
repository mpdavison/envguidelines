# guidelinely Examples

This directory contains practical examples demonstrating how to use the guidelinely package.

## Quick Start

Before running these examples, install the package and set your API key:

```r
# Install package
remotes::install_github("mpdavison/envguidelines")

# Set API key (required for calculation endpoints)
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")
```

## Examples

### 1. Basic Metadata Queries (`01-basic-metadata.R`)
Learn how to explore available parameters, media types, and data sources. No API key required.

```r
# List all parameters
params <- list_parameters()

# Search for specific parameters
ammonia <- search_parameters("ammonia")

# Get media types
media <- list_media()
```

### 2. Calculate Single Parameter (`02-calculate-single-parameter.R`)
Calculate guidelines for a single chemical parameter with environmental context.

```r
result <- calculate_guidelines(
  parameter = "Aluminum",
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L")
)
```

### 3. Batch Calculations (`03-batch-calculations.R`)
Efficiently calculate multiple parameters at once - faster than individual calls.

```r
results <- calculate_batch(
  parameters = c("Aluminum", "Copper", "Lead", "Zinc"),
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L")
)
```

### 4. Soil Calculations (`04-soil-calculations.R`)
Calculate guidelines for contaminants in soil with soil-specific context parameters.

```r
result <- calculate_guidelines(
  parameter = "Lead",
  media = "soil",
  context = list(
    pH = "6.5 1",
    organic_matter = "3.5 %",
    cation_exchange_capacity = "15 meq/100g"
  )
)
```

### 5. Tidyverse Workflow (`05-tidyverse-workflow.R`)
Integrate guidelinely with dplyr and other tidyverse tools for data analysis.

```r
guidelines <- as_tibble(results$results) %>%
  filter(receptor == "Aquatic Life") %>%
  select(parameter, value, source) %>%
  arrange(parameter)
```

## Environmental Context

Context parameters must be strings with units (Pint format):

**Water:**
- pH: `"7.0 1"` (dimensionless, use "1" as unit)
- Hardness: `"100 mg/L"` (as CaCO3)
- Temperature: `"20 °C"`
- Chloride: `"50 mg/L"`

**Soil:**
- pH: `"6.5 1"`
- Organic matter: `"3.5 %"`
- CEC: `"15 meq/100g"`

## Need Help?

- API Documentation: https://guidelines.1681248.com/docs
- Package Issues: https://github.com/mpdavison/envguidelines/issues
