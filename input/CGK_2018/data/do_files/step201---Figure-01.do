clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

*=========================================================================
*** 				Panel B
*=========================================================================
capture drop dp_fs 
gen dp_fs=(w2_price - w1_price)/w1_price*100 
capture drop flag_dp_fs
gen flag_dp_fs=abs(dp_fs)>1 if dp_fs~=.
*** Dummy equal to one if predicted price change is in less than (or equal to)
*** three months
gen pred_time_to_dpD3=(w1_edp_time_main<=3) if w1_edp_time_main~=.

*** Dummy equal to one if predicted price change is in less than (or equal to)
*** five months
gen pred_time_to_dpD5=(w1_edp_time_main<=5) if w1_edp_time_main~=.

egen flag_dp_fs_mean=mean(flag_dp_fs), by(w1_edp_time_main)
egen flag_dp_fs_N=count(flag_dp_fs), by(w1_edp_time_main)
label var flag_dp_fs_N "Number of firms plannig to change price"
sort w1_edp_time_main
	
gen flag_dp_fs_mean0=flag_dp_fs_mean
	
twoway (scatter dp_fs w1_edp_size_main if pred_time_to_dpD3==1 & abs(dp_fs)<=20, jitter(3) msize(small) msymbol(Oh)) ///
	   (scatter dp_fs w1_edp_size_main if pred_time_to_dpD3==0 & pred_time_to_dpD5==1 & abs(dp_fs)<=20, jitter(3)  msymbol(x) xlabel(-20(5)20) ) ///
	, ytitle("Actual price change in the follow-up survey") ///
	legend(label(1 "plan to change price in 3 months or less") ///
		   label(2 "plan to change price in 4-5 months") ///
		   rows(2)) ///
		   name(panelB, replace) ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_01_PanelB.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_01_PanelB.pdf", replace 

*=========================================================================
*** 				Panel A
*=========================================================================

capture drop dp_fs
gen dp_fs=(w2_price - w2_price_6m )/w1_price*100  if w1_survey_month==9 | w1_survey_month==10 | w1_survey_month==11
replace dp_fs=(w2_price - w2_price_3m)/w1_price*100  if w1_survey_month==12 | w1_survey_month==1

capture drop flag_dp_fs
gen flag_dp_fs=abs(dp_fs)>1 & dp_fs~=.  if w1_survey_month==9 | w1_survey_month==10 | w1_survey_month==11
replace flag_dp_fs=abs(dp_fs)>1 & dp_fs~=.  if w1_survey_month==12 | w1_survey_month==1

replace flag_dp_fs=. if w2_price==.
replace dp_fs=. if w2_price==.

capture drop flag_dp_fs_mean
egen flag_dp_fs_mean=mean(flag_dp_fs), by(w1_edp_time_main)
capture drop flag_dp_fs_N
egen flag_dp_fs_N=count(flag_dp_fs), by(w1_edp_time_main)
label var flag_dp_fs_N "Number of firms plannig to change price"
	
*** reported	
twoway (bar flag_dp_fs_N w1_edp_time_main, yaxis(2) ///
		    ytitle("Number of firms plannig to change price", axis(2)) ) ///
		(line flag_dp_fs_mean0 w1_edp_time_main, lcolor(red) lwidth(thick) ///
			ytitle("Share of firms changing prices in the follow-up survey")) ///
		(line flag_dp_fs_mean w1_edp_time_main, lcolor(black) lwidth(thick) ///
			ytitle("Share of firms changing prices in the follow-up survey")) ///			
	   , ///
		legend(label(1 " number") ///
			label(2 "share (actual)") ///
			label(3 "share (recall)") ///
			 rows(1))	///
		   name(panelA, replace) ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_01_PanelA.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_01_PanelA.pdf", replace 

	   
