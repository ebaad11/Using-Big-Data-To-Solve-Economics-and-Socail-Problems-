*drop only these variables
keep geoid kfr_pooled_p25 test training predictions_ols predictions_tree
*merge training data with test data
merge 1:1 geoid using "atlas_test.dta"
*generate pred_tree data
gen pred_errortree = kfr_actual - predictions_tree
gen mse_tree = pred_errortree^2
sum mse_tree if test == 1
*generate pred ols data
gen pred_errorols = kfr_actual - predictions_ols
gen mse_ols = pred_errorols^2
sum mse_ols if test == 1

*when comparing the means, the mse_ols is closer to 0 with a value of .0005326, compared to mse_tree which is .0010055, so the OLS model is a better predicator for upward mobility

*creating different graphs to illustrate point
twoway (scatter predictions_ols kfr_actual) (scatter predictions_tree kfr_actual) (qfit predictions_ols kfr_actual) (qfit predictions_tree kfr_actual)
twoway (qfit predictions_ols kfr_actual) (qfit predictions_tree kfr_actual)
twoway (qfit predictions_ols kfr_actual) (qfit predictions_tree kfr_actual) (qfit kfr_actual kfr_actual)
twoway (qfit predictions_ols kfr_actual) (qfit predictions_tree kfr_actual) (qfit kfr_actual kfr_actual), legend(label(1 "ols") label(2 "tree") label(3 "45 degree"))
sum kfr_actual predictions_ols predictions_tree
drop if kfr_actual == .
sum kfr_actual predictions_ols predictions_tree
drop if predictions_ols == .
sum kfr_actual predictions_ols predictions_tree
twoway (qfit predictions_ols kfr_actual) (qfit predictions_tree kfr_actual) (qfit kfr_actual kfr_actual), legend(label(1 "ols") label(2 "tree") label(3 "45 degree"))
