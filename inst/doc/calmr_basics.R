## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  fig.width = 4,
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## -----------------------------------------------------------------------------
library(calmr)

my_blocking <- data.frame(
  Group = c("Exp", "Control"),
  Phase1 = c("10A(US)", "10C(US)"),
  R1 = c(FALSE, FALSE),
  Phase2 = c("10AB(US)", "10AB(US)"),
  R2 = c(FALSE, FALSE),
  Test = c("1#A/1#B", "1#A/1#B"),
  R3 = c(FALSE, FALSE)
)
# parsing the design and showing the original and what was detected
parsed <- parse_design(my_blocking)
parsed

## ----error = TRUE-------------------------------------------------------------
# not specifying a number of AB trials. Error!
phase_parser("AB/10AC")
# putting the probe symbol out of order. Error!
phase_parser("#10A")
# considering a configural cue for elements AB
trial <- phase_parser("10AB(AB)(US)")
# different USs
trial <- phase_parser("10A(US1)/10B(US2)")

## -----------------------------------------------------------------------------
supported_models()

## -----------------------------------------------------------------------------
my_pars <- get_parameters(my_blocking, model = "RW1972")
# Increasing the beta parameter for US presentations
my_pars$betas_on["US"] <- .6
my_pars

## -----------------------------------------------------------------------------
my_experiment <- run_experiment(
  my_blocking, # note we do not need to pass the parsed design
  model = "RW1972",
  parameters = my_pars,
  iterations = 5
)
# returns an CalmrExperiment object
class(my_experiment)
# CalmrExperiment is an S4 class, so it has slots
slotNames(my_experiment)
# the experience given to group Exp on the first iteration
my_experiment@experiences[[1]]
# the number of times we ran the model (groups x iterations)
length(experiences(my_experiment))
# an experiment has results with different levels of aggregation
class(my_experiment@results)
slotNames(my_experiment@results)
# shorthand method to access aggregated_results
results(my_experiment)

## -----------------------------------------------------------------------------
# get all the plots for the experiment
plots <- plot(my_experiment)
names(plots)
# or get a specific type of plot
specific_plot <- plot(my_experiment, type = "vs")
names(specific_plot)
# show which plots are supported by the model we are using
supported_plots("RW1972")

## -----------------------------------------------------------------------------
plot(my_experiment, type = "vs")

## -----------------------------------------------------------------------------
plot(my_experiment, type = "rs")

## -----------------------------------------------------------------------------
my_graph_opts <- get_graph_opts("small")
graph(my_experiment, t = 20, options = my_graph_opts)

