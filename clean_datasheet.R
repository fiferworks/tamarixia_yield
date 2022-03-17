####LOADING PACKAGES AND READING IN FILE LISTS####
# loading required packages
pkgs <- c("readxl", "lubridate", "tidyr")

# installs missing packages
nu_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
if (length(nu_pkgs))
  install.packages(nu_pkgs)

# loading required packages
lapply(pkgs, library, character.only = TRUE)
rm(pkgs, nu_pkgs)

# reading in the SPME GC/MS data channel "TIC"
df <-
  readxl::read_excel(
    path = "master_count_record.xlsx",
    skip = 1,
    col_names = c(
      "cage",
      "ovi_id",
      "tam_add",
      "harv_1",
      "ct_1",
      "harv_2",
      "ct_2",
      "harv_3",
      "ct_3",
      "harv_4",
      "ct_4",
      "harv_5",
      "ct_5",
      "cleaned",
      "ct_6",
      "total",
      "pd",
      "psy",
      "yld",
      "pests",
      "barn",
      "plant"
    ),
    col_types = c(
      "text",
      "text",
      "numeric",
      "date",
      "numeric",
      "date",
      "numeric",
      "date",
      "numeric",
      "date",
      "numeric",
      "date",
      "numeric",
      "date",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "numeric",
      "text",
      "text",
      "text"
    ),
    na = "NA"
  )



df %>% select(-c(
  "ct_1",
  "ct_2",
  "ct_3",
  "ct_4",
  "ct_5",
  "ct_6",
  "total",
  "psy",
  "yld"
)) %>% tidyr::pivot_longer(
  c("harv_1", "harv_2", "harv_3", "harv_4", "harv_5", "cleaned"),
  names_to = "harv",
  values_to = "date"
)

tidyr::pivot_longer(df,
                    c("ct_1", "ct_2", "ct_3", "ct_4", "ct_5", "ct_6"),
                    names_to = "count")
