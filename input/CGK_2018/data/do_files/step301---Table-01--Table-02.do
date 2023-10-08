
clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 
 *============================================================================
 * 							First wave:
 *============================================================================
 
 *** wave for 2013Q3
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w1_epi_12m_w=w1_epi_12m
 replace w1_epi_12m_w=15 if w1_epi_12m>15 & w1_epi_12m~=.
 replace w1_epi_12m_w=-2 if w1_epi_12m<-2 & w1_epi_12m~=.

 *** drop extreme
 gen w1_epi_12m_c=w1_epi_12m if w1_epi_12m<15 & w1_epi_12m>-2
 
 
 sum w1_epi_12m w1_epi_12m_w w1_epi_12m_c [aw=wgtE43]
 sum w1_epi_12m_c [aw=wgtE43], d

 
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					backcast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
 *** censored
 gen w1_pi_12m_w=w1_pi_12m
 replace w1_pi_12m_w=15 if w1_pi_12m>15 & w1_pi_12m~=.
 replace w1_pi_12m_w=-2 if w1_pi_12m<-2 & w1_pi_12m~=.

 *** drop extreme
 gen w1_pi_12m_c=w1_pi_12m if w1_pi_12m<15 & w1_pi_12m>-2
 
 
 sum w1_pi_12m w1_pi_12m_w w1_pi_12m_c [aw=wgtE43]
 sum w1_pi_12m_c [aw=wgtE43], d

 
 
 *============================================================================
 * 							Second wave
 *============================================================================
 
 *** wave for 2014Q1
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w2_epi_12m_w=w2_epi_12m
 replace w2_epi_12m_w=15 if w2_epi_12m>15 & w2_epi_12m~=.
 replace w2_epi_12m_w=-2 if w2_epi_12m<-2 & w2_epi_12m~=.

 *** drop extreme
 gen w2_epi_12m_c=w2_epi_12m if w2_epi_12m<15 & w2_epi_12m>-2
 
 
 sum w2_epi_12m w2_epi_12m_w w2_epi_12m_c [aw=w2_wgtE_43]
 sum w2_epi_12m_c [aw=w2_wgtE_43], d
 
 
gen w2_egdp_12m=w2_egdp_12m_m*6+w2_egdp_12m_4_5*4.5+w2_egdp_3_4*3.5+w2_egdp_2_3*2.5+w2_egdp_1_2*1.5+w2_egdp_0_1*0.5+w2_egdp_neg*(-0.5)
replace w2_egdp_12m=w2_egdp_12m/100
	
 sum w2_eue w2_egdp_12m   [aw=w2_wgtE_43]
 sum w2_eue  [aw=w2_wgtE_43], d
 sum w2_egdp_12m [aw=w2_wgtE_43], d
 
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					backcast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
 *** censored
 gen w2_pi_12m_w=w2_pi_12m
 replace w2_pi_12m_w=15 if w2_pi_12m>15 & w2_pi_12m~=.
 replace w2_pi_12m_w=-2 if w2_pi_12m<-2 & w2_pi_12m~=.

 *** drop extreme
 gen w2_pi_12m_c=w2_pi_12m if w2_pi_12m<15 & w2_pi_12m>-2
 
 
 sum w2_pi_12m w2_pi_12m_w w2_pi_12m_c [aw=w2_wgtE_43]
 sum w2_pi_12m_c [aw=w2_wgtE_43], d

 sum w2_ue [aw=w2_wgtE_43], d
 
  *============================================================================
 * 							Third wave
 *============================================================================
 
 *** wave for 2014Q3
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 gen w3_epi_12m=w3_epi_12
 *** censored
 gen w3_epi_12m_w=w3_epi_12m
 replace w3_epi_12m_w=15 if w3_epi_12m>15 & w3_epi_12m~=.
 replace w3_epi_12m_w=-2 if w3_epi_12m<-2 & w3_epi_12m~=.

 *** drop extreme
 gen w3_epi_12m_c=w3_epi_12m if w3_epi_12m<15 & w3_epi_12m>-2
 
 
 sum w3_epi_12m w3_epi_12m_w w3_epi_12m_c [aw=w3_wgtE_43]

 sum w3_epi_12m_c [aw=w3_wgtE_43], d
 
 
 
 *============================================================================
 * 							Fourth wave
 *============================================================================
 
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

*** wave for 2014Q4
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w4_epi_12m_w=w4_epi_12m
 replace w4_epi_12m_w=15 if w4_epi_12m>15 & w4_epi_12m~=.
 replace w4_epi_12m_w=-2 if w4_epi_12m<-2 & w4_epi_12m~=.

 *** drop extreme
 gen w4_epi_12m_c=w4_epi_12m if w4_epi_12m<15 & w4_epi_12m>-2
 
 
 sum w4_epi_12m w4_epi_12m_w w4_epi_12m_c [aw=w4_wgtE_43]

 sum  w4_epi_12m_c [aw=w4_wgtE_43], d
	
 sum w4_eue_12m w4_egdp_12m [aw=w4_wgtE_43], d
  

 
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					backcast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
 *** censored
 gen w4_pi_12m_w=w4_pi_12m
 replace w4_pi_12m_w=15 if w4_pi_12m>15 & w4_pi_12m~=.
 replace w4_pi_12m_w=-2 if w4_pi_12m<-2 & w4_pi_12m~=.

 *** drop extreme
 gen w4_pi_12m_c=w4_pi_12m if w4_pi_12m<15 & w4_pi_12m>-2
 
 
 sum w4_pi_12m w4_pi_12m_w w4_pi_12m_c [aw=w4_wgtE_43]
 sum w4_pi_12m_c [aw=w4_wgtE_43], d

 sum w4_ue w4_gdp_12m [aw=w4_wgtE_43], d
 
 
  
 
*============================================================================
* 							Sixth wave
*============================================================================
 
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


*==================================================================
*						Table 01
*==================================================================

 * wave for 2016Q2	
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w6_epi_12m_w=w6_epi_12m
 replace w6_epi_12m_w=15 if w6_epi_12m>15 & w6_epi_12m~=.
 replace w6_epi_12m_w=-2 if w6_epi_12m<-2 & w6_epi_12m~=.

 *** drop extreme
 gen w6_epi_12m_c=w6_epi_12m if w6_epi_12m<15 & w6_epi_12m>-2
 
 
 sum w6_epi_12m w6_epi_12m_w w6_epi_12m_c [aw=w6_wgtE_43]
 sum w6_epi_12m_c [aw=w6_wgtE_43], d

 
 sum w6_eue_12m_implied w6_egdp_12m_implied  [aw=w6_wgtE_43], d
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					backcast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w6_pi_12m_w=w6_pi_12m
 replace w6_pi_12m_w=15 if w6_pi_12m>15 & w6_pi_12m~=.
 replace w6_pi_12m_w=-2 if w6_pi_12m<-2 & w6_pi_12m~=.

 *** drop extreme
 gen w6_pi_12m_c=w6_pi_12m if w6_pi_12m<15 & w6_pi_12m>-2
 
 sum w6_pi_12m w6_pi_12m_w w6_pi_12m_c [aw=w6_wgtE_43]
 sum w6_pi_12m_c [aw=w6_wgtE_43], d

*============================================================================
* 							Seventh wave
*============================================================================

 *** wave for 2016Q4
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					forecast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 *** censored
 gen w7_epi_12m_w=w7_epi_12m
 replace w7_epi_12m_w=15 if w7_epi_12m>15 & w7_epi_12m~=.
 replace w7_epi_12m_w=-2 if w7_epi_12m<-2 & w7_epi_12m~=.

 *** drop extreme
 gen w7_epi_12m_c=w7_epi_12m if w7_epi_12m<15 & w7_epi_12m>-2
 
 
 sum w7_epi_12m w7_epi_12m_w w7_epi_12m_c [aw=w7_wgtE_43]
 sum w7_epi_12m_c [aw=w7_wgtE_43], d

 
 sum w7_eue_12m_implied w7_egdp_12m_implied  [aw=w7_wgtE_43], d
 sum w7_eue_12m w7_egdp_12m [aw=w7_wgtE_43], d
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *					backcast
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
*** we have no backcasts in this wave

