## code to prepare `NZ_Otago` dataset goes here

# Unified depriviation index (aim to be across all years of publication) from the Otago data

# Requires NZ_2006_Otago and NZ_2013_Otago (so far)

NZ_2006_Otago %>%
  rename(
    MB_num = MB_num_2006,
    deprivation = NZdep2006,
    NZDep_score_2006,
  )

NZ_2013_Otago %>%
  select(MB_2013) %>%
  distinct(MB_2013) %>%
  anti_join(NZ_2006_Otago %>%
    select(MB_num_2006) %>%
    distinct(MB_num_2006),
  by = c("MB_2013" = "MB_num_2006")
  )


usethis::use_data("NZ_Otago")
