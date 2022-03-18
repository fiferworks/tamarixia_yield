####LOADING PACKAGES AND READING IN FILE LISTS####
# loading required packages
pkgs <-
  c("renv",
    "readxl",
    "lubridate",
    "tidyr",
    "dplyr",
    "readr",
    "forcats",
    "ggplot2")

# installs missing packages
nu_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
if (length(nu_pkgs))
  install.packages(nu_pkgs)

# loading required packages
lapply(pkgs, library, character.only = TRUE)
rm(pkgs, nu_pkgs)

df <- read_csv("clean_tam_yield_datasheet.csv")

as_factor()