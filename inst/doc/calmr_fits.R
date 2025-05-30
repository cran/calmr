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
library(ggplot2)
library(data.table)
theme_set(theme_bw())
data(pati)
set.seed(2022)

## -----------------------------------------------------------------------------
summary(pati)
pati |> ggplot(aes(x = block, y = rpert, colour = us)) +
  geom_line(aes(group = interaction(us, subject)), alpha = .3) +
  stat_summary(geom = "line", fun = "mean", linewidth = 1) +
  labs(x = "Block", y = "Responses per trial", colour = "US") +
  facet_grid(~response)

## -----------------------------------------------------------------------------
pati_summ <- setDT(pati)[,
  list("rpert" = mean(rpert)),
  by = c("block", "us", "response")
]
# set order (relevant for the future)
setorder(pati_summ, block, response, us)
head(pati_summ)

## -----------------------------------------------------------------------------
# The design data.frame
des_df <- data.frame(
  group = c("CB1", "CB2"),
  training = c(
    "12L>(Pellet)/12R>(Sucrose)/12#L/12#R",
    "12L>(Sucrose)/12R>(Pellet)/12#L/12#R"
  )
)
# The parameters
# the actual parameter values don't matter,
# as our function will re-write them inside the optimizer call
parameters <- get_parameters(des_df,
  model = "HD2022"
)
# The arguments
experiment <- make_experiment(des_df,
  parameters = parameters, model = "HD2022",
  iterations = 4
)
experiment

## -----------------------------------------------------------------------------
exp_res <- run_experiment(experiment)
results(exp_res)

## -----------------------------------------------------------------------------
my_model_function <- function(pars, exper, full = FALSE) {
  # extract the parameters from the model
  new_parameters <- parameters(exper)[[1]]
  # assign alphas
  new_parameters$alphas[] <- pars
  # reassign parameters to the experiment
  parameters(exper) <- new_parameters # note parameters method
  # running the model and selecting responses
  exp_res <- run_experiment(exper)
  # summarizing the model
  responses <- results(exp_res)$responses
  # calculate extra variables
  responses$response <- ifelse(responses$s1 %in% c("Pellet", "Sucrose"),
    "np", "lp"
  )
  responses$block <- ceiling(responses$trial / 8)
  # filtering
  # only probe trials
  responses <- responses[grepl("#", trial_type)]
  # only available responses
  responses <- responses[s2 %in% c("Pellet", "Sucrose") &
    (response == "np" | (response == "lp" &
      mapply(grepl, s1, trial_type)))]
  # aggregate
  responses <- responses[, list(value = mean(value)), by = c("block", "s2", "response")]
  if (full) {
    return(responses)
  }
  responses$value
}

## -----------------------------------------------------------------------------
my_model_function(c(.1, .2, .4, .3), experiment)

## -----------------------------------------------------------------------------
head(my_model_function(c(.1, .2, .4, .3), experiment, full = TRUE))
head(pati_summ)

## -----------------------------------------------------------------------------
my_optimizer_opts <- get_optimizer_opts(
  model_pars = names(parameters$alphas),
  optimizer = "ga",
  ll = c(0, 0, 0, 0),
  ul = c(1, 1, 1, 1),
  family = "normal"
)
my_optimizer_opts

## ----eval=FALSE, include=TRUE-------------------------------------------------
# the_fit <- fit_model(pati_summ$rpert,
#   model_function = my_model_function,
#   exper = experiment,
#   optimizer_options = my_optimizer_opts,
#   maxiter = 10,
#   parallel = TRUE
# )

## ----include = F, echo = F----------------------------------------------------
# save("the_fit", file = "vignettes/calmr_fits_fit.rda")
# load(file = "vignettes/calmr_fits_fit.rda")
load(file = "calmr_fits_fit.rda")

## -----------------------------------------------------------------------------
the_fit
# the BIC and AIC
BIC(the_fit)
AIC(the_fit)

## -----------------------------------------------------------------------------
pati_summ$prediction <- predict(the_fit, exper = experiment)
pati_summ[, data := rpert][, rpert := NULL]
pati_summ <- melt(pati_summ, measure.vars = c("prediction", "data"))
pati_summ |>
  ggplot(ggplot2::aes(
    x = block, y = value,
    colour = us,
    linetype = variable
  )) +
  geom_line() +
  theme_bw() +
  facet_grid(us ~ response)

