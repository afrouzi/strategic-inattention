
clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
do load_rreg2
 

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
	
				
				
gen w4_epi_12m_var = ///
					w4_epi_12m_25plus*(30-w4_epi_12m)^2 + ///
					w4_epi_12m_15_25*(20-w4_epi_12m)^2 + ///
					w4_epi_12m_10_15*(12.5-w4_epi_12m)^2 + ///
					w4_epi_12m_8_10*(9-w4_epi_12m)^2 + ///
					w4_epi_12m_6_8*(7-w4_epi_12m)^2 + ///
					w4_epi_12m_4_6*(5-w4_epi_12m)^2 + ///
					w4_epi_12m_2_4*(3-w4_epi_12m)^2 + ///
					w4_epi_12m_0_2*(1-w4_epi_12m)^2 + ///
					w4_epi_12m_0_minus*(-1-w4_epi_12m)^2

replace w4_epi_12m_var=w4_epi_12m_var/100					

gen w4_epi_12m_std=w4_epi_12m_var^0.5

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

gen w4_egdp_12m_var = ///
					w4_egdp_12m_5plus*(6-w4_egdp_12m)^2 + ///
					w4_egdp_12m_4_5*(4.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_3_4*(3.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_2_3*(2.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_1_2*(1.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_0_1*(0.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_0_minus*(-0.5-w4_egdp_12m)^2

replace	w4_egdp_12m_var=w4_egdp_12m_var/100
gen w4_egdp_12m_std=w4_egdp_12m_var^0.5				
					
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into UE 
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


gen w4_eue_12m_var = ///
					w4_eue_12m_8plus*(9 - w4_eue_12m)^2 + ///
					w4_eue_12m_7_8*(7.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_6_7*(6.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_5_6*(5.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_4_5*(4.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_4_minus*(3 - w4_eue_12m)^2
					
replace w4_eue_12m_var=w4_eue_12m_var/100
gen 	w4_eue_12m_std=w4_eue_12m_var^0.5
				


 *==============================================================================
 *				Revisions
 *==============================================================================
 
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
	
gen D_epi = w4_epi_12m_treated - w4_epi_12m
gen D_egdp = w4_egdp_12m_treated - w4_egdp_12m
gen D_eue = w4_eue_12m_treated - w4_eue_12m

 capture drop epi_treatment
 gen epi_treatment=.
 replace epi_treatment=1 if w4_epi_12m_treatment==2 /* professional forecasters */
 replace epi_treatment=1 if w4_epi_12m_treatment==3 /* professional forecasters + RBNZ target*/ 
 replace epi_treatment=1 if w4_epi_12m_treatment==4 /* RBNZ target */
 replace epi_treatment=1 if w4_epi_12m_treatment==5 /* past inflation */
 replace epi_treatment=1 if w4_epi_12m_treatment==6 /* forecasts of other firms in your industry */
 

 gen epi_signal=.
 replace epi_signal=2 if w4_epi_12m_treatment==2
 replace epi_signal=2 if w4_epi_12m_treatment==3
 replace epi_signal=2 if w4_epi_12m_treatment==4
 replace epi_signal=1 if w4_epi_12m_treatment==5
 replace epi_signal=4.904256 if w4_epi_12m_treatment==6
 
 
 gen D_epi_norm = (w4_epi_12m_treated - w4_epi_12m)/(epi_signal-w4_epi_12m)
 gen D_epi_norm_w=D_epi_norm if abs(D_epi_norm)<2
  
 sum w4_egdp_12m
 gen egdp_signal=r(mean)
 
 gen D_egdp_norm =  (w4_egdp_12m_treated - w4_egdp_12m)/(egdp_signal-w4_egdp_12m)
 gen D_egdp_norm_w = D_egdp_norm if abs(D_egdp_norm)<2
 
 
 sum w4_eue_12m
 gen eue_signal=r(mean) 
 
 gen D_eue_norm =  (w4_eue_12m_treated - w4_eue_12m)/(eue_signal-w4_eue_12m)
 gen D_eue_norm_w = D_eue_norm if abs(D_eue_norm)<2
 
 forvalues i=1(1)6 {
	gen d_`i'=w4_epi_12m_treatment==`i'
}
	
 *==============================================================================
 *			Panel A: dependent variables p_i
 *==============================================================================
 capture drop posterior0 
 gen posterior0 = w4_epi_12m_treated - w4_epi_12m
 capture drop prior0    
 gen prior0 = epi_signal-w4_epi_12m
 
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m d_1 d_2 d_3 d_4 d_5 d_6 ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  xi: reg w4_epi_12m_treated w4_epi_12m i.w4_epi_12m_treatment [aw=wgt0], robust
  outreg2 w4_epi_12m   using "Table06_panelA.txt", replace dec(3) ctitle("pool") nocons
  
	*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m ones  if w4_epi_12m_treatment==2, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg w4_epi_12m_treated w4_epi_12m [aw=wgt0] if w4_epi_12m_treatment==2, robust
  outreg2 w4_epi_12m   using "Table06_panelA.txt", append dec(3) ctitle("info source: SPF") nocons

    *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m ones  if w4_epi_12m_treatment==3, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
	reg w4_epi_12m_treated w4_epi_12m [aw=wgt0] if w4_epi_12m_treatment==3, robust
    outreg2 w4_epi_12m   using "Table06_panelA.txt", append dec(3) ctitle("info source: Central bank") nocons
    
    *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m ones  if w4_epi_12m_treatment==4, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
	reg w4_epi_12m_treated w4_epi_12m  [aw=wgt0] if w4_epi_12m_treatment==4, robust
	outreg2 w4_epi_12m   using "Table06_panelA.txt", append dec(3) ctitle("info source: Central bank + SPF") nocons
   
    *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m ones  if w4_epi_12m_treatment==5, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
    reg w4_epi_12m_treated w4_epi_12m [aw=wgt0] if w4_epi_12m_treatment==5, robust
    outreg2 w4_epi_12m   using "Table06_panelA.txt", append dec(3) ctitle("info source: past pi") nocons
  
    *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_epi_12m_treated w4_epi_12m ones  if w4_epi_12m_treatment==6, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
	reg w4_epi_12m_treated w4_epi_12m [aw=wgt0] if w4_epi_12m_treatment==6, robust	
    outreg2 w4_epi_12m   using "Table06_panelA.txt", append dec(3) ctitle("info source: past pi") nocons
  
  
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *				Unemployment rate
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
	
	rreg2 w4_eue_12m_treated w4_eue_12m ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
   reg w4_eue_12m_treated w4_eue_12m [aw=wgt0], robust 
   outreg2 w4_eue_12m  using "Table06_panelA.txt", append dec(3) ctitle("UE") nocons
  	
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *							GDP
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 w4_egdp_12m_treated w4_egdp_12m ones  if w4_egdp_12m_treated<10, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
    reg w4_egdp_12m_treated w4_egdp_12m [aw=wgt0] if w4_egdp_12m_treated<10, robust 
    outreg2 w4_egdp_12m  using "Table06_panelA.txt", append dec(3) ctitle("GDP") nocons
  	

	
 *==============================================================================
 *				Panel B: dependent variable scaled revisions
 *==============================================================================
 
  
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w4_epi_12m_std  d_1 d_2 d_3 d_4 d_5 d_6 ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std d_1 d_2 d_3 d_4 d_5 d_6 [aw=wgt0], robust 
  outreg2 w4_epi_12m_std  using "Table06_panelB.txt", replace dec(3) ctitle("winsor sample") nocons
  
  
  *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w4_epi_12m_std ones  if w4_epi_12m_treatment==2, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std [aw=wgt0] if w4_epi_12m_treatment==2, robust
  outreg2 w4_epi_12m_std   using "Table06_panelB.txt", append dec(3) ctitle("info source: SPF") nocons

  *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w4_epi_12m_std ones  if w4_epi_12m_treatment==3, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std [aw=wgt0] if w4_epi_12m_treatment==3, robust
  outreg2 w4_epi_12m_std   using "Table06_panelB.txt", append dec(3) ctitle("info source: Central bank") nocons
  
  *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w4_epi_12m_std ones  if w4_epi_12m_treatment==4, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std [aw=wgt0] if w4_epi_12m_treatment==4, robust
  outreg2 w4_epi_12m_std   using "Table06_panelB.txt", append dec(3) ctitle("info source: Central bank + SPF") nocons
   
  *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1

	rreg2 D_epi_norm_w w4_epi_12m_std ones  if w4_epi_12m_treatment==5, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std [aw=wgt0] if w4_epi_12m_treatment==5, robust
  outreg2 w4_epi_12m_std   using "Table06_panelB.txt", append dec(3) ctitle("info source: past pi") nocons
  
  *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_epi_norm_w w4_epi_12m_std ones  if w4_epi_12m_treatment==6, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
  reg D_epi_norm_w w4_epi_12m_std [aw=wgt0] if w4_epi_12m_treatment==6, robust
  outreg2 w4_epi_12m_std   using "Table06_panelB.txt", append dec(3) ctitle("info source: past pi") nocons
  
  
 *==============================================================================
 *							Unemployment
 *==============================================================================
  	capture drop rreg_*
	capture drop ones
	gen ones=1

	rreg2 D_eue_norm_w w4_eue_12m_std ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
   reg D_eue_norm_w w4_eue_12m_std [aw=wgt0], robust 
   outreg2 w4_eue_12m_std  using "Table06_panelB.txt", append dec(3) ctitle("UE") nocons
  	  
 *==============================================================================
 *							GDP
 *==============================================================================
  	capture drop rreg_*
	capture drop ones
	gen ones=1
 
	rreg2 D_egdp_norm_w w4_egdp_12m_std ones , gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=rreg_wgt
	
 	
   reg D_egdp_norm_w w4_egdp_12m_std [aw=wgt0], robust 
   outreg2 w4_egdp_12m_std  using "Table06_panelB.txt", append dec(3) ctitle("GDP") nocons
  	  
	
  
