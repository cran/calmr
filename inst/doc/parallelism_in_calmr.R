## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  fig.width = 7,
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## ----setup--------------------------------------------------------------------
library(calmr)
# enables progress bars (try it on your computer)
# calmr_verbosity(TRUE)
pav_inhib <- data.frame(
  group = "group",
  phase1 = "50(US)/50AB/50#A",
  rand1 = TRUE
)
# set options to introduce more randomness
pars <- get_parameters(pav_inhib, model = "HDI2020")
exp <- make_experiment(pav_inhib,
  parameters = pars,
  model = "HDI2020",
  iterations = 100,
  miniblocks = FALSE
)

# time it
start <- proc.time()
pav_res <- run_experiment(exp)
end <- proc.time() - start
end

## -----------------------------------------------------------------------------
library(future)
plan(multisession)

start <- proc.time()
pav_res <- run_experiment(exp)
end <- proc.time() - start
end

# go back to non-parallel evaluations
plan(sequential)

