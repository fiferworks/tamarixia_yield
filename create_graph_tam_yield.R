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

# graphing results by year
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

# # for the monthly CHRP report
report_period <- as_date(Sys.time())
monthly_chrp_rpt <-
  df %>% dplyr::filter(month == lubridate::month(report_period) &
                         year == lubridate::year(report_period)) %>%
  summarize(
    month = month(report_period, label = TRUE),
    total_psyllids = sum(psy, na.rm = T),
    total_tamarixia = sum(tam_ct, na.rm = T),
    year = year(report_period)
  )

## TODO: make nice line graph of production
# # graph of psyllid production by month
# df %>% drop_na() %>% ggplot(aes(x = plant_common, y = tam_ct, fill = plant_common)) +
#   geom_boxplot(notch = TRUE) +
#   ggtitle("Total Tamarixia radiata produced, 2020-2022") +
#   geom_text(
#     stat = "count",
#     aes(label = paste0("n = ", ..count..), y = ..count..),
#     position = "fill",
#     size = 7,
#     vjust = 1.5,
#     data = df %>% drop_na()
#   ) +
#   theme_tufte(base_size = 30) +
#   theme(axis.title = element_blank(), legend.position = "none") +
#   facet_wrap(ggplot2::vars(year))


# TODO
# # for quarterly reports
# report_period <- interval(start = "2020-1-1", end = as_date(Sys.time()))
# df %>%
#   filter(date %within% report_period) %>%
#   group_by(year, month) %>%
#   summarize(
#     total_psyllids = sum(psy, na.rm = T),
#     total_tamarixia = sum(tam_ct, na.rm = T)
#   )

# # for Octavio's report
report_period <-
  interval(start = "2020-1-1", end = as_date(Sys.time()))
report <- df %>%
  filter(date %within% report_period) %>%
  group_by(year, month) %>%
  summarize(
    total_psyllids = sum(psy, na.rm = T),
    total_tamarixia = sum(tam_ct, na.rm = T)
  )
# write_csv(report, 'octavio_report.csv')
