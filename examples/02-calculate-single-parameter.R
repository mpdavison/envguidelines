# Calculate Guidelines for a Single Parameter
# ===========================================
# Calculate aluminum guidelines in surface water with specific conditions

library(guidelinely)
library(tibble)  # For viewing results as data frames

# Set your API key (required for calculation endpoints)
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")

# Calculate aluminum guidelines in surface water
result <- calculate_guidelines(
  parameter = "Aluminum",
  media = "surface_water",
  context = list(
    pH = "7.0 1",           # pH 7.0 (dimensionless, use "1" as unit)
    hardness = "100 mg/L"   # 100 mg/L as CaCO3
  )
)

# View the results
cat("Total guidelines found:", result$total_count, "\n")

# Convert results to a tibble for easy viewing
if (result$total_count > 0) {
  guidelines <- as_tibble(result$results)
  print(guidelines)
  
  # View specific columns
  print(guidelines[c("parameter", "value", "unit", "receptor", "source")])
}

# Example with unit conversion
result_mg <- calculate_guidelines(
  parameter = "Aluminum",
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L"),
  target_unit = "mg/L"  # Convert to mg/L
)
