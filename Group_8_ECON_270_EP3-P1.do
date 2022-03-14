clear
import delimited "E:\Users\mu63\Documents\datacommons_data.csv"
drop giniindex_economicactivity count_criminalactivities_combine count_person_perarea

*Summarize data
sum

*Drop data with lots of missing values

*We have to create the variable geoid which will be the common variable when merging data
gen geoid1 = substr(placedcid,7,11)
destring geoid1, gen(geoid)
drop placedcid geoid1

rename placename place
*Store all the remaining predictors
*Here place should be the variable which describes the county. Rename as needed to continue. 
ds geoid place, not
local vars = r(varlist)

*Merge with atlas training data using geoid
merge 1:1 geoid using "E:\Users\mu63\Documents\atlas_training.dta"

**
replace count_person_speakenglishnotatal=count_person_speakenglishnotatal/pop
replace count_person_nohealthinsurance=count_person_nohealthinsurance/pop
replace genderincomeinequality_person_15=genderincomeinequality_person_15/pop
replace median_income_person=median_income_person/pop
replace count_household=count_household/pop
replace count_person_bachelorofsciencean=count_person_bachelorofsciencean/pop
replace unemploymentrate_person=unemploymentrate_person/pop

global predictorvars "count_person_speakenglishnotatal count_person_nohealthinsurance genderincomeinequality_person_15 median_income_person count_household count_person_bachelorofsciencean unemploymentrate_person"

reg kfr_pooled_p25 $predictorvars P_* if training == 1, r
predict rank_hat_ols

gen pred_error = kfr_pooled_p25 - rank_hat_ols
gen mse_forest = pred_error^2
sum mse_forest if training == 1

*Q8 The Standard deviation and mean residual are very close to zero that means that our model is a good fit