# Batch Calculate Multiple Parameters
# ====================================
# Efficiently calculate guidelines for multiple parameters at once

library(guidelinely)
library(tibble)

# Set API key
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")

# Calculate multiple metals in surface water
metals <- c("Aluminum", "Copper", "Lead", "Zinc")

results <- calculate_batch(
  parameters = metals,
  media = "surface_water",
  context = list(
    pH = "7.0 1",
    hardness = "100 mg/L",
    temperature = "20 °C"
  )
)

cat("Total guidelines found:", results$total_count, "\n")

# View all results
if (results$total_count > 0) {
  all_guidelines <- as_tibble(results$results)
  print(all_guidelines[c("parameter", "value", "receptor", "source")])
}

# Batch with per-parameter unit conversion
results_mixed <- calculate_batch(
  parameters = list(
    "Aluminum",
    list(name = "Copper", target_unit = "μg/L"),
    list(name = "Lead", target_unit = "mg/L")
  ),
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L")
)
