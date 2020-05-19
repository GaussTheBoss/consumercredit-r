

library(zoo)

#modelop.init
begin <- function(){
	load("model_artifacts.RData")
	logreg <<- logreg_model
	predictor <<- predictor
	hos_cleanup <<- ho_cleanup
}

#modelop.score
action <- function(datum){
	datum$earliest_cr_line <- as.yearmon(datum$earliest_cr_line, 
					     format="%b-%Y")
	datum$logit_int_rate <- sapply(datum$int_rate, qlogis)
	datum$int_rate <- as.numeric(sub("%", "", datum$int_rate, 
					     fixed=TRUE))/100
	datum$log_loan_amnt <- sapply(datum$loan_amnt, log)
	datum$log_annual_inc <- sapply(datum$annual_inc, log)
	datum$home_ownership <- sapply(datum$home_ownership, hos_cleanup)
	preds <- predict(logreg, datum, type="response")
	outcome <- sapply(preds, predictor)
	output <- list(outome = outcome, propensity = preds)
	emit(output)
}

