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

 cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
 do load_rreg2
  
 gen anzsic_code3=floor(anzsic_code/10)
  
 *============================================================================
 * 				calculate nowcast and backcast errors
 *============================================================================
 
 
 * inflation rate forecast error
 gen w1_pi_12m_be     = 1.6 - w1_pi_12m
 gen w1_pi_12m_be_abs=abs(w1_pi_12m_be)
 
 * inflation (followup survey)
 gen w2_pi_12m_be = 1.5 - w2_pi_12m
 gen w2_pi_12m_be_abs =  abs(w2_pi_12m_be)
 
 * inflation (wave 4)
  gen w4_pi_12m_be = 0.8 - w4_pi_12
  gen w4_pi_12m_be_abs=abs(w4_pi_12m_be)
  
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
  							  
 egen agg1s=group(agg1)
 gen agg1s_1=agg1s==1
 gen agg1s_2=agg1s==2
 gen agg1s_3=agg1s==3
 gen agg1s_4=agg1s==4
 
 *============================================================================
 * 			INFLATION: TRACK
 *============================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

 
  xi: reg w4_track_pif ///
		ln_age ln_L w1_labor_cost_share ///
		w1_trade_share w1_competitors  w1_margin_average ///
		w4_turnover_lt ///
		w3_manager_age  ///
		w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
		w3_manager_tenure_firm   ///
		w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///
	, robust
	
	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in w4_track_pif ///
		ln_age ln_L w1_labor_cost_share ///
		w1_trade_share w1_competitors  w1_margin_average ///
		w4_turnover_lt ///
		w3_manager_age  ///
		w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
		w3_manager_tenure_firm   ///
		w3_manager_income_cont ///
		agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///			
	{
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) iterate(10)
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
  xi: reg w4_track_pif ///
		ln_age ln_L w1_labor_cost_share ///
		w1_trade_share w1_competitors  w1_margin_average ///
		w4_turnover_lt ///
		w3_manager_age  ///
		w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
		w3_manager_tenure_firm   ///
		w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///
	[aw=wgt0]  , robust cluster(anzsic_code3)
	
	
 outreg2 using AppendixTable_4_2 , dec(3) replace ctitle("inflation")
	
 

 *============================================================================
 * 			INFLATION: IMPORTANCE
 *============================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"

 
  xi: reg w4_track_pi ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w4_turnover_lt ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///	
	, robust
	
	capture drop rreg_*
	capture drop ones
	gen ones=sqrt(w4_wgtE_43)
 
	foreach var in w4_track_pi ///
		ln_age ln_L w1_labor_cost_share ///
		w1_trade_share w1_competitors  w1_margin_average ///
		w4_turnover_lt ///
		w3_manager_age  ///
		w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
		w3_manager_tenure_firm   ///
		w3_manager_income_cont ///
		agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///	
	{
	
		gen rreg_`var'=`var'*sqrt(w4_wgtE_43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt)  iterate(10)
	capture drop wgt0
	gen wgt0=w4_wgtE_43*rreg_wgt
	
  xi: reg w4_track_pi ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w4_turnover_lt ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 ///	
	[aw=wgt0]  , robust cluster(anzsic_code3)
	
 outreg2 using AppendixTable_4_2 , dec(3) append ctitle("inflation")
	
 
