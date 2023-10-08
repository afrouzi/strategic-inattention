
clear all
set more off
* step 06 - properties of inattention

clear all
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 

 gen anzsic_code3=floor(anzsic_code/10)

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
 
 *==========================================================================
 * baseline measures of inattention as absolute values
 foreach var in  w1_output_gap_be w2_output_gap_be  w1_pi_12m_be  w2_pi_12m_be ///
  w4_pi_12m_be w4_gdp_12_be w2_ue_be w4_ue_be w2_interest_rate_be w4_exrate_be ///
  {
  gen `var'_abs=abs(`var')
 } 

*** create dummy variables for each industry 
egen agg2n=group(agg2)
sum agg2n
local r1=r(max)
forvalues i=1(1)`r1' {
	gen dagg2_`i'=(agg2n==`i')
}

quiet compress
	
*===================================================================
*		check persistence of backcast errors
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 					12-month inflation
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w2_pi_12m_be_abs w1_pi_12m_be_abs {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
   
 xi: reg w2_pi_12m_be_abs w1_pi_12m_be_abs [aw=wgt0] , robust cluster(anzsic_code3)
 outreg2 w1_pi_12m_be_abs using "Table05.txt", replace dec(3) ctitle("wgt") nocons

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 						Output gap
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w2_output_gap_be_abs w1_output_gap_be_abs {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w2_output_gap_be_abs w1_output_gap_be_abs [aw=wgt0] , robust cluster(anzsic_code3)
 outreg2 w1_output_gap_be_abs using "Table05.txt", append dec(3) ctitle("wgt") nocons

 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 					12-month inflation: one year later
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w4_pi_12m_be_abs w1_pi_12m_be_abs {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w4_pi_12m_be_abs w1_pi_12m_be_abs [aw=wgt0] , robust cluster(anzsic_code3)
 outreg2 w1_pi_12m_be_abs using "Table05.txt", append dec(3) ctitle("wgt") nocons


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 					Unemployment rate
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w4_ue_be_abs w2_ue_be_abs {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w4_ue_be_abs w2_ue_be_abs [aw=wgt0] , robust cluster(anzsic_code3)
 outreg2 w2_ue_be_abs using "Table05.txt", append dec(3) ctitle("wgt") nocons

	 
	   
	   
	   
	   
