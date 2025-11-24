# Tidyverse Workflow Example
# ==========================
# Integrate guidelinely with dplyr, tidyr, and ggplot2

library(guidelinely)
library(dplyr)
library(tibble)

# Set API key
Sys.setenv(GUIDELINELY_API_KEY = "your_api_key_here")

# Calculate multiple parameters
results <- calculate_batch(
  parameters = c("Aluminum", "Copper", "Lead", "Zinc", "Cadmium"),
  media = "surface_water",
  context = list(pH = "7.0 1", hardness = "100 mg/L")
)

# Convert to tibble and use dplyr
guidelines <- as_tibble(results$results)

# Filter and select
chronic_guidelines <- guidelines %>%
  filter(
    receptor == "Aquatic Life",
    exposure_duration == "chronic"
  ) %>%
  select(parameter, value, upper, unit, source, document) %>%
  arrange(parameter)

print(chronic_guidelines)

# Group and summarize
summary_by_param <- guidelines %>%
  group_by(parameter) %>%
  summarise(
    n_guidelines = n(),
    sources = paste(unique(source), collapse = ", "),
    .groups = "drop"
  )

print(summary_by_param)

# Extract numeric upper limits for plotting
guidelines_with_limits <- guidelines %>%
  filter(!is.na(upper)) %>%
  select(parameter, upper, unit, receptor)

print(guidelines_with_limits)
