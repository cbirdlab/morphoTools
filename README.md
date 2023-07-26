# morphoTools
Tools for Tidy Morphological Data

This R package includes tools for morphological analysis and was inspired by the paper, Hamilton et al., 2020 (Journal of Biogeography, 47(7), pp.1494-1509).

## Installation

Install the latest version of this package by entering the following in R:

```R
if (!"morphoTools" %in% installed.packages()) {
  # Check if 'devtools' is installed
  if (!"devtools" %in% installed.packages()) {
    # Install 'devtools' if it's not installed
    install.packages("devtools")
  }
  
  # Load 'devtools'
  library(devtools)
  
  # Install 'morphoTools' from GitHub using 'devtools'
  devtools::install_github("cbirdlab/morphoTools")
}
```

## Main Functionality

The package includes a function normalizeCharacter(), which normalizes a morphological character measurement (a column in your tibble) by another character, following an allometric scaling law.

```R

normalizeCharacter(data, "character_column", "normalize_by_column")
```

Where data is your data frame, "character_column" is the name of the column to be normalized, and "normalize_by_column" is the name of the column by which to normalize.

## Example

Here is an example of how to use normalizeCharacter():

```R
# Load the library
library(morphoTools)

# Create a sample data frame
data <- data.frame(width_cm = rnorm(100, 10, 2), length_cm = rnorm(100, 50, 10))

# Use the function
normalizeCharacter(data, "width_cm", "length_cm")
```

## References

Hamilton, A.M., Selwyn, J.D., Hamner, R.M., Johnson, H.K., Brown, T., Springer, S.K. & Bird, C.E., 2020.
Biogeography of shell morphology in over‐exploited shellfish reveals adaptive trade‐offs on human‐inhabited
islands and incipient selectively driven lineage bifurcation. Journal of Biogeography, 47(7), pp.1494-1509.
