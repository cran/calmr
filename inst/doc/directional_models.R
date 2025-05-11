## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  fig.width = 7,
  collapse = TRUE,
  comment = "#>",
  message = FALSE,
  warning = FALSE
)

## -----------------------------------------------------------------------------
library(calmr)
design <- data.frame(
  group = c("Directional", "Simultaneous"),
  phase1 = c("10A>B", "10AB")
)
parsed <- parse_design(design)
print(parsed)
# note: periods are recognized internally; see parsed@mapping

## -----------------------------------------------------------------------------
pars <- get_parameters(parsed, model = "RW1972")
exp_res <- run_experiment(design, parameters = pars, model = "RW1972")
patch_graphs(graph(exp_res))

## -----------------------------------------------------------------------------
design <- data.frame(
  group = c("Directional", "Simultaneous"),
  phase1 = "10A>(US)",
  phase2 = c("10B>A/10#A", "10BA/10#A")
)
print(parse_design(design))
pars <- get_parameters(design, model = "RW1972")
exp_res <- run_experiment(design, parameters = pars, model = "RW1972")
plots <- plot(exp_res, type = "responses")
plots <- lapply(plots, function(x) x + ggplot2::ggtitle(unique(x$data$group)))
patch_plots(plots)

