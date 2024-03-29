% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class_fit.R
\name{CalmrFit-methods}
\alias{CalmrFit-methods}
\alias{show,CalmrFit-method}
\alias{predict,CalmrFit-method}
\alias{predict}
\alias{NLL,CalmrFit-method}
\alias{NLL}
\alias{AIC,CalmrFit-method}
\alias{AIC}
\alias{BIC,CalmrFit-method}
\alias{BIC}
\title{CalmrFit methods}
\usage{
\S4method{show}{CalmrFit}(object)

\S4method{predict}{CalmrFit}(object, type = "response", ...)

\S4method{NLL}{CalmrFit}(object)

\S4method{AIC}{CalmrFit}(object, k = 2)

\S4method{BIC}{CalmrFit}(object)
}
\arguments{
\item{object}{A \code{CalmrFit} object.}

\item{type}{A string specifying the type of prediction to generate.}

\item{...}{Extra named arguments.}

\item{k}{Penalty term for \code{AIC} method.}
}
\value{
\itemize{
\item \code{show()} returns NULL (invisibly).
\item \code{predict()} returns a numeric vector.
\item \code{NLL()} returns the negative log likelihood of the model.
\item \code{AIC()} returns the Akaike Information Criterion (AIC) of the model.
\item \code{BIC()} returns the Bayesian Information Criterion (BIC) of the model.
}
}
\description{
S4 methods for \code{CalmrFit} class.
}
\details{
With \code{type = "response"}, the \code{predict()} function
passed model responses to the link function used to fit the model.

The AIC is defined as \code{2*k - 2*-NLL}, where k is a penalty
term and NLL is the negative log likelihood of the model.

The BIC is defined as \code{p*log(n) - 2*-NLL}, where p is the number
of parameters in the model and n is the number of observations
}
