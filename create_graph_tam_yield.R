####LOADING PACKAGES AND READING IN FILE LISTS####
# loading required packages
pkgs <-
  c(
    "renv",
    "readxl",
    "lubridate",
    "tidyr",
    "dplyr",
    "readr",
    "forcats",
    "ggplot2",
    "ggthemes"
  )

# installs missing packages
nu_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
if (length(nu_pkgs))
  install.packages(nu_pkgs)

# loading required packages
lapply(pkgs, library, character.only = TRUE)
rm(pkgs, nu_pkgs)

df <-
  read_csv("clean_tam_yield_datasheet.csv",
           col_types = c("ff?????fff?fD"))

df$month <- month(df$date)
df$year <- year(df$date)

df %>% drop_na() %>% ggplot(aes(x = plant_common, y = tam_ct, fill = plant_common)) +
  geom_boxplot(notch = TRUE) +
  ggtitle("Total Tamarixia radiata produced, 2020-2022") +
  geom_text(
    stat = "count",
    aes(label = paste0("n = ", ..count..), y = ..count..),
    position = "fill",
    size = 7,
    vjust = 1.5,
    data = df %>% drop_na()
  ) +
  theme_tufte(base_size = 30) +
  theme(axis.title = element_blank(), legend.position = "none") +
  facet_wrap(ggplot2::vars(year))
