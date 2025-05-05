# This file is used to test axecute in the logrx blog post

# Load necessary libraries
library(pharmaversesdtm)
library(dplyr)

# Check if the package is installed
if (!requireNamespace("pharmaversesdtm", quietly = TRUE)) {
  stop("The pharmaversesdtm package is not installed. Please install it first.")
}

# Load example data
data("dm", package = "pharmaversesdtm")

# Display a message
message("Starting data manipulation using dplyr...")

# Execute the manipulation
tryCatch(
  {
    # Simple dplyr operations
    # Filter for males and select specific columns
    filtered_data <- dm %>%
      filter(RACE == "M") %>%
      select(STUDYID, USUBJID, AGE, SEX)

    # Print the first few rows of the filtered data
    print(filtered_data)

    # If the dataset is empty after filtering, provide a warning
    if (nrow(filtered_data) == 0) {
      warning("The filtered dataset has no data. Please check your filter criteria.")
    }
  },
  error = function(err) {
    warning("An error occurred during processing: ", err$message)
  }
)

# Display a message indicating completion
message("Data manipulation completed.")
