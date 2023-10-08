
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
  
 *============================================================================
 * 								Panel A  
 *============================================================================
 
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
   capture drop RR
  gen RR=abs(w4_price_complementarity)/10
   capture drop w4_info_Q23
  gen w4_info_Q23=w4_info_complementarity==1 if w4_info_complementarity~=.
  
tab w4_info_complementarity

reg w4_info_Q23 RR [aw=w4_wgtE_43], robust cluster(anzsic_code3)
 outreg2 RR ///
	using Table10_info_complementarity.xls , dec(3)	 replace
	
xi: reg w4_info_Q23 RR i.agg2 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
 outreg2 RR ///
	using Table10_info_complementarity.xls , dec(3)	 append ctitle("industry FE fine")
	
xi: reg w4_info_Q23 RR ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont  ///
	i.agg2 ///
	[aw=w4_wgtE_43], robust cluster(anzsic_code3)
	
outreg2 RR ///
	using Table10_info_complementarity.xls , dec(3)	 append ctitle("firm + manager controls + industry FE fine")
	

	
 *============================================================================
 * 								Panel B
 *============================================================================ 
  capture drop w4_info_Q25
  gen w4_info_Q25=(w4_info_uncertainty==3)
  capture drop RR
  gen RR=abs(w4_price_complementarity)/100
 
  capture drop w4_info_Q25
  gen w4_info_Q25=(w4_info_uncertainty==3)
  capture drop RR
  gen RR=abs(w4_price_complementarity)/100
 
 *** robust regression
 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(w4_wgtE_43)
 
	foreach var in w4_info_Q25 RR {
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	reg rreg_* ones, nocons
	capture drop bb
	predict bb, dfbeta(rreg_RR)
	
 reg w4_info_Q25 RR  if abs(bb)<.2 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
  outreg2 RR ///
	using Table10_info_complementarity_column2.xls , dec(3)	 replace ctitle("no controls: no outliers")

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	
 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(w4_wgtE_43)
 
 foreach var in w4_info_Q25 RR {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
capture drop agg2N	
egen agg2N=group(agg2)
sum agg2N
local rmax=r(max)
capture drop dagg2_*
forvalues i=1(1)`rmax' {
	gen dagg2_`i'=(agg2N==`i')
	gen rreg_dagg2_`i'=dagg2_`i'*sqrt(w4_wgtE_43)
}

	
	
	reg rreg_* ones, nocons
	capture drop bb
	predict bb, dfbeta(rreg_RR)
	
xi: reg w4_info_Q25 RR i.agg2 if abs(bb)<.2 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
 outreg2 RR ///
	using Table10_info_complementarity_column2.xls , dec(3)	 append ctitle("industry FE fine: no outliers")
	
	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(w4_wgtE_43)
 
 foreach var in w4_info_Q25 RR ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont {
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
capture drop agg2N	
egen agg2N=group(agg2)
sum agg2N
local rmax=r(max)
capture drop dagg2_*
forvalues i=1(1)`rmax' {
	gen dagg2_`i'=(agg2N==`i')
	gen rreg_dagg2_`i'=dagg2_`i'*sqrt(w4_wgtE_43)
}

	
	
	reg rreg_* ones, nocons
	capture drop bb
	predict bb, dfbeta(rreg_RR)

xi: reg w4_info_Q25 RR ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont  ///
	i.agg2 ///
	 if abs(bb)<.2 ///
	[aw=w4_wgtE_43], robust cluster(anzsic_code3)
	
outreg2 RR ///
	using Table10_info_complementarity_column2.xls , dec(3)	///
	ctitle("firm + manager controls + industry FE fine: no outliers") ///
	append 
		
	
 *============================================================================
 * 								Panel C
 *============================================================================ 
  capture drop w4_info_Q25
  gen w4_info_Q25=(w4_info_uncertainty==3)
  capture drop w4_info_Q24
  gen w4_info_Q24=(w4_info_complementarity2)/10
 
 reg w4_info_Q24 w4_info_Q25 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
  outreg2 w4_info_Q25 ///
	using Table10_info_complementarity_column3.xls , dec(3)	 replace
	
xi: reg w4_info_Q24 w4_info_Q25 i.agg2 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
 outreg2 w4_info_Q25 ///
	using Table10_info_complementarity_column3.xls , dec(3)	 append ctitle("industry FE fine")
	

xi: reg w4_info_Q24 w4_info_Q25 ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont  ///
	i.agg2 [aw=w4_wgtE_43], robust cluster(anzsic_code3)
	
outreg2 w4_info_Q25 ///
	using Table10_info_complementarity_column3.xls , dec(3)	 append ctitle("firm + manager controls + industry FE fine")
	
		
	
