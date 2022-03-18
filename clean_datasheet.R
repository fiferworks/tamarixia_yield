####LOADING PACKAGES AND READING IN FILE LISTS####
# loading required packages
pkgs <- c("renv", "readxl", "lubridate", "tidyr", "dplyr", "readr")

# installs missing packages
nu_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
if (length(nu_pkgs))
  install.packages(nu_pkgs)

# loading required packages
lapply(pkgs, library, character.only = TRUE)
rm(pkgs, nu_pkgs)

# reading in the Tamarixia rearing logs
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

# trying to figure out how to pivot_longer to get what I want, probably a pivot_longer_spec case
df1 <-
  df %>% dplyr::select(starts_with("harv_"), "cleaned", "ovi_id") %>% pivot_longer(cols = !"ovi_id",
                                                                                   names_to = "harvest",
                                                                                   values_to = "date")


df <-
  df %>% dplyr::select(!starts_with("harv_"), -"cleaned") %>% pivot_longer(
    cols = c(starts_with("ct_")),
    names_to = "ct",
    values_to = "tam_ct"
  )

df <- bind_cols(df[-11], df1[-1])

df$date <- as_date(df$date)

# saving the cleaned output
write_csv(df, "clean_tam_yield_datasheet.csv")

# removing any objects in the environment
rm(list = ls())
