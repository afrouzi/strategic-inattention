clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear


 cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
 do load_rreg2
 

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
foreach var0 in _12m_ _5y_ _ind_12m_ {
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

 *==============================================================================
 *				Revisions
 *==============================================================================
 
 gen hasinfo=-1
 replace hasinfo=0 if w6_exp_info=="No"
 replace hasinfo=1 if w6_exp_info=="Yes"
  
 keep if hasinfo==0 | hasinfo==1
 
 

 capture drop epi_treatment
 gen epi_treatment=hasinfo


 gen epi_signal=1 if hasinfo==1
 
 gen w6_epi_exper_12m_treated=w6_epi_exper_12m if hasinfo==1
 gen w6_epi_exper_5y_treated=w6_epi_exper_5y if hasinfo==1

 *** Normalized revisions
 *** one year ahead inflation forecast 
 gen D_epi_norm = (w6_epi_exper_12m - w6_epi_12m_implied)/(epi_signal-w6_epi_12m_implied)
 gen D_epi_norm_w=D_epi_norm if abs(D_epi_norm)<2
 
 *** 5-10 year ahead inflation forecast 
 gen D_epi_norm5 = (w6_epi_exper_5y - w6_epi_5y_implied)/(epi_signal-w6_epi_5y_implied)
 gen D_epi_norm5_w=D_epi_norm5 if abs(D_epi_norm5)<2
 
	
 *==============================================================================
 *			Panel A: dependent variables p_i
 *==============================================================================
 capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

 *** one-year ahead inflation forecast
	capture drop rreg_*
	capture drop ones
	gen ones=1

	
	rreg2 w6_epi_exper_12m_treated w6_epi_12m_implied ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  xi: reg w6_epi_exper_12m_treated w6_epi_12m_implied [aw=wgt0], robust
  outreg2 w6_epi_12m_implied   using "AppendixTable_4_4.txt", replace dec(3) ctitle("pool: 12m") nocons
  
	
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *** one-year ahead inflation forecast
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w6_epi_exper_5y_treated w6_epi_5y_implied ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  xi: reg w6_epi_exper_5y_treated w6_epi_5y_implied [aw=wgt0], robust
  outreg2 w6_epi_5y_implied   using "AppendixTable_4_4.txt", append dec(3) ctitle("pool: 5y") nocons
  
	
	
 *==============================================================================
 *				Panel B: dependent variable scaled revisions
 *==============================================================================
 
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
  
	*** one  year ahead
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w6_epi_12m_std ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w6_epi_12m_std  [aw=wgt0], robust 
  outreg2 w6_epi_12m_std  using "AppendixTable_4_4.txt", append dec(3) ctitle("norm: 12m") nocons
  
	*** 5-10  year ahead
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w6_epi_12m_std ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm5_w w6_epi_5y_std  [aw=wgt0], robust 
  outreg2 w6_epi_5y_std  using "AppendixTable_4_4.txt", append dec(3) ctitle("norm: 5y") nocons
  
  
