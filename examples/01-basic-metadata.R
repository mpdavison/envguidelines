# Basic Metadata Queries
# =====================
# Explore available parameters, media types, and data sources

library(guidelinely)

# List all available chemical parameters
all_params <- list_parameters()
head(all_params, 10)

# Search for specific parameters (e.g., ammonia)
ammonia_params <- search_parameters("ammonia")
print(ammonia_params)

# Get all available media types
media_types <- list_media()
print(media_types)

# View guideline sources and documents
sources <- list_sources()
print(sources[[1]])  # View first source

# Get database statistics
stats <- get_stats()
print(stats)
