 <!-- badges: start -->
  [![Travis build status](https://travis-ci.org/gvdr/depRivation.svg?branch=master)](https://travis-ci.org/gvdr/depRivation)
  <!-- badges: end -->

  <!-- badges: start -->
  [![Codecov test coverage](https://codecov.io/gh/gvdr/depRivation/branch/master/graph/badge.svg)](https://codecov.io/gh/gvdr/depRivation?branch=master)
  <!-- badges: end -->

# deprivation

Socioeconomic Deprivation Indexes, the easy, tidy, R way.

For the moment, the only data really available is the New Zealand Socioeconomic Deprivation Index as discussed [here](https://www.otago.ac.nz/wellington/departments/publichealth/research/hirp/otago020194.html).

Install the `deprivation` package

```{r}
remotes::install_github("gvdr/depRivation")
```

and load it

```{r}
library(deprivation)
```

The data will be available through

```{r}
data("NZ_AreaUnits")
```

The data set is composed of `r nrow(NZ_AreaUnits)` observations across `r ncol(NZ_AreaUnits)` variables. It covers the years 1991, 1996, 2001, 2006, and 2013. Notice that in the 1991 the deprivation index used seemed to differ from the other years (or maybe it's just called differently.)

```{r}
NZ_AreaUnits %>%
skimr::skim() %>%
skimr::kable()
```

## Contribution

  Please note that the 'deprivation' project is released with a
  [Contributor Code of Conduct](.github/CODE_OF_CONDUCT.md).
  By contributing to this project, you agree to abide by its terms.
