# Install necessary packages if not already installed
if (!require("raster")) install.packages("raster")
if (!require("psych")) install.packages("psych")

# Load libraries
library(raster)
library(psych)

# Install the caret package if you haven't already
install.packages("caret")

# Load the caret package
library(caret)


# Load WorldClim data (example for Bioclim variables)
# You need to adjust the path to where your WorldClim data is stored
bioclim_data <- stack(list.files(path = "C:/Users/27768775/Downloads/rhomboideaGBIF/5min resol wc/climate/wc2.1_5m", pattern = "*.tif$", full.names = TRUE))

# Extract raster values as a data frame
bioclim_values <- as.data.frame(getValues(bioclim_data))

# Remove rows with NA values
bioclim_values <- na.omit(bioclim_values)

# Calculate correlation matrix
cor_matrix <- cor(bioclim_values)

# Print correlation matrix
print(cor_matrix)

# Save correlation matrix as CSV
write.csv(cor_matrix, file = "correlation_matrix.csv")

# Identify variables to exclude based on the correlation threshold
high_cor_vars <- findCorrelation(cor_matrix, cutoff = 0.75)

# Exclude highly correlated variables
bioclim_values_reduced <- bioclim_values[, -high_cor_vars]

# Calculate final correlation matrix with reduced variables
final_cor_matrix <- cor(bioclim_values_reduced)

# Print final correlation matrix
print(final_cor_matrix)

# Save final correlation matrix as CSV
write.csv(final_cor_matrix, file = "final_correlation_matrix.csv")


