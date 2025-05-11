## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  fig.width = 7,
  collapse = TRUE,
  comment = "#>",
  warning = FALSE,
  message = FALSE
)

## ----setup--------------------------------------------------------------------
library(calmr)
library(ggplot2)
library(data.table)

## -----------------------------------------------------------------------------
df <- data.frame(
  Group = c("Same", "Reduced"),
  P1 = c("10A(X_a)", "10A(X_a)"),
  P2 = c("10(X_a)(US)", "10(X_b)(US)")
)
params <- get_parameters(df, model = "HD2022")
params$alphas[] <- c(.30, .40, .50, .36)
model <- run_experiment(df,
  model = "HD2022",
  parameters = params
)

## -----------------------------------------------------------------------------
associations <- results(model)$associations[
  s1 == "A" & s2 == "X" & phase == "P1"
]
associations[
  , nominal_alpha := ifelse(group == "Reduced", mean(.36, .40), .40)
][
  ,
  similarity := calmr:::.alphaSim(value, nominal_alpha)
]

associations |>
  ggplot(aes(x = trial, y = similarity, linetype = group)) +
  geom_line() +
  theme_bw() +
  labs(x = "Trial", y = "Similarity", linetype = "Group")

## -----------------------------------------------------------------------------
ntrials <- 1:10
df <- data.frame(
  Group = c(paste0("S", ntrials), paste0("R", ntrials)),
  P1 = rep(paste0(ntrials, "A(X_a)"), 2),
  P2 = rep(c("10(X_a)>(US)", "10(X_b)>(US)"), each = 10),
  P3 = "1A#"
)
head(df)

## -----------------------------------------------------------------------------
model <- run_experiment(df,
  model = "HD2022",
  parameters = params
)

## -----------------------------------------------------------------------------
responses <- results(model)$responses[phase == "P3" & s2 == "US"]
responses[, `:=`(
  trial = trial - 11,
  group_lab = ifelse(substr(group, 1, 1) == "R", "Reduced", "Same")
)]

responses |>
  ggplot(aes(x = trial, y = value, colour = s1, linetype = group_lab)) +
  geom_line() +
  theme_bw() +
  labs(x = "Trial", y = "R-value", colour = "stimulus", linetype = "Group") +
  facet_wrap(~s2)

