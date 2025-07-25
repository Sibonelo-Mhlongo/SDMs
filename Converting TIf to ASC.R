# Install necessary packages if not already installed
if (!requireNamespace("raster", quietly = TRUE)) install.packages("raster")
if (!requireNamespace("rgdal", quietly = TRUE)) install.packages("rgdal")

# Load the raster package
library(raster)

# Define the directory containing the .tif files and the output directory for .asc files
input_directory <- "C:/Users/27768775/Downloads/rhomboideaGBIF/5min resol wc/climate/wc2.1_5m"
output_directory <- "C:/Users/27768775/Downloads/rhomboideaGBIF/5min resol wc/climate"

# Ensure the output directory exists
if (!dir.exists(output_directory)) {
  dir.create(output_directory)
}

# List all .tif files in the input directory
tif_files <- list.files(input_directory, pattern = "\\.tif$", full.names = TRUE)

# Loop through each .tif file, convert it to .asc, and save it in the output directory
for (tif_file in tif_files) {
  # Read the .tif file
  raster_data <- raster(tif_file)
  
  # Construct the output .asc file name
  output_asc <- file.path(output_directory, paste0(tools::file_path_sans_ext(basename(tif_file)), ".asc"))
  
  # Write the data to .asc format
  writeRaster(raster_data, output_asc, format = "ascii", overwrite = TRUE)
  
  # Print a message for each file processed
  cat("Converted", basename(tif_file), "to", basename(output_asc), "\n")
}

# Print a completion message
cat("All files converted from .tif to .asc successfully!\n")

