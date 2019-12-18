## code to prepare `NZ_2013_Otago` dataset goes here
library(readr)
library(dplyr)
# For sake of reproducibility, we will use the wayback machine archived data
NZ_2013_Otago <- read_tsv("https://web.archive.org/web/20191217031044/https://www.otago.ac.nz/wellington/otago070691.txt", guess_max = 13000)

NZ_2013_Otago <- NZ_2013_Otago %>%
  mutate_at(vars(MB_2013, CAU_2013, CAU_name_2013,
                 TA2013_num, TA2013_Desc, TA2010_num, TA2010_Desc,
                 DHB_num, DHB_name, Urban_Rural_Ind, Urban_Rural_Ind_Desc,
                 MB_2006, AU_2006),
            as.factor)

usethis::use_data(NZ_2013_Otago)
