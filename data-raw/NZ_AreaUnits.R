## code to prepare `NZ_AreaUnits` dataset goes here

library(readr)
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)

library(visdat)

# all url from way back machine
url_2013 <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago069931.txt"
url_2006 <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago069925.txt"
url_2001 <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago020335.txt"
url_1996 <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago020347.txt"
url_1996_names <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago020343.txt"
url_1991 <- "https://web.archive.org/web/20191114025619/https://www.otago.ac.nz/wellington/otago020345.txt"

all_data <- tibble(
  year = c(2013, 2006, 2001, 1996, 1991),
  url = c(url_2013, url_2006, url_2001, url_1996, url_1991)
)

all_data_read_in <- all_data %>%
  mutate(data = purrr::map(url, read_tsv))

#' Years 2013, 2006, 2001 seem pretty compatible, year 1996 and 1991 less so.
#' Let's just work on the three most recent iterations then.
#'
#' We will need to rename the variables to something sensible, such as:

target_names <- c("CAU_num", "CAU_name", "CAU_avg_NZD", "CAU_avg_NZD_score")

#' We first build a suitable ancillary functions


rename_to <- function(.data, new_names) {
  names(.data) <- new_names
  return(.data)
}

#' and then apply it to all the datasets that comply easily.


NZ_AreaUnits <- all_data_read_in %>%
  filter(year %in% c(2013, 2006, 2001)) %>%
  select(year, data) %>%
  mutate(data = map(data,
    rename_to,
    new_names = target_names
  )) %>%
  unnest(data) %>%
  mutate(year = lubridate::ymd(year, truncated = 2L))


# Now, let's take care of the rest. Those pesky ancient years.


NZ_AreaUnits_1996 <- all_data_read_in %>%
  filter(year == 1996) %>%
  select(year, data) %>%
  unnest(data)

NZ_AreaUnits_1996 %>% glimpse()

#' taking a look at the values in the columns:
#' CAUnum96 and CAUname96 are clearly CAU_num and CAU_name
#' `NZDepCAU96 wt ave score` is CAU_avg_NZD_score
#' `NZDepCAU96 wt ave scale` is CAU_avg_NZD
#' while `CAU urpop96` seems not to be there elsewhere

NZ_AreaUnits_1996 <- NZ_AreaUnits_1996 %>%
  select(
    year, CAUnum96, CAUname96,
    `NZDepCAU96 wt ave scale`, `NZDepCAU96 wt ave score`
  ) %>%
  rename_to(c("year", target_names)) %>%
  mutate(year = lubridate::ymd(year, truncated = 2L))


NZ_AreaUnits <- NZ_AreaUnits %>%
  bind_rows(NZ_AreaUnits_1996)

### And now 1991

NZ_AreaUnits_1991 <- all_data_read_in %>%
  filter(year == 1991) %>%
  select(year, data) %>%
  unnest(data)

NZ_AreaUnits_1991 %>% glimpse()

#' mmm, the 1991 was using a different separator

NZ_AreaUnits_1991 <- NZ_AreaUnits_1991 %>%
  separate(
    col = `CAU AUScore AUScale CauPopn`,
    into = c("CAU", "AUScore", "AUScale", "CauPopn")
  )


#' mmm, the 1991 was also using a different indicator and showing that popn
#' the second thing is easy, the first one requires some architectural reshaping

NZ_AreaUnits_1991 <- NZ_AreaUnits_1991 %>%
  select(-CauPopn)

#' we can take care of the former error (the coexistince of various indicators)
#' by pivotting to longer the table and allowing
#' the variable name to be a variable. Something like



library(tidyr)

NZ_AreaUnits_1991 <- NZ_AreaUnits_1991 %>%
  pivot_longer(
    cols = c(AUScore, AUScale),
    names_to = "Indicator",
    values_to = "Value"
  )

#' Much better, now we just have one name difference

NZ_AreaUnits_1991 <- NZ_AreaUnits_1991 %>%
  rename(CAU_num = CAU)

NZ_AreaUnits_1991 <- NZ_AreaUnits_1991 %>% mutate(
  CAU_name = NA_character_,
  Value = as.numeric(Value),
  year = lubridate::ymd(year, truncated = 2L)
)

#' let's pivot also the other piece of data

NZ_AreaUnits <- NZ_AreaUnits %>%
  pivot_longer(
    cols = c(CAU_avg_NZD, CAU_avg_NZD_score),
    names_to = "Indicator",
    values_to = "Value"
  )


#' and we bind everything together

NZ_AreaUnits %>%
  bind_rows(NZ_AreaUnits_1991)


usethis::use_data(NZ_AreaUnits)
