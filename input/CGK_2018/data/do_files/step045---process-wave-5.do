clear all 
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

import excel using ///
	"Stage 5 data  - 2015-08-14.xlsx", ///
	sheet("data_for_stata")  firstrow cellrange(A4)

	
*=========================================================	
rename q0 w5_infl_response
label var w5_infl_response ///
	"Q0. Inflation Forecast Bin From Stage 4"
*=========================================================
	
rename q1 w5_epi_12m
label var w5_epi_12m ///
	"Q1. During the next twelve months, by how much do you think prices will change?"
*=========================================================
	
rename q2 w5_pi_12m
label var w5_pi_12m ///
	"Q2. During the last twelve months, by how much do you think prices have changed overall in the economy? "

*=========================================================
	
rename q3 w5_infl_understand
label var w5_infl_understand ///
	"Q3. What is your understanding of the term inflation"	
*=========================================================
	
rename q4 w5_CPI_credible
label var w5_CPI_credible ///
	"Q5. Official Inflation Data is Credible?"	

replace w5_CPI_credible="1" if w5_CPI_credible=="Yes"
replace w5_CPI_credible="0" if w5_CPI_credible=="No"
	
destring w5_CPI_credible, force replace

label define w5_CPI_credible0 1 "Yes" 0 "No"
label values w5_CPI_credible w5_CPI_credible0
tab w5_CPI_credible


*=========================================================	

rename q5_1 w5_CPI_wgt_house
label var w5_CPI_wgt_house ///
	"Q5. Weight statistical agencies place on: housing prices"
	
rename q5_2 w5_CPI_wgt_stockprices
label var w5_CPI_wgt_stockprices ///
	"Q5. Weight statistical agencies place on: stock prices"
	
rename q5_3 w5_CPI_wgt_food
label var w5_CPI_wgt_food ///
	"Q5. Weight statistical agencies place on: food prices"

rename q5_4 w5_CPI_wgt_health
label var w5_CPI_wgt_health ///
	"Q5. Weight statistical agencies place on: Health care costs"

rename q5_5 w5_CPI_wgt_gas
label var w5_CPI_wgt_gas ///
	"Q5. Weight statistical agencies place on: gasoline prices"

rename q5_6 w5_CPI_wgt_rent
label var w5_CPI_wgt_rent ///
	"Q5. Weight statistical agencies place on: rent"		
	
rename q5_7 w5_CPI_wgt_car
label var w5_CPI_wgt_car ///
	"Q5. Weight statistical agencies place on: car prices"		
	
	
*=========================================================	

rename q6_1 w5_pi_12m_house
label var w5_pi_12m_house ///
	"Q6. Perceived change in housing prices"
	
rename q6_2 w5_pi_12m_stockprices
label var w5_pi_12m_stockprices ///
	"Q6. Perceived change in  stock prices"
	
rename q6_3 w5_pi_12m_food
label var w5_pi_12m_food ///
	"Q6. Perceived change in  food prices"

rename q6_4 w5_pi_12m_health
label var w5_pi_12m_health ///
	"Q6. Perceived change in health care costs"

rename q6_5 w5_pi_12m_gas
label var w5_pi_12m_gas ///
	"Q6. Perceived change in gasoline prices"

rename q6_6 w5_pi_12m_rent
label var w5_pi_12m_rent ///
	"Q6. Perceived change in  rent"		
	
rename q6_7 w5_pi_12m_car
label var w5_pi_12m_car ///
	"Q6. Perceived change in car prices"		
	
	
*=========================================================

rename q7 w5_RBNZ_control_12m
label var w5_RBNZ_control_12m ///
	"Q7. Do you think the central bank can control inflation in the next 12 months or so?"

replace w5_RBNZ_control_12m="1" if w5_RBNZ_control_12m=="Yes"
replace w5_RBNZ_control_12m="0" if w5_RBNZ_control_12m=="No"
destring w5_RBNZ_control_12m, force replace

	
label values w5_RBNZ_control_12m w5_CPI_credible0
tab w5_RBNZ_control_12m

*=========================================================

rename q8 w5_RBNZ_control_5yrs
label var w5_RBNZ_control_5yrs ///
	"Q7. Do you think the central bank can control inflation over the next 5 to 10 years?"

replace w5_RBNZ_control_5yrs="1" if w5_RBNZ_control_5yrs=="Yes"
replace w5_RBNZ_control_5yrs="0" if w5_RBNZ_control_5yrs=="No"
destring w5_RBNZ_control_5yrs, force replace

label values w5_RBNZ_control_5yrs w5_CPI_credible0
tab w5_RBNZ_control_5yrs
	
*=========================================================

rename q9 w5_infl_exp_form
label var w5_infl_exp_form ///
	"Q9. How do you typically form your inflation expectations?"

*=========================================================

rename q10_1 w5_form_family
label var w5_form_family ///
	"Q10. Importance of info source in forming your infl. expectations: family and friends"

rename q10_2 w5_form_empl
label var w5_form_empl ///
	"Q10. Importance of info source in forming your infl. expectations: employees & colleagues"
	
rename q10_3 w5_form_cust
label var w5_form_cust ///
	"Q10. Importance of info source in forming your infl. expectations: customers & suppliers"

	
rename q10_4 w5_form_gas
label var w5_form_gas ///
	"Q10. Importance of info source in forming your infl. expectations: Gas prices"

rename q10_5 w5_form_shop
label var w5_form_shop ///
	"Q10. Importance of info source in forming your infl. expectations: personal shopping experience"

rename q10_6 w5_form_govt
label var w5_form_govt ///
	"Q10. Importance of info source in forming your infl. expectations: Government agencies"

rename q10_7 w5_form_fair
label var w5_form_fair ///
	"Q10. Importance of info source in forming your infl. expectations: Business associations/chambers of commerce/trade fairs "

rename q10_8 w5_form_media
label var w5_form_media ///
	"Q10. Importance of info source in forming your infl. expectations: Media (TV, newspapers, etc.)"

rename q10_9 w5_form_prof
label var w5_form_prof ///
	"Q10. Importance of info source in forming your infl. expectations: Professional forecasts"

label define w5_form0 ///
	1	"Not important" ///
	2	"Slightly important" ///
	3	"Fairly important" ///
	4	"Very important" ///
	5	"Extremely important" ///
	9	"Do not know"

foreach var in family empl cust gas shop govt fair media prof {
	label values w5_form_`var' w5_form0
	replace w5_form_`var'=. if w5_form_`var'==9
}
	

*=========================================================

rename q11 w5_infl_exp_use
label var  w5_infl_exp_use "How do you typically use your inflation expectations?"


*=========================================================

gen w5_infl_exp_discuss=. 
replace w5_infl_exp_discuss=1 if q12_1=="Yes"
replace w5_infl_exp_discuss=2 if q12_2=="Yes"
replace w5_infl_exp_discuss=3 if q12_3=="Yes"
replace w5_infl_exp_discuss=4 if q12_4=="Yes"

label define w5_infl_exp_discuss0 ///
	1	"Colleagues within your firm" ///
	2	"Outside consultants" ///
	3	"Relatives and friends" ///
	4	"Nobody" 

label values w5_infl_exp_discuss w5_infl_exp_discuss0
label var w5_infl_exp_discuss ///
	"Q.12 Do you typically discuss your inflation expectations with anybody?"


tab w5_infl_exp_discuss

drop q12_*

*===========================================================
rename q13_1 w5_wgt_agg_inflation
label var w5_wgt_agg_inflation "Weight on aggregate (vs  industry) inflation for your business decisions"

sum w5_wgt_agg_inflation
drop q13_2

*===========================================================
rename q14_1 w5_reason_different
label var w5_reason_different ///
	"Why Report Higher or Different Inflation Expectations?"

rename q14_2 w5_reason_consistent
label var w5_reason_consistent ///
	"Why Report Inflation Expectations consistent with the RBNZ target?"

*=========================================================

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
compress
notes: "step045 - process wave 5"
save wave5, replace
