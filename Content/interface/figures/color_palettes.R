# R/color_palettes.R
# This file stores all custom color palettes for the application.
# You can add or edit palettes here. Each palette is a vector of hex color codes.
library(RColorBrewer) # We need this library to generate the palettes
custom_palettes <- list(
  
  "My Lab Palette 1" = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd", 
                         "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"),
  
  "Cool Tones" = c("#5e81ac", "#88c0d0", "#81a1c1", "#8fbcbb", "#b48ead"),
  
  
  "Warm Tones" = c("#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead"),
  
  
  "Publication Ready (Tübingen)" = c("#006E82", "#82006E", "#6E8200", "#00826E", "#6E0082", "#826E00"),
  
  
  "RColorBrewer - Paired" = c("#A6CEE3", "#1F78B4", "#B2DF8A", "#33A02C", "#FB9A99", "#E31A1C", 
                              "#FDBF6F", "#FF7F00", "#CAB2D6", "#6A3D9A", "#FFFF99", "#B15928"),
  
  "RColorBrewer - Set2" = c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", 
                            "#E5C494", "#B3B3B3"),
  
  "RColorBrewer - Accent" = c("#7FC97F", "#BEAED4", "#FDC086", "#FFFF99", "#386CB0", "#F0027F", 
                              "#BF5B17", "#666666"),
  
  "RColorBrewer - Dark2" = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E", "#E6AB02", 
                             "#A6761D", "#666666")
  
)

# --- 2. Programmatically generate all RColorBrewer palettes ---
# Get the names of all available palettes from the package
brewer_palette_names <- rownames(RColorBrewer::brewer.pal.info)

# Create a named list of the color vectors for each palette
brewer_palettes <- lapply(brewer_palette_names, function(name) {
  # Get the maximum number of colors for the current palette
  max_colors <- RColorBrewer::brewer.pal.info[name, "maxcolors"]
  # Generate the color vector
  RColorBrewer::brewer.pal(max_colors, name)
})
# Assign the names to the list
names(brewer_palettes) <- paste("Brewer:", brewer_palette_names)


# --- 3. Combine your custom palettes and the RColorBrewer palettes into one master list ---
# This single list will be used by the app.
all_palettes <- c(custom_palettes, brewer_palettes)