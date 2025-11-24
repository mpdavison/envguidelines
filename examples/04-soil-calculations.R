# Soil Guideline Calculations
# ===========================
# Calculate guidelines for contaminants in soil

library(guidelinely)

# Set API key
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")

# Calculate lead guidelines in soil
result <- calculate_guidelines(
  parameter = "Lead",
  media = "soil",
  context = list(
    pH = "6.5 1",                           # pH 6.5
    organic_matter = "3.5 %",               # 3.5% organic matter
    cation_exchange_capacity = "15 meq/100g"  # CEC 15 meq/100g
  )
)

cat("Lead in soil - Total guidelines:", result$total_count, "\n")

# Calculate multiple heavy metals in soil
metals <- c("Lead", "Cadmium", "Arsenic", "Chromium")

results <- calculate_batch(
  parameters = metals,
  media = "soil",
  context = list(
    pH = "6.5 1",
    organic_matter = "3.5 %"
  )
)

cat("Heavy metals in soil - Total guidelines:", results$total_count, "\n")
