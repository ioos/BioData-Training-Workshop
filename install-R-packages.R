packages <- list(
  CRAN = c(
    "devtools", 
    "tidyverse", # includes: ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
    "lubridate", "rlang", "magrittr", "glue", "readxl", "rvest",
    "openxlsx","vegan",
    "RColorBrewer", 
    "rgdal", "proj4", 
    "raster", "rasterVis",
    "sp", "sf", "rgeos", "geosphere",
    "mapdata", "maptools",
    "RNetCDF", "hdf5r", "ncdf4","xtractomatic",
    "knitr", "rmarkdown", 
    "htmlwidgets", "DT", "dygraphs", "plotly", "leaflet", "crosstalk", "mapview", "mapedit",
    "uuid"),
  rOpenSci = c("XMLSchema", "SSOAP"),
  GitHub = c(
    "ropensci/rerddap", "rmendels/rerddapXtracto",
    "iobis/obistools", "iobis/robis",
    "ropensci/taxize", "ropensci/taxizesoap",
    "ropensci/finch"))
  
for (type in names(packages)){
  
  packages_installed <- rownames(installed.packages())
  
  if (type == "GitHub"){
    owner_repo         <- packages[[type]]
    pkgs               <- stringr::str_replace(owner_repo, "(.*)/(.*)", "\\2")
    pkgs_install       <- setdiff(pkgs, packages_installed)
    owner_repo_install <- owner_repo[pkgs %in% pkgs_install]
  } else {
    pkgs_install <- setdiff(packages[[type]], packages_installed)
  }
  
  if (length(pkgs_install) == 0 ) next
  
  message(type, " packages to install: ", paste(pkgs_install, collapse=", "))
  switch(
    type,
    CRAN     = install.packages(pkgs_install),
    rOpenSci = install.packages(pkgs_install, 
                                repos = c("http://packages.ropensci.org", "http://cran.rstudio.com")),
    GitHub   = devtools::install_github(owner_repo_install))
}
