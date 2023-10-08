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

*==============================================================================

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
 
  * industry level inflation rate PPI
 gen w4_pii_12m_be =   actual_pi_yoy_2014q4 - w4_pii_12m
 
 *==============================================================================
 
 egen t1=fill(-24(1)24)
 
 gen agg1N=1 if agg1=="Manufacturing"
 replace agg1N=2  if agg1=="Trade"
 replace agg1N=3  if agg1=="Professional and Financial Services"
 replace agg1N=4  if agg1=="Construction and Transportation"
 
 
 *==============================================================================
 *							Panel B
 *==============================================================================
 *** wave #1
  twoway (kdensity w1_pi_12m_be [aw=wgtE43] if agg1N==1 & w1_pi_12m_be>-20, w(2.5) kernel(triangle) lpatter(solid) lcolor(black) lwidth(vthick)) ///
		(kdensity w1_pi_12m_be [aw=wgtE43] if agg1N==2 & w1_pi_12m_be>-20, w(2.5) kernel(triangle) lpatter(solid) lcolor(red)) ///
		(kdensity w1_pi_12m_be [aw=wgtE43] if agg1N==3 & w1_pi_12m_be>-20, w(2.5) kernel(triangle) lpatter(longdash) lcolor(blue) lwidth(thick)) ///
		(kdensity w1_pi_12m_be [aw=wgtE43] if agg1N==4 & w1_pi_12m_be>-20, w(2.5) kernel(triangle)  lpatter(longdash) lcolor(green)) ///
		, ///
		xlabel(-20(5)5) ///
		xtitle("backcast error") ///
		ytitle("density") ///
		legend(	label(1 "Manufacturing") ///
				label(2 "Trade") ///
				label(3 "Prof. & Fin. Services") ///
				label(4 "Construction & Transport") ///
				rows(4) ///
				ring(0) position(11)) ///
		name(PanelB, replace)	 ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_04_PanelB.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_04_PanelB.pdf", replace 
	
		
 
 *==============================================================================
 *							Panel A
 *==============================================================================		

quiet foreach var in w4_pi_12m_be w4_pii_12m_be {
	sum `var',d
	gen `var'_w=`var' if `var'>=r(p1) & `var'<=r(p99) & `var'~=.
}	
	
		 twoway (kdensity w4_pii_12m_be_w  [aw=wgtE43], bw(1) lcolor(red) lwidth(vthick)) ///
		(kdensity w4_pi_12m_be_w  [aw=wgtE43], bw(1) lcolor(blue)  lpattern(shortdash)) ///
		(kdensity w4_gdp_12_be  [aw=wgtE43], bw(1) lcolor(green) ) ///
		(kdensity w4_ue_be  [aw=wgtE43], bw(1) lcolor(black)  lpattern(longdash)) ///
		, ///
		xlabel(-12(2)4) ///
		xtitle("backcast error") ytitle("density") ///
		legend(label(1 "industry specific inflation rate") ///
			   label(2 "aggregate inflation") ///
			   label(3 "GDP growth rate") ///
			   label(4 "Unemployment rate") ///
			   rows(4) ///
			   ring(0) position(11)) ///
		name(PanelA, replace)	 ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_04_PanelA.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_04_PanelA.pdf", replace 
	
			   
