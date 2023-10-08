* step 06 - properties of inattention

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
 capture do load_rreg2
 
 *============================================================================
 * 				calculate nowcast and backcast errors
 *============================================================================
 
 
 * inflation rate forecast error
 gen w1_pi_12m_be     = 1.6 - w1_pi_12m
 gen w1_pi_12m_be_abs=abs(w1_pi_12m_be)
 
  
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
  	
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
 
 *============================================================================
 * 				regressions: include only firm charactreistics
 *============================================================================
 **** industry fixed effects
 
 capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 egen agg1s=group(agg1)
 gen agg1s_1=agg1s==1
 gen agg1s_2=agg1s==2
 gen agg1s_3=agg1s==3
 gen agg1s_4=agg1s==4
 
 foreach var in w1_pi_12m_be_abs ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w1_pi_12m_be_abs ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv i.agg1 ///
	 [aw=wgt0] , robust cluster(anzsic_code3)
	 
 outreg2 ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	using Table04.txt , replace dec(3)
 
 

 *============================================================================
 * 				regressions: include only manager characteristics
 *============================================================================
 **** industry fixed effects
    capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w1_pi_12m_be_abs w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w1_pi_12m_be_abs ///
		w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	i.agg1 ///
	 [aw=wgt0] , robust cluster(anzsic_code3)
	
 outreg2 	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont /// ///
	using Table04.txt , dec(3) append
	
	
 *============================================================================
 * 				regressions: include only firm charactreistics
 *============================================================================

 **** industry fixed effects
      capture drop rreg_*
 capture drop ones
 gen ones=sqrt(wgtE43)
 
 foreach var in w1_pi_12m_be_abs ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv  ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	agg1s_1 agg1s_2 agg1s_3 agg1s_4 {
	
		gen rreg_`var'=`var'*sqrt(wgtE43)
	}
	
	rreg2 rreg_* ones, gen(rreg_wgt) 
	capture drop wgt0
	gen wgt0=wgtE43*rreg_wgt
	
 xi: reg w1_pi_12m_be_abs ///
	ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont i.agg1s ///
	 [aw=wgt0] , robust cluster(anzsic_code3)
	 
 outreg2 ln_age ln_L w1_labor_cost_share ///
	w1_trade_share w1_competitors  w1_margin_average ///
	w1_price_difference dp_a ///
	dppia_13q4 ///
	w1_edp_size_main w1_edp_time_main prof_curv ///
	w3_manager_age  ///
	w3_manager_educ_some_coll w3_manager_educ_coll w3_manager_educ_ma ///
	w3_manager_tenure_firm   ///
	w3_manager_income_cont ///
	using Table04.txt , dec(3)	 append

