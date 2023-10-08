clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

 

joinby sic2 using PPIdata.dta, unmatched(both)
tab sic2 _merge
drop _merge

joinby sic2 using  PPIdata_2014Q4, unmatched(master)
tab sic2 _merge
drop _merge


 gen anzsic_code3=floor(anzsic_code/10)

 cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
 do load_rreg2
  
 
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


  *** manager's education
  gen w3_manager_educ_some_coll=(w3_manager_educ==3)
  gen w3_manager_educ_coll=(w3_manager_educ==4)
  gen w3_manager_educ_ma=(w3_manager_educ==5)
  
  *** manager's income
  gen w3_manager_income_cont= 62.5*(w3_manager_income==3) + ///
							  87.5*(w3_manager_income==4) + ///
							  125*(w3_manager_income==5) + ///
							  175*(w3_manager_income==6) 
  
  replace w3_manager_income_cont=. if w3_manager_income_cont==0							  
  							  
 
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


***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 								entropy
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*** width of the interval over which entropy is calculated
gen w4_epi_12m_25plus_W  = 10
gen w4_epi_12m_15_25_W 	 = 10
gen w4_epi_12m_10_15_W   = 5
gen w4_epi_12m_8_10_W    = 2
gen w4_epi_12m_6_8_W     = 2
gen w4_epi_12m_4_6_W     = 2
gen w4_epi_12m_2_4_W     = 2
gen w4_epi_12m_0_2_W     = 2
gen w4_epi_12m_0_minus_W = 2

foreach var in 	w4_epi_12m_25plus w4_epi_12m_15_25 w4_epi_12m_10_15 ///
				w4_epi_12m_8_10 w4_epi_12m_6_8 w4_epi_12m_4_6 ///
				w4_epi_12m_2_4 w4_epi_12m_0_2 w4_epi_12m_0_minus ///
				{
				
				capture drop xtemp_`var'
				gen xtemp_`var'=`var'/100*log(`var'/100/`var'_W)
				replace xtemp_`var'=0 if xtemp_`var'==. & `var'==0
				
				}
				
capture drop w4_epi_12m_entropy_adj
egen w4_epi_12m_entropy_adj=rsum(xtemp_*)
replace w4_epi_12m_entropy_adj=. if w4_epi_12m==.
capture drop xtemp_*

*** NOTE THAT WE TAKE ABS OF ENTROPY
replace w4_epi_12m_entropy_adj=abs(w4_epi_12m_entropy_adj)

	
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
	
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 								entropy
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*** width of the interval over which entropy is calculated
gen w4_egdp_12m_5plus_W  	= 2
gen w4_egdp_12m_4_5_W 	 	= 1
gen w4_egdp_12m_3_4_W   	= 1
gen w4_egdp_12m_2_3_W   	= 1
gen w4_egdp_12m_1_2_W     	= 1
gen w4_egdp_12m_0_1_W     	= 1
gen w4_egdp_12m_0_minus_W   = 1


foreach var in 	w4_egdp_12m_5plus w4_egdp_12m_4_5 w4_egdp_12m_3_4 ///
				w4_egdp_12m_2_3 w4_egdp_12m_1_2 w4_egdp_12m_0_1 ///
				w4_egdp_12m_0_minus ///
				{
				
				capture drop xtemp_`var'
				gen xtemp_`var'=`var'/100*log(`var'/100/`var'_W)
				replace xtemp_`var'=0 if xtemp_`var'==. & `var'==0
				
				}
				
capture drop w4_egdp_12m_entropy_adj
egen w4_egdp_12m_entropy_adj=rsum(xtemp_*)
replace w4_egdp_12m_entropy_adj=. if w4_egdp_12m==.
capture drop xtemp_*

*** NOTE THAT WE TAKE ABS OF ENTROPY
replace w4_egdp_12m_entropy_adj=abs(w4_egdp_12m_entropy_adj)

	
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
	
	
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 								entropy
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*** width of the interval over which entropy is calculated
gen w4_eue_12m_8plus_W  	= 2
gen w4_eue_12m_7_8_W 	 	= 1
gen w4_eue_12m_6_7_W   		= 1
gen w4_eue_12m_5_6_W   		= 1
gen w4_eue_12m_4_5_W     	= 1
gen w4_eue_12m_4_minus_W     = 1


foreach var in 	w4_eue_12m_8plus w4_eue_12m_7_8 w4_eue_12m_6_7 ///
				w4_eue_12m_5_6 w4_eue_12m_4_5 w4_eue_12m_4_minus ///
				{
				
				capture drop xtemp_`var'
				gen xtemp_`var'=`var'/100*log(`var'/100/`var'_W)
				replace xtemp_`var'=0 if xtemp_`var'==. & `var'==0
				
				}
				
capture drop w4_eue_12m_entropy_adj
egen w4_eue_12m_entropy_adj=rsum(xtemp_*)
replace w4_eue_12m_entropy_adj=. if w4_eue_12m==.
capture drop xtemp_*

*** NOTE THAT WE TAKE ABS OF ENTROPY
replace w4_eue_12m_entropy_adj=abs(w4_eue_12m_entropy_adj)
	

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
*				relative uncertainty and errors
*============================================================================

*** log ratio of forecast uncertainty
gen ln_pi_ue=log(w4_epi_12m_std/w4_eue_12m_std)
gen ln_pi_gdp=log(w4_epi_12m_std/w4_egdp_12m_std)
gen ln_ue_gdp=log(w4_eue_12m_std/w4_egdp_12m_std)

*** difference in forecast entropy
gen ED_pi_ue=w4_epi_12m_entropy_adj/w4_eue_12m_entropy_adj
gen ED_pi_gdp=w4_epi_12m_entropy_adj/w4_egdp_12m_entropy_adj
gen ED_ue_gdp=w4_eue_12m_entropy_adj/w4_egdp_12m_entropy_adj

*** size of backcast errors
gen BE_pi_ue = log(abs(w4_pi_12m_be)/abs(w4_ue_be))
gen BE_pi_gdp = log(abs(w4_pi_12m_be)/abs(w4_gdp_12_be))
gen BE_ue_gdp = log(abs(w4_ue_be)/abs(w4_gdp_12_be))

*** relative size for willingness to pay
gen PAY_pi_ue = log((w4_pay_pi)/(w4_pay_ue))
gen PAY_pi_gdp = log((w4_pay_pi)/(w4_pay_gdp))
gen PAY_ue_gdp = log((w4_pay_ue)/(w4_pay_gdp))	


*============================================================================
*						relative attention
*============================================================================

*** dummy
gen X1_pi_ue=w4_track_pi<w4_track_ue if w4_track_pi~=. & w4_track_ue~=.
gen X1_pi_gdp=w4_track_pi<w4_track_gdp if w4_track_pi~=. & w4_track_gdp~=.
gen X1_ue_gdp=w4_track_ue<w4_track_gdp if w4_track_ue~=. & w4_track_gdp~=.


*** continuous
gen X2_pi_ue=-(w4_track_pi-w4_track_ue)
gen X2_pi_gdp=-(w4_track_pi-w4_track_gdp)
gen X2_ue_gdp=-(w4_track_ue-w4_track_gdp)


egen agg2N=group(agg2)


*============================================================================
*				forecast uncertainty and backcast errros
*============================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

	*** dummy: log ratio of std
	reg ln_pi_ue PAY_pi_ue, robust
	
	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in ln_pi_ue PAY_pi_ue {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	reg ln_pi_ue PAY_pi_ue [aw=wgt0] , robust cluster(anzsic_code3)
	
outreg2 PAY_pi_ue  using "Table13_panelA.txt", replace dec(3) ctitle("ln_pi_ue") nocons

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
reg ln_pi_gdp PAY_pi_gdp, robust

	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in ln_pi_gdp PAY_pi_gdp {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	reg ln_pi_gdp PAY_pi_gdp [aw=wgt0] , robust cluster(anzsic_code3)
	
outreg2 PAY_pi_gdp  using "Table13_panelA.txt", append dec(3) ctitle("ln_pi_gdp") nocons

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg ln_ue_gdp PAY_ue_gdp, robust

	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in ln_ue_gdp PAY_ue_gdp {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
	reg ln_ue_gdp PAY_ue_gdp [aw=wgt0] , robust cluster(anzsic_code3)

outreg2 PAY_ue_gdp  using "Table13_panelA.txt", append dec(3) ctitle("ln_ue_gdp") nocons


*============================================================================
*				backcast errros
*============================================================================


reg BE_pi_ue PAY_pi_ue, robust

	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in  BE_pi_ue PAY_pi_ue {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
	reg  BE_pi_ue PAY_pi_ue [aw=wgt0] , robust cluster(anzsic_code3)

outreg2 PAY_pi_ue  using "Table13_panelB.txt", replace dec(3) ctitle("ln_pi_ue") nocons

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg BE_pi_gdp PAY_pi_gdp, robust

	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in BE_pi_gdp PAY_pi_gdp {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
	reg  BE_pi_gdp PAY_pi_gdp [aw=wgt0] , robust cluster(anzsic_code3)
	
outreg2 PAY_pi_gdp  using "Table13_panelB.txt", append dec(3) ctitle("BE_pi_gdp") nocons

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg BE_ue_gdp PAY_ue_gdp, robust

	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in BE_ue_gdp PAY_ue_gdp {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
	reg  BE_ue_gdp PAY_ue_gdp [aw=wgt0] , robust cluster(anzsic_code3)
	
outreg2 PAY_ue_gdp  using "Table13_panelB.txt", append dec(3) ctitle("BE_ue_gdp") nocons
