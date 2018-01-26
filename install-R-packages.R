# packages on CRAN
packages_cran <- c(
  "devtools", 
  "tidyverse", # includes: ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
  "lubridate", "rlang", "magrittr", "glue", "readxl", "rvest",
  "RColorBrewer", 
  "rgdal", "proj4", 
  "raster", "rasterVis",
  "sp", "sf", "rgeos", "geosphere",
  "mapdata", "maptools",
  "RNetCDF", "hdf5r", "ncdf4", 
  "knitr", "rmarkdown", 
  "htmlwidgets", "DT", "dygraphs", "plotly", "leaflet", "crosstalk", "mapview", "mapedit",
  "uuid") 
  #"finch") # dependent R packages XMLSchema & SSOAP removed from CRAN

# packages on Github
packages_github <- c(
  "iobis/obistools", "iobis/robis",
  "ropensci/taxize", "ropensci/taxizesoap")

# install CRAN packages if needed
for (p in packages_cran){
  packages_installed <- rownames(installed.packages())
  if (!p %in% packages_installed){
    message("CRAN package ", p, " not found locally. Installing...")
    install.packages(p)
  }
}

# install packages from Github if needed
for (owner_repo in packages_github){
  packages_installed <- rownames(installed.packages())
  p <- stringr::str_split(owner_repo, "/", simplify=T)[2]
  if (!p %in% packages_installed){
    message("Github package ", owner_repo, " not found locally. Installing...")
    devtools::install_github(owner_repo)
  }
}
