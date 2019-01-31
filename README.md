
[![Travis build
status](https://travis-ci.com/muschellij2/nsrr.svg?branch=master)](https://travis-ci.com/muschellij2/nsrr)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/muschellij2/nsrr?branch=master&svg=true)](https://ci.appveyor.com/project/muschellij2/nsrr)
[![Coverage
status](https://codecov.io/gh/muschellij2/nsrr/branch/master/graph/badge.svg)](https://codecov.io/gh/muschellij2/nsrr)

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
