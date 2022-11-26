library(zoo)
library(yardstick)

init <- function() {
  #
  # Function to load saved model and params into global variables
  #
  load("model_artifacts.RData")
  logreg <<- logreg_model
  predictor <<- predictor
  hos_cleanup <<- ho_cleanup
  threshold <<- threshold
}

make_prediction <- function(datum) {
  #
  # Function to process input data and compute predictions, given a trained model
  #
  datum$earliest_cr_line <- as.yearmon(datum$earliest_cr_line,
                                       format = "%b-%Y")
  datum$int_rate <- as.numeric(sub("%", "", datum$int_rate,
                                   fixed = TRUE)) / 100
  datum$logit_int_rate <- sapply(datum$int_rate, qlogis)
  datum$log_loan_amnt <- sapply(datum$loan_amnt, log)
  datum$log_annual_inc <- sapply(datum$annual_inc, log)
  datum$home_ownership <-
    sapply(datum$home_ownership, hos_cleanup)
  datum$credit_age <- Sys.yearmon() - datum$earliest_cr_line
  preds <- unname(predict(logreg, datum, type = "response"))
  return(preds)
}


score <- function(datum) {
  #
  # Function to predict on input data (data.frame)
  #
  preds <- make_prediction(datum)
  outcome <- sapply(preds, predictor)
  output <- list(outome = outcome, propensity = preds)
  return(output)
}

metrics <- function(data) {
  #
  # Function to compute a confusion matrix, given scored and labeled data
  #
  preds <- make_prediction(data)
  outcomes <- sapply(preds, predictor)
  data$outcomes <- as.factor(outcomes)
  data$loan_status <- as.factor(data$loan_status)
  cm <-
    yardstick::conf_mat(data = data,
                        truth = loan_status,
                        estimate = outcomes)
  
  output <- list("Prediction" = {
    list(
      "Charged Off" = list("Truth" = list(
        "Charged Off" = cm[[1]][1],
        "Fully Paid" = cm[[1]][3]
      )),
      "Fully Paid" = list("Truth" = list(
        "Charged Off" = cm[[1]][2],
        "Fully Paid" = cm[[1]][4]
      ))
    )
  })
  return(output)
}
