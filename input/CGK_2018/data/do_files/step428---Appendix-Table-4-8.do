clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

gen w7_anzsic_code3=floor(w7_anzsic_cod/10)
gen w7_anzsic_code2=floor(w7_anzsic_cod/100)
gen w7_anzsic_code1=floor(w7_anzsic_cod/1000)

 *=======================================================================
 *						controls
 *=======================================================================
 *** capacity utilization
 gen logCU=log(w6_actual_output_all/w6_pot_output_all)
 winsor logCU, gen(logCU_w) p(0.01)
 
 *** employment
 gen lnL=log(w6_employment)
 winsor lnL, gen(lnL_w) p(0.01)
 
 *** slope of the profit function
 gen abs_slope=abs(w6_dy_dp_now / w6_dp_now)
 winsor abs_slope, gen(abs_slope_w) p(0.01)

 *** age of the firm
 gen log_age=log(w6_firm_age)
 
 *** labor cost share
 gen sL=w6_labor_cost_share
 
*=========================================================================
*			compute implied means from distrib. questions
*=========================================================================
quiet foreach wave0 in w6 w7 {
noisily di "`wave0': eue"
capture drop _rm
 egen _rm=rownonmiss(w6_eue_12m_*)

foreach var in 	`wave0'_eue_12m_10plus `wave0'_eue_12m_9_10 `wave0'_eue_12m_8_9 ///
				`wave0'_eue_12m_7_8 `wave0'_eue_12m_6_7 `wave0'_eue_12m_5_6 ///
				`wave0'_eue_12m_4_5 `wave0'_eue_12m_3_4 `wave0'_eue_12m_less3 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_eue_12m_implied_hold = `wave0'_eue_12m_10plus*10 ///
								+ `wave0'_eue_12m_9_10*9.5 ///
								+ `wave0'_eue_12m_8_9*8.5 ///
								+ `wave0'_eue_12m_7_8*7.5 ///
								+ `wave0'_eue_12m_6_7*6.5 ///
								+ `wave0'_eue_12m_5_6*5.5 ///
								+ `wave0'_eue_12m_4_5*4.5 ///
								+ `wave0'_eue_12m_3_4*3.5 ///
								+ `wave0'_eue_12m_less3*3
gen `wave0'_eue_12m_implied =`wave0'_eue_12m_implied_hold/100

*****
noisily di "`wave0': epi_5y"
egen _rm=rownonmiss(`wave0'_epi_5y_*)

foreach var in 	`wave0'_epi_5y_25plus `wave0'_epi_5y_15_25 ///
				`wave0'_epi_5y_10_15 `wave0'_epi_5y_8_10 `wave0'_epi_5y_6_8 ///
				`wave0'_epi_5y_4_6 `wave0'_epi_5y_2_4 `wave0'_epi_5y_0_2 ///
				`wave0'_epi_5y_0_neg2 `wave0'_epi_5y_neg2_neg4 `wave0'_epi_5y_neg4_neg6 ///
				`wave0'_epi_5y_neg6_neg8 `wave0'_epi_5y_neg8_neg10 ///
				`wave0'_epi_5y_neg10_neg15 `wave0'_epi_5y_neg15_neg25 `wave0'_epi_5y_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_5y_implied = `wave0'_epi_5y_25plus*25 ///
							+ `wave0'_epi_5y_15_25*20 ///
							+ `wave0'_epi_5y_10_15*12.5 ///
							+ `wave0'_epi_5y_8_10*9 ///
							+ `wave0'_epi_5y_6_8*7 ///
							+ `wave0'_epi_5y_4_6*5 ///
							+ `wave0'_epi_5y_2_4*3 ///
							+ `wave0'_epi_5y_0_2*1 ///
							+ `wave0'_epi_5y_0_neg2*(-1) ///
							+ `wave0'_epi_5y_neg2_neg4*(-3) ///
							+ `wave0'_epi_5y_neg4_neg6*(-5) ///
							+ `wave0'_epi_5y_neg6_neg8*(-7) ///
							+ `wave0'_epi_5y_neg8_neg10*(-9) ///
							+ `wave0'_epi_5y_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_5y_neg15_neg25*(-20) ///
							+ `wave0'_epi_5y_moreneg25*(-25)

replace `wave0'_epi_5y_implied=`wave0'_epi_5y_implied/100

*****
noisily di "`wave0': epi_ind"
egen _rm=rownonmiss(`wave0'_epi_ind_12m_*)

foreach var in 	`wave0'_epi_ind_12m_25plus `wave0'_epi_ind_12m_15_25 ///
				`wave0'_epi_ind_12m_10_15 `wave0'_epi_ind_12m_8_10 `wave0'_epi_ind_12m_6_8 ///
				`wave0'_epi_ind_12m_4_6 `wave0'_epi_ind_12m_2_4 `wave0'_epi_ind_12m_0_2 ///
				`wave0'_epi_ind_12m_0_neg2 `wave0'_epi_ind_12m_neg2_neg4 `wave0'_epi_ind_12m_neg4_neg6 ///
				`wave0'_epi_ind_12m_neg6_neg8 `wave0'_epi_ind_12m_neg8_neg10 ///
				`wave0'_epi_ind_12m_neg10_neg15 `wave0'_epi_ind_12m_neg15_neg25 `wave0'_epi_ind_12m_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_ind_12m_implied = `wave0'_epi_ind_12m_25plus*25 ///
							+ `wave0'_epi_ind_12m_15_25*20 ///
							+ `wave0'_epi_ind_12m_10_15*12.5 ///
							+ `wave0'_epi_ind_12m_8_10*9 ///
							+ `wave0'_epi_ind_12m_6_8*7 ///
							+ `wave0'_epi_ind_12m_4_6*5 ///
							+ `wave0'_epi_ind_12m_2_4*3 ///
							+ `wave0'_epi_ind_12m_0_2*1 ///
							+ `wave0'_epi_ind_12m_0_neg2*(-1) ///
							+ `wave0'_epi_ind_12m_neg2_neg4*(-3) ///
							+ `wave0'_epi_ind_12m_neg4_neg6*(-5) ///
							+ `wave0'_epi_ind_12m_neg6_neg8*(-7) ///
							+ `wave0'_epi_ind_12m_neg8_neg10*(-9) ///
							+ `wave0'_epi_ind_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_ind_12m_neg15_neg25*(-20) ///
							+ `wave0'_epi_ind_12m_moreneg25*(-25)

replace `wave0'_epi_ind_12m_implied=`wave0'_epi_ind_12m_implied/100


******
noisily di "`wave0': egdp"
egen _rm=rownonmiss(`wave0'_egdp_12m_*)

foreach var in 	`wave0'_egdp_12m_6plus `wave0'_egdp_12m_5_6 `wave0'_egdp_12m_4_5 ///
				`wave0'_egdp_12m_3_4 `wave0'_egdp_12m_2_3 `wave0'_egdp_12m_1_2 `wave0'_egdp_12m_0_1 ///
				`wave0'_egdp_12m_neg1_0 `wave0'_egdp_12m_neg2_neg1 ///
				`wave0'_egdp_12m_neg2_neg3 ///
				 `wave0'_egdp_12m_neg3_neg4 `wave0'_egdp_12m_neg4_neg5 ///
				 `wave0'_egdp_12m_neg5_neg6 `wave0'_egdp_12m_moreneg6 ///
				{
				noisily di "`var'"
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

 gen `wave0'_egdp_12m_implied_hold = `wave0'_egdp_12m_6plus*6 ///
								+ `wave0'_egdp_12m_5_6*5.5 ///
								+ `wave0'_egdp_12m_4_5*4.5 ///
								+ `wave0'_egdp_12m_3_4*3.5 ///
								+ `wave0'_egdp_12m_2_3*2.5 ///
								+ `wave0'_egdp_12m_1_2*1.5 ///
								+ `wave0'_egdp_12m_0_1*0.5 ///
								+ `wave0'_egdp_12m_neg1_0*(-0.5) ///
								+ `wave0'_egdp_12m_neg2_neg1*(-1.5) ///
								+ `wave0'_egdp_12m_neg2_neg3*(-2.5) ///
								+ `wave0'_egdp_12m_neg3_neg4*(-3.5) ///
								+ `wave0'_egdp_12m_neg4_neg5*(-4.5) ///
								+ `wave0'_egdp_12m_neg5_neg6*(-5.5) ///
								+ `wave0'_egdp_12m_moreneg6*(-6)
								
 gen `wave0'_egdp_12m_implied=`wave0'_egdp_12m_implied_hold /100
 


*****
noisily di "`wave0': epi_12m"
egen _rm=rownonmiss(`wave0'_epi_12m_*)

foreach var in 	`wave0'_epi_12m_25plus `wave0'_epi_12m_15_25 ///
				`wave0'_epi_12m_10_15 `wave0'_epi_12m_8_10 `wave0'_epi_12m_6_8 ///
				`wave0'_epi_12m_4_6 `wave0'_epi_12m_2_4 `wave0'_epi_12m_0_2 ///
				`wave0'_epi_12m_0_neg2 `wave0'_epi_12m_neg2_neg4 `wave0'_epi_12m_neg4_neg6 ///
				`wave0'_epi_12m_neg6_neg8 `wave0'_epi_12m_neg8_neg10 ///
				`wave0'_epi_12m_neg10_neg15 `wave0'_epi_12m_neg15_neg25 `wave0'_epi_12m_moreneg25 ///
				{	
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_12m_implied = `wave0'_epi_12m_25plus*25 ///
							+ `wave0'_epi_12m_15_25*20 ///
							+ `wave0'_epi_12m_10_15*12.5 ///
							+ `wave0'_epi_12m_8_10*9 ///
							+ `wave0'_epi_12m_6_8*7 ///
							+ `wave0'_epi_12m_4_6*5 ///
							+ `wave0'_epi_12m_2_4*3 ///
							+ `wave0'_epi_12m_0_2*1 ///
							+ `wave0'_epi_12m_0_neg2*(-1) ///
							+ `wave0'_epi_12m_neg2_neg4*(-3) ///
							+ `wave0'_epi_12m_neg4_neg6*(-5) ///
							+ `wave0'_epi_12m_neg6_neg8*(-7) ///
							+ `wave0'_epi_12m_neg8_neg10*(-9) ///
							+ `wave0'_epi_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_12m_neg15_neg25*(-20) ///
							+ `wave0'_epi_12m_moreneg25*(-25)

replace `wave0'_epi_12m_implied=`wave0'_epi_12m_implied/100

}

di "done"
*=========================================================================
*			compute implied std from distrib. questions
*=========================================================================
quiet foreach wave0 in w6 w7 {
foreach var0 in _12m_ _5y_ _ind_12m_  {
noisily di "uncertainty: `wave0': `var0'"
gen `wave0'_epi`var0'uncertainty_hold= ///
								  `wave0'_epi`var0'25plus*((25-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'15_25*((20-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'10_15*((12.5-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'8_10*((9-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'6_8*((7-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'4_6*((5-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'2_4*((3-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'0_2*((1-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'0_neg2*(((-1)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg2_neg4*(((-3)-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'neg4_neg6*(((-5)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg6_neg8*(((-7)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg8_neg10*(((-9)-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'neg10_neg15*(((-12.5)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg15_neg25*(((-20)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'moreneg25*(((-25)-`wave0'_epi`var0'implied)^2)

gen `wave0'_epi`var0'uncertainty=`wave0'_epi`var0'uncertainty_hold/100
gen `wave0'_epi`var0'std=sqrt(`wave0'_epi`var0'uncertainty)
}
}

******
quiet foreach wave0 in w6 w7 {
capture drop `wave0'_eue_12m_implied_hold

gen `wave0'_eue_12m_implied_hold = `wave0'_eue_12m_10plus*(10-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_9_10*(9.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_8_9*(8.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_7_8*(7.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_6_7*(6.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_5_6*(5.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_4_5*(4.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_3_4*(3.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_less3*(3-`wave0'_eue_12m_implied)^2
								
gen `wave0'_eue_12m_uncertainty =`wave0'_eue_12m_implied_hold/100
gen `wave0'_eue_12m_std=sqrt(`wave0'_eue_12m_uncertainty)
}

******
quiet foreach wave0 in w6 w7 {
capture drop `wave0'_egdp_12m_implied_hold 

 gen `wave0'_egdp_12m_implied_hold = `wave0'_egdp_12m_6plus*(6-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_5_6*(5.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_4_5*(4.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_3_4*(3.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_2_3*(2.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_1_2*(1.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_0_1*(0.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg1_0*(-0.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg2_neg1*(-1.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg2_neg3*(-2.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg3_neg4*(-3.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg4_neg5*(-4.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg5_neg6*(-5.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_moreneg6*(-6-`wave0'_egdp_12m_implied)^2
								
gen `wave0'_egdp_12m_uncertainty =`wave0'_egdp_12m_implied_hold/100
gen `wave0'_egdp_12m_std=sqrt(`wave0'_egdp_12m_uncertainty) 
 
}

*=========================================================================
*			calculate revisions: forecast errors
*=========================================================================

*** Firm specific variable bloc
*** sales
gen rev_sales_6m = w7_dsales_6m - w6_edsales_6m 
*** wages
gen rev_dw_6m = w7_dw_6m - w6_edw_6m 
*** unit cost
gen rev_dmc_6m = w7_dmc_6m - w6_edmc_6m 
*** capital 
gen rev_dk_6m = w7_dk_6m - w6_edk_6m 
*** employment
gen rev_dn_6m = w7_dn_6m - w6_edn_6m 
*** price for the main product
gen rev_dp_main_6m = w7_dp_main_6m - w6_edp_main_6m 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
*** revision in the RBNZ target
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen rev_RBNZ_target_6m = w7_rbnz_target - w6_rbnz_target 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Macro/firm-specific variables forecast revision after 6 months
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** revision in the inflation forecast after 6 months: 12 months
gen rev_epi_12m = w7_epi_12m - w6_epi_12m 

*** revision in the unemployment forecast after 6 months: 12 months
gen rev_eue_12m = w7_eue_12m - w6_eue_12m_implied 

*** revision in the gdp forecast after 6 months: 12 months
gen rev_egdp_12m = w7_egdp_12m - w6_egdp_12m_implied 

*** revision in the inflation forecast after: 5 years
gen rev_epi_5y = w7_epi_5y - w6_epi_5y_implied

*** revision in the (industry) inflation forecast after 6 months: 12 months
gen rev_epi_ind_12m = w7_epi_ind_12m - w6_epi_ind_12m_implied

*** revision in the plan for its own price after 6 month: 12 months
gen rev_edp_main_12m = w7_edp_main_12m - w6_edp_main_12m 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Experimental bloc
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** revision in the inflation forecast after info is introduced: 12 months
gen rev_epi_12m_exper = w6_epi_exper_12m - w6_epi_12m

*** revision in the inflation forecast after info is introduced: 5 years
gen rev_epi_5y_exper = w6_epi_exper_5y - w6_epi_5y_implied 

*** revision in the industry inflation forecast after  info is introduced: 12 months
gen rev_epi_ind_12m_exper = w6_epi_ind_exper_12m - w6_epi_ind_12m_implied

*** price for the main product (experiment: right after the info)
gen rev_dp_main_exper_12m=w6_edp_exper_main_12m-w6_edp_main_12m
	
*** revision in the unemployment forecast after  info is introduced: 12 months
gen rev_eue_12m_exper = w6_eue_exper_12m - w6_eue_12m_implied 

*** revision in the gdp forecast after  info is introduced: 12 months
gen rev_egdp_12m_exper = w6_egdp_exper_12m - w6_egdp_12m_implied 


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Macro/firm-specific variables forecast UNCERTIAINTY 
*** revision after 6 months
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** revision in the inflation forecast after 6 months: 12 months
gen rev_epi_12m_std = w7_epi_12m_std - w6_epi_12m_std

*** revision in the unemployment forecast after 6 months: 12 months
gen rev_eue_12m_std = w7_eue_12m_std - w6_eue_12m_std 

*** revision in the gdp forecast after 6 months: 12 months
gen rev_egdp_12m_std = w7_egdp_12m_std - w6_egdp_12m_std

*** revision in the inflation forecast after EXPERIMENT: 5 years
gen rev_epi_5y_std = w7_epi_5y_std - w6_epi_5y_std

*** revision in the (industry) inflation forecast after 6 months: 12 months
gen rev_epi_ind_12m_std = w7_epi_ind_12m_std - w6_epi_ind_12m_std

*=========================================================================
*			define treatment
*=========================================================================

 gen hasinfo=-1
 replace hasinfo=0 if w6_exp_info=="No"
 replace hasinfo=1 if w6_exp_info=="Yes"
  
 keep if hasinfo==0 | hasinfo==1
  
 label var hasinfo "Received Experiment Info?"
 label define hasinfo0 0 "No" 1 "Yes"
 label values hasinfo hasinfo0

  
*** the size of the error in wave 6  
gen T6=w6_rbnz_target-2
label var T6 "RBNZ Target Forecast Error"

capture drop nT_*
capture drop yT_*
local cc=1
forvalues i=-1(1)6 {
	gen nT_`cc'=(T6==`i')
	gen yT_`cc'=(T6==`i')*(hasinfo==1) /* this is the main coefficient */
	local cc=`cc'+1
}

*** low treatment group 
replace nT_2=nT_2-nT_1 
replace nT_3=nT_3-nT_1 
replace nT_1=nT_1*3

replace yT_2=yT_2-yT_1
replace yT_3=yT_3-yT_1
replace yT_1=yT_1*3

*** high treatment group 
replace nT_5=nT_5-nT_4
replace nT_6=nT_6-nT_4 
replace nT_7=nT_7-nT_4 
replace nT_8=nT_8-nT_4 
replace nT_4=nT_4*5

replace yT_5=yT_5-yT_4
replace yT_6=yT_6-yT_4 
replace yT_7=yT_7-yT_4 
replace yT_8=yT_8-yT_4 
replace yT_4=yT_4*5
	
	
*=========================================================================
*			look for outliers
*=========================================================================

capture drop c4* c1*
capture drop se*
	
capture drop nn
gen nn=_n
	
	quiet foreach var in ///
			w7_dsales_6m w7_dw_6m w7_dmc_6m w7_dk_6m w7_dn_6m w7_dp_main_6m ///
			w6_epi_exper_12m w6_epi_exper_5y w6_eue_exper_12m w6_egdp_exper_12m ///
			w7_epi_12m w7_epi_5y  w7_eue_12m  w7_egdp_12m w7_rbnz_target ///
			{
			
			
				gen c4_`var'=.
				gen se4_`var'=.
				gen c1_`var'=.
				gen se1_`var'=.


				quiet forvalues n1=1(1)2040 {
					noisily di "`var': `n1'"
					*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					*		no controls
					*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					reg `var' nT_* yT_* [aw=w7_wgtE_43] if `n1'~=nn , nocons robust cluster(w7_anzsic_code3)

					replace c4_`var'=_b[yT_4] if `n1'==nn 
					replace se4_`var'=_se[yT_4] if `n1'==nn 

					replace c1_`var'=_b[yT_1] if `n1'==nn 
					replace se1_`var'=_se[yT_1] if `n1'==nn 

				}
			}

compress
save temp_306_long, replace
			
*========================================================================


use temp_306_long, clear

quiet foreach var in ///
			w7_dsales_6m w7_dw_6m w7_dmc_6m w7_dk_6m w7_dn_6m w7_dp_main_6m ///
			w6_epi_exper_12m w6_epi_exper_5y w6_eue_exper_12m w6_egdp_exper_12m ///
			w7_epi_12m w7_epi_5y  w7_eue_12m  w7_egdp_12m w7_rbnz_target ///
			{
			gen flag_`var'=1
			}
	
replace flag_w7_dsales_6m=0 if c4_w7_dsales_6m<-.7 | c4_w7_dsales_6m>0
replace flag_w7_dsales_6m=0 if c1_w7_dsales_6m<.35 | c1_w7_dsales_6m>0.55
	
replace flag_w7_dw_6m=0 if c4_w7_dw_6m<0.066 | c4_w7_dw_6m>0.14
replace flag_w7_dw_6m=0 if c1_w7_dw_6m>-0.13

replace flag_w7_dmc_6m=0 if  c4_w7_dmc_6m>0.05
replace flag_w7_dmc_6m=0 if c1_w7_dmc_6m>0.05

replace flag_w7_dk_6m=0 if c4_w7_dk_6m<-1.5 
replace flag_w7_dk_6m=0 if c1_w7_dk_6m>-1.2


replace flag_w7_dn_6m=0 if c4_w7_dn_6m<-1 
replace flag_w7_dn_6m=0 if c1_w7_dn_6m>=-1.21
	
replace flag_w6_epi_exper_12m=0 if c4_w6_epi_exper_12m>-1.1

replace flag_w6_epi_exper_5y=0 if c4_w6_epi_exper_5y>-1 

replace flag_w6_epi_exper_5y=0 if c4_w6_epi_exper_5y>-1 

replace flag_w6_egdp_exper_12m=0 if c4_w6_egdp_exper_12m<.13 
replace flag_w6_egdp_exper_12m=0 if c1_w6_egdp_exper_12m>.2 

replace flag_w7_epi_12m=0 if c4_w7_epi_12m>.3 

replace flag_w7_epi_5y=0 if c4_w7_epi_5y>.3 
replace flag_w7_rbnz_target=0 if c4_w7_rbnz_target>.15 
replace flag_w7_rbnz_target=0 if c1_w7_rbnz_target<-0.05 
		
		
		 
		 
*=========================================================================
*			estimate treatment effects on "forecast errors"
*=========================================================================

 capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
tempname 1
postfile `1' str20 varx ///
	str25 treat_high_nocontrols str25 treat_low_nocontrols ///
	str25 treat_high_controls 	str25 treat_low_controls ///
	using Appendix_Table_4_8, replace every(1)
		
capture drop t0
gen t0=_n-10


quiet foreach var in ///
			w7_dsales_6m w7_dw_6m w7_dmc_6m w7_dk_6m w7_dn_6m w7_dp_main_6m ///
			w6_epi_exper_12m w6_epi_exper_5y w6_eue_exper_12m w6_egdp_exper_12m ///
			w7_epi_12m w7_epi_5y  w7_eue_12m  w7_egdp_12m w7_rbnz_target ///
			{

			
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*		no controls
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg `var'  nT_* yT_* [aw=w7_wgtE_43] if flag_`var'==1, nocons robust cluster(w7_anzsic_code3)

lincom yT_4
* lincom (yT_5+yT_6+yT_7+yT_8)/4
local c4=strofreal(r(estimate),"%4.3f") 
local se4=strofreal(r(se),"%4.3f") 
local tval=r(estimate)/r(se)
if abs(`tval')<=1.660 local pval4=" "
if abs(`tval')>1.660 local pval4="*"
if abs(`tval')>1.984 local pval4="**"
if abs(`tval')>2.626 local pval4="***"
local c4str="`c4'"+"`pval4'"
local se4str="("+"`se4'"+")"

lincom yT_1
local c5=strofreal(r(estimate),"%4.3f") 
local se5=strofreal(r(se),"%4.3f") 
local tval=r(estimate)/r(se)
if abs(`tval')<=1.660 local pval5=" "
if abs(`tval')>1.660 local pval5="*"
if abs(`tval')>1.984 local pval5="**"
if abs(`tval')>2.626 local pval5="***"
local c5str="`c5'"+"`pval5'"
local se5str="("+"`se5'"+")"

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*		 controls
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg `var'  nT_* yT_*  ///
	logCU_w lnL_w abs_slope_w log_age w6_labor_cost_share ///
	w6_competitors i.w7_anzsic_code1 [aw=w7_wgtE_43] if flag_`var'==1, ///
	nocons robust cluster(w7_anzsic_code3)

lincom yT_4
local c4=strofreal(r(estimate),"%4.3f") 
local se4=strofreal(r(se),"%4.3f") 
local tval=r(estimate)/r(se)
if abs(`tval')<=1.660 local pval4=" "
if abs(`tval')>1.660 local pval4="*"
if abs(`tval')>1.984 local pval4="**"
if abs(`tval')>2.626 local pval4="***"
di "`pval4'"
local c6str="`c4'"+"`pval4'"
local se6str="("+"`se4'"+")"

lincom  yT_1 
local c5=strofreal(r(estimate),"%4.3f") 
local se5=strofreal(r(se),"%4.3f") 
local tval=r(estimate)/r(se)
if abs(`tval')<=1.660 local pval5=" "
if abs(`tval')>1.660 local pval5="*"
if abs(`tval')>1.984 local pval5="**"
if abs(`tval')>2.626 local pval5="***"
di "`pval5'"
local c7str="`c5'"+"`pval5'"
local se7str="("+"`se5'"+")"


post `1' ("`var'")  ("`c4str'") ("`c5str'") ("`c6str'") ("`c7str'") 
post `1' (" ")  ("`se4str'") ("`se5str'") ("`se6str'") ("`se7str'") 


}
	   
postclose `1'
