

# Install necessary packages
if (!requireNamespace("rgbif", quietly = TRUE)) {
  install.packages("rgbif")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("sf", quietly = TRUE)) {
  install.packages("sf")
}
if (!requireNamespace("sp", quietly = TRUE)) {
  install.packages("sp")
}
if (!requireNamespace("rgeos", quietly = TRUE)) {
  install.packages("rgeos")
}

# Load the packages
library(rgbif)
library(dplyr)
library(sf)
library(sp)
library(rgeos)

# Define the species name
species_name <- "Callitris preissii"

# Download occurrence data from GBIF
occ_data <- occ_search(
  scientificName = species_name,
  limit = 20000 # Adjust the limit as needed
)

# Convert the data to a dataframe
occ_df <- occ_data$data

# Perform initial cleaning
cleaned_occ_df <- occ_df %>%
  filter(!is.na(decimalLatitude) & !is.na(decimalLongitude)) %>%  # Remove records with missing coordinates
  filter(!is.na(year)) %>%                                        # Remove records with missing year
  filter(basisOfRecord %in% c("PRESERVED_SPECIMEN", "OBSERVATION", "HUMAN_OBSERVATION")) %>% # Filter by basis of record
  filter(year >= 1900) %>%                                        # Remove records before 1900
  filter(coordinateUncertaintyInMeters <= 1000 | is.na(coordinateUncertaintyInMeters)) %>%  # Remove records with high uncertainty
  distinct(decimalLatitude, decimalLongitude, .keep_all = TRUE)   # Remove duplicate records

# Check and validate coordinates
valid_coords <- st_as_sf(cleaned_occ_df, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
valid_coords <- valid_coords %>%
  filter(!st_is_empty(geometry)) %>% # Remove empty geometries
  filter(st_is_valid(geometry))      # Remove invalid geometries

# Remove outliers
# Convert to SpatialPointsDataFrame for outlier detection
coords_sp <- as(valid_coords, "Spatial")

# Calculate centroid and distances
centroid <- gCentroid(coords_sp, byid = FALSE)
distances <- spDistsN1(coords_sp, centroid, longlat = TRUE)

# Calculate threshold distance (e.g., 3 standard deviations)
threshold_distance <- mean(distances) + 3 * sd(distances)

# Filter out points beyond the threshold distance
coords_sp <- coords_sp[distances <= threshold_distance, ]

# Convert back to dataframe if necessary
cleaned_occ_df <- as.data.frame(st_as_sf(coords_sp))

# Extract coordinates and add back to dataframe
coords <- st_coordinates(valid_coords)
cleaned_occ_df <- valid_coords %>%
  st_drop_geometry() %>%
  mutate(latitude = coords[, 2], longitude = coords[, 1])

# Save the cleaned data to a CSV file
write.csv(cleaned_occ_df, "cleaned_Callitris_preissii_GBIF_records.csv", row.names = FALSE)

# Display the cleaned data
print(cleaned_occ_df)



#CHECKING CORRELATION AMONGS ENV VARIABLES 


# Install necessary packages if not already installed
if (!requireNamespace("raster", quietly = TRUE)) {
  install.packages("raster")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("Hmisc", quietly = TRUE)) {
  install.packages("Hmisc")
}

# Load the packages
library(raster)
library(dplyr)
library(Hmisc)

# Download WorldClim data (bio variables at 10 minutes resolution)
# This example uses WorldClim v2.1 for demonstration purposes
wc_data <- getData("worldclim", var = "bio", res = 10)

# Stack the downloaded layers
wc_stack <- stack(wc_data)

# Extract variable values
wc_values <- getValues(wc_stack)

# Remove rows with NA values
wc_values <- na.omit(wc_values)

# Compute correlation matrix
cor_matrix <- rcorr(as.matrix(wc_values))

# Get the correlation values
cor_values <- cor_matrix$r

# Get the p-values
p_values <- cor_matrix$P

# Find highly correlated variables (e.g., correlation coefficient > 0.75)
highly_correlated <- which(abs(cor_values) > 0.75 & abs(cor_values) < 1, arr.ind = TRUE)

# Display highly correlated variable pairs
correlated_pairs <- data.frame(
  Var1 = rownames(cor_values)[highly_correlated[, 1]],
  Var2 = colnames(cor_values)[highly_correlated[, 2]],
  Correlation = cor_values[highly_correlated]
)

# Print the highly correlated variable pairs
print(correlated_pairs)

# Save the correlation matrix to a CSV file
write.csv(cor_values, "worldclim_correlation_matrix.csv", row.names = TRUE)

# Display the correlation matrix
print(cor_values)


#2ND CODE

# Install necessary packages if not already installed
if (!requireNamespace("geodata", quietly = TRUE)) {
  install.packages("geodata")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("Hmisc", quietly = TRUE)) {
  install.packages("Hmisc")
}
if (!requireNamespace("terra", quietly = TRUE)) {
  install.packages("terra")
}

# Load the packages
library(geodata)
library(dplyr)
library(Hmisc)
library(terra)

# Define a path to save the data
data_path <-"C:/Users/27768775/Downloads/rhomboideaGBIF/Clean occ"

# Download WorldClim data (bio variables at 10 minutes resolution)
wc_data <- worldclim_global(var = "bio", res = 10, path = data_path)

print(data_path)

# Convert the data to a raster stack
wc_stack <- rast(wc_data)

View(data_path)

# Extract variable values
wc_values <- terra::values(wc_stack)

# Remove rows with NA values
wc_values <- na.omit(wc_values)

# Compute correlation matrix
cor_matrix <- rcorr(as.matrix(wc_values))

# Get the correlation values
cor_values <- cor_matrix$r

# Get the p-values
p_values <- cor_matrix$P

# Find highly correlated variables (e.g., correlation coefficient > 0.75)
highly_correlated <- which(abs(cor_values) > 0.75 & abs(cor_values) < 1, arr.ind = TRUE)

# Display highly correlated variable pairs
correlated_pairs <- data.frame(
  Var1 = rownames(cor_values)[highly_correlated[, 1]],
  Var2 = colnames(cor_values)[highly_correlated[, 2]],
  Correlation = cor_values[highly_correlated]
)

# Print the highly correlated variable pairs
print(correlated_pairs)

# Save the correlation matrix to a CSV file
write.csv(cor_values, "worldclim_correlation_matrix.csv", row.names = TRUE)

# Display the correlation matrix
print(cor_values)
