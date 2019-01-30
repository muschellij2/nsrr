
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nsrr

<!-- badges: start -->

<!-- badges: end -->

The goal of nsrr is to allow users to access data from the National
Sleep Research Resource (’NSRR’) (<https://sleepdata.org/>).

## Installation

You can install the released version of nsrr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("nsrr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(nsrr)
df = nsrr_datasets()
DT::datatable(df)
```

<img src="man/figures/README-example-1.png" width="100%" />
