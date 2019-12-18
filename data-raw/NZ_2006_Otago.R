## code to prepare `NZ_2006_Otago` dataset goes here
library(httr)
library(readxl)
library(dplyr)
# For sake of reproducibility, we will use the wayback machine archived data
url <- "https://web.archive.org/web/20191217031044/https://www.otago.ac.nz/wellington/otago020351.xls"
GET(url, write_disk(tf <- tempfile(fileext = ".xls")))

NZ_2006_Otago <- read_excel(tf, guess_max = 13000)

NZ_2006_Otago <- NZ_2006_Otago %>%
  mutate_at(vars(MB_num_2006, CAU_num_2006, CAU_name_2006,
                 TA_num, TA_name,
                 DHB_num, DHB_name,
                 Urban_Rural_Desc,
                 MB_num_2001),
            as.factor)

usethis::use_data(NZ_2006_Otago)
