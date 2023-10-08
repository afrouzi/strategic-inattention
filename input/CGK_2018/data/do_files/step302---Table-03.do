
clear all
set more off
set matsize 11000
set maxvar 11000

clear all
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 
gen anzsic_code3=floor(anzsic_code/10)
gen w6_anzsic_code3=floor(w6_anzsiccode/10)

 
joinby sic2 using PPIdata.dta, unmatched(both)
tab sic2 _merge
drop _merge


cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
do load_rreg2

 *============================================================================
 * 				calculate nowcast and backcast errors
 *============================================================================
 
 
 * output gap (original survey)
 gen w1_output_gap_be = 0 - w1_output_gap
 
 * output gap (followup survey)
 gen w2_output_gap_be = 0.5 - w2_output_gap

 
 * inflation rate forecast error
 gen w1_pi_12m_be     = 1.6 - w1_pi_12m
 
 * inflation (followup survey)
 gen w2_pi_12m_be = 1.5 - w2_pi_12m

 * inflation (wave 4)
  gen w4_pi_12m_be = 0.8 - w4_pi_12

 * gdp growth rate (the growth rate of GDP is for 2014Q3; UPDATE WHEN MORE DATA COME IN)
 gen w4_gdp_12_be= 2.5 - w4_gdp_12
 
 * unemployment (followup survey)
 gen w2_ue_be = 6 - w2_ue

* unemployment (wave 4)
 gen w4_ue_be = 5.7 - w4_ue
 
 * interest rate (followup survey)
 gen w2_interest_rate_be = 3.3 - w2_interest_rate

 * exchange rate
 gen w4_exrate_be = 0.7764 - w4_exrate

 *============================================================================
 * 							create variables
 *============================================================================
  
  gen ln_age=log(w1_age)
 gen ln_L=log(w1_employment)
 
 * size of the price chnage over the last year
 gen dp_a = log(w1_price/w1_price_12m)
 replace dp_a=0.5 if dp_a>0.5 & dp_a~=.
 replace dp_a=-0.5 if dp_a<-0.5 & dp_a~=.
 
 *** calculate the curvature of the profit function
gen prof_curv=abs(w1_dy_dp_now)/abs(w1_dp_now)
replace prof_curv=0 if w1_dp_now==0

 *** PPI inflation rate
gen dppia_13q4 = ( (dppi_13q4/100+1)*(dppi_13q3/100+1)*(dppi_13q2/100+1)*(dppi_13q1/100+1) -1)*100
gen dppia_13q3 = ( (dppi_13q3/100+1)*(dppi_13q2/100+1)*(dppi_13q1/100+1)*(dppi_12q4/100+1) -1)*100


* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into inflation 
egen _rm=rownonmiss(w4_epi_12m_*)

foreach var in 	w4_epi_12m_25plus w4_epi_12m_15_25 w4_epi_12m_10_15 ///
				w4_epi_12m_8_10 w4_epi_12m_6_8 w4_epi_12m_4_6 ///
				w4_epi_12m_2_4 w4_epi_12m_0_2 w4_epi_12m_0_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_epi_12m = 	w4_epi_12m_25plus*30 + w4_epi_12m_15_25*20 + ///
					w4_epi_12m_10_15*12.5 + w4_epi_12m_8_10*9 + ///
					w4_epi_12m_6_8*7 + w4_epi_12m_4_6*5 + ///
					w4_epi_12m_2_4*3 + w4_epi_12m_0_2*1 + ///
					w4_epi_12m_0_minus*(-1)

replace w4_epi_12m=w4_epi_12m/100
					
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into gdp 
egen _rm=rownonmiss(w4_egdp_12m_*)

foreach var in 	w4_egdp_12m_5plus w4_egdp_12m_4_5 w4_egdp_12m_3_4 ///
				w4_egdp_12m_2_3 w4_egdp_12m_1_2 w4_egdp_12m_0_1 ///
				w4_egdp_12m_0_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_egdp_12m = 	w4_egdp_12m_5plus*6 + w4_egdp_12m_4_5*4.5 + ///
					w4_egdp_12m_3_4*3.5 + w4_egdp_12m_2_3*2.5 + ///
					w4_egdp_12m_1_2*1.5 + w4_egdp_12m_0_1*0.5 + ///
					w4_egdp_12m_0_minus*(-0.5)

replace w4_egdp_12m=w4_egdp_12m/100

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into gdp 
egen _rm=rownonmiss(w4_eue_12m_*)

foreach var in 	w4_eue_12m_8plus w4_eue_12m_7_8 w4_eue_12m_6_7 ///
				w4_eue_12m_5_6 w4_eue_12m_4_5 w4_eue_12m_4_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_eue_12m = 	w4_eue_12m_8plus*9 + w4_eue_12m_7_8*7.5 + ///
					w4_eue_12m_6_7*6.5 + w4_eue_12m_5_6*5.5 + ///
					w4_eue_12m_4_5*4.5 + w4_eue_12m_4_minus*3 

replace w4_eue_12m=w4_eue_12m/100


*=======================================================================
*** 			dummy variables for industries
*=======================================================================

egen agg2s=group(agg2)
forvalues i=1(1)19 {
	gen agg2s_`i'=(agg2s==`i')
	gen agg2sw_`i'=(agg2s==`i')*sqrt(wgtE43)
}
	
gen ones=sqrt(wgtE43)	

capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

*=======================================================================
**** 			inflation: industry 12 months
*=======================================================================
capture drop wY
capture drop wX
gen wY=w4_epii_12m*sqrt(wgtE43)
gen wX=w4_pii_12m*sqrt(wgtE43)
capture drop rreg_wgt
rreg2 wY wX agg2sw_* ones,  gen(rreg_wgt) 
capture drop wgt0
gen wgt0=wgtE43*rreg_wgt


xi: reg w4_epii_12m w4_pii_12m agg2s_* [aw=wgt0], robust cluster(anzsic_code3)
outreg2  w4_pii_12m using "Table03.txt", replace dec(3) ctitle("epii 12: wave 4") nocons

*=======================================================================
**** 				GDP growth rate
*=======================================================================
capture drop wY
capture drop wX
gen wY=w4_egdp_12m*sqrt(wgtE43)
gen wX=w4_gdp_12m*sqrt(wgtE43)
capture drop rreg_wgt
rreg2 wY wX agg2sw_* ones,  gen(rreg_wgt) 
capture drop wgt0
gen wgt0=wgtE43*rreg_wgt

xi: reg w4_egdp_12m w4_gdp_12m i.agg2 [aw=wgt0], robust cluster(anzsic_code3)
outreg2  w4_gdp_12m using "Table03.txt", append dec(3) ctitle("egdp 12: wave 4") nocons

*=======================================================================
**** 				Exchange rate
*=======================================================================
capture drop wY
capture drop wX
gen wY=w4_eexrate_12m*sqrt(wgtE43)
gen wX=w4_exrate*sqrt(wgtE43)
reg wY wX agg2sw_*
capture drop rreg_wgt
rreg2 wY wX agg2sw_* ones,  gen(rreg_wgt) 
capture drop wgt0
gen wgt0=wgtE43*rreg_wgt

xi: reg w4_eexrate_12m w4_exrate i.agg2 [aw=wgt0]   , robust cluster(anzsic_code3)
outreg2  w4_exrate using "Table03.txt", append dec(3) ctitle("eexrate 12: wave 4") nocons

*=======================================================================
*							PANEL
*=======================================================================

keep anzsic_code3 firmid agg2 ///
	w1_epi_12m w1_pi_12m ///
	w2_epi_12m w2_pi_12m ///
	w4_epi_12m w4_pi_12m ///
	w6_epi_12m w6_pi_12m ///
	w2_eue_12m w2_ue ///
	w4_eue_12m w4_ue ///
	wgtE43 w2_wgtE_43 w4_wgtE_43 w6_wgtE_43 agg2s_* agg2sw_*

rename 	w1_epi_12m Y_1
rename 	w2_epi_12m Y_2
rename 	w4_epi_12m Y_4
rename 	w6_epi_12m Y_6

rename 	w1_pi_12m X_1
rename 	w2_pi_12m X_2
rename 	w4_pi_12m X_4
rename 	w6_pi_12m X_6

rename 	w2_eue_12m Z_1
rename 	w4_eue_12m Z_2

rename 	w2_ue W_1
rename 	w4_ue W_2 

drop if firmid==.

reshape long X_ Y_ Z_ W_ , i(firmid)

rename _j wave

replace wgtE43=w6_wgtE_43 if wgtE43==. & w6_wgtE_43~=.
replace wgtE43=w4_wgtE_43 if w4_wgtE_43~=. & wave==4
replace wgtE43=w2_wgtE_43 if w2_wgtE_43~=. & wave==4

gen ones=sqrt(wgtE43)
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
***					inflation
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen wY_=Y_*sqrt(wgtE43)
gen wX_=X_*sqrt(wgtE43)
gen w_=sqrt(wgtE43)

capture drop rreg_wgt
rreg2 wY_ wX_ agg2sw_* ones,  gen(rreg_wgt) 
capture drop wgt0
gen wgt0=wgtE43*rreg_wgt


reg Y_ X_  agg2sw_* [aw=wgt0], robust cluster(anzsic_code3)
outreg2  X_ using "Table03.txt", append dec(3) ctitle("pi 12: pooled") nocons

reghdfe Y_ X_ [aw=wgt0], absorb(firmid)  cluster(anzsic_code3)
outreg2  X_ using "Table03.txt", append dec(3) ctitle("pi 12: FE") nocons


***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
***					unemployment
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gen wZ_=Z_*sqrt(wgtE43)
gen wW_=W_*sqrt(wgtE43)

capture drop rreg_wgt
rreg2 wZ_ wW_ agg2sw_* ones,  gen(rreg_wgt) 
capture drop wgt0
gen wgt0=wgtE43*rreg_wgt

reg Z_ W_  agg2sw_* [aw=wgt0], robust cluster(anzsic_code3)
outreg2  W_  using "Table03.txt", append dec(3) ctitle("ue 12: pooled") nocons

reghdfe Z_ W_ [aw=wgt0], absorb(firmid) cluster(anzsic_code3)
outreg2  W_  using "Table03.txt", append dec(3) ctitle("ue 12: FE") nocons
