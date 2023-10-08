clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear


gen anzsic_code3=floor(anzsic_code/10)

*=========================================================================
* 	chech that the number of ACTUAL price chnages is correlated with 
*   the reported AVERAGE frequency of price changes
*	Panel A
*=========================================================================
* calculate the number of price changes over the last twelve months
gen d_12_9=abs( log(w1_price_9m/w1_price_12m))>0.01 if w1_price_9m~=. & w1_price_12m~=.
gen d_9_6=abs( log(w1_price_6m/w1_price_9m))>0.01   if w1_price_6m~=. & w1_price_9m~=.
gen d_6_3=abs( log(w1_price_3m/w1_price_6m))>0.01   if w1_price_3m~=. & w1_price_6m~=.
gen d_3_0=abs( log(w1_price/w1_price_3m))>0.01      if w1_price~=.  & w1_price_3m~=.

egen ndp=rsum(d_12_9 d_9_6 d_6_3 d_3_0)

*** PANEL A:
reg ndp w1_price_review_frequency  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelA.txt", replace dec(3) ctitle("ols") nocons

xi: reg ndp w1_price_review_frequency i.agg1  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelA.txt", append dec(3) ctitle("agg1") nocons

xi: reg ndp w1_price_review_frequency i.agg2  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelA.txt", append dec(3) ctitle("agg2") nocons

*=========================================================================
*** check if AVERAGE frequency of price reviews is similar in the first and
*** second waves of the survey
*** Panel B
*=========================================================================

reg w2_price_review_frequency_main w1_price_review_frequency  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelB.txt", replace dec(3) ctitle("ols") nocons

xi: reg w2_price_review_frequency_main w1_price_review_frequency i.agg1  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelB.txt", append dec(3) ctitle("agg1") nocons

xi: reg w2_price_review_frequency_main w1_price_review_frequency i.agg2  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 w1_price_review_frequency using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelB.txt", append dec(3) ctitle("agg2") nocons

*=========================================================================
*** cross-cehck that 3-month-ago price in the follow-up survey is close
*** to the actual price reported in the first wave of the survey
*** Panel C
*=========================================================================

gen ln_p0=log(w1_price)
gen ln_p3l_fs=log(w2_price_3m)
gen ln_p6l_fs=log(w2_price_6m)

gen ln_recall_diff6 = (ln_p0-ln_p6l_fs)*100
gen abs_ln_recall_diff6 = abs(ln_p0-ln_p6l_fs)*100

*** recall price
gen recall_ln_p=ln_p3l_fs if w1_survey_month==1 | w1_survey_month==12
replace recall_ln_p=ln_p6l_fs if w1_survey_month==11 | w1_survey_month==10 | w1_survey_month==9


reg recall_ln_p ln_p0  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 ln_p0 using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelC.txt", replace dec(3) ctitle("ols") nocons

xi: reg recall_ln_p ln_p0 i.agg1  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 ln_p0 using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelC.txt", append dec(3) ctitle("agg1") nocons

xi: reg recall_ln_p ln_p0 i.agg2  [aw=wgtE43] , robust cluster(anzsic_code3)
outreg2 ln_p0 using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelC.txt", append dec(3) ctitle("agg2") nocons


*=========================================================================
*** check if the price in the follow-up survey is different from the price
*** in the first way AND if the change/time is predicted by the 
*** planned size and time of price change in the first wave
*** Panel D
*=========================================================================
capture drop dp_fs 
gen dp_fs=(w2_price-w1_price)/w1_price*100 
capture drop flag_dp_fs
gen flag_dp_fs=abs(dp_fs)>1 if dp_fs~=.

*** Dummy equal to one if predicted price change is in less than (or equal to)
*** five months
gen pred_time_to_dpD5=(w1_edp_time_main<=5) if w1_edp_time_main~=.

	   
reg dp_fs w1_edp_size_main  [aw=wgtE43]  if pred_time_to_dpD5==1 & flag_dp_fs==1, robust cluster(anzsic_code3)
outreg2 w1_edp_size_main using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelD.txt", replace dec(3) ctitle("ols") nocons

xi: reg dp_fs w1_edp_size_main i.agg1  [aw=wgtE43]  if pred_time_to_dpD5==1 & flag_dp_fs==1, robust cluster(anzsic_code3)
outreg2 w1_edp_size_main using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelD.txt", append dec(3) ctitle("agg1") nocons

xi: reg dp_fs w1_edp_size_main i.agg2  [aw=wgtE43]  if pred_time_to_dpD5==1 & flag_dp_fs==1, robust cluster(anzsic_code3)
outreg2 w1_edp_size_main using "C:\Dropbox\Firm Survey\AER-final\replication_folder\output\AppendixTable_1_3_1_PanelD.txt", append dec(3) ctitle("agg2") nocons

