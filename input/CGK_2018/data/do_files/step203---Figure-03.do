clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 
joinby sic2 using PPIdata.dta, unmatched(both)
tab sic2 _merge
drop _merge
 
 egen t1=fill(-24(1)24)
 
 gen agg1N=1 if agg1=="Manufacturing"
 replace agg1N=2  if agg1=="Trade"
 replace agg1N=3  if agg1=="Professional and Financial Services"
 replace agg1N=4  if agg1=="Construction and Transportation"
 

*==============================================================================

 * inflation rate forecast error
 gen w1_pi_12m_be     = 1.6 - w1_pi_12m
 gen w1_pi_12m_be_abs=abs(w1_pi_12m_be)
 
 * inflation (followup survey)
 gen w2_pi_12m_be = 1.5 - w2_pi_12m
 gen w2_pi_12m_be_abs=abs(w2_pi_12m_be)

 * inflation (wave 4)
 gen w4_pi_12m_be = 0.8 - w4_pi_12
 gen w4_pi_12m_be_abs=abs(w4_pi_12m_be)
 
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
					

 *==============================================================================
 *				One year ahead inflation
 *==============================================================================
  *** Panel A: wave #1 
  twoway (kdensity w2_epi_12m [aw=wgtE43] if w1_pi_12m_be_abs<=2 & w2_epi_12m<=25, w(3.5) kernel(triangle) lpatter(solid) lcolor(black) lwidth(vthick)) ///
		(kdensity w2_epi_12m [aw=wgtE43]  if  w1_pi_12m_be_abs>=2 & w1_pi_12m_be_abs~=.& w2_epi_12m<=25, w(3.5) kernel(triangle) lpatter(solid) lcolor(red)) ///
		, ///
		xlabel(0(5)25) ///
		xtitle("forecast") ///
		ytitle("density") ///
		legend(	label(1 "Informed") ///
				label(2 "Uninformed") ///
				rows(2) ///
				ring(0) position(1)) ///
		name(fig1, replace)	 ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_03_PanelA.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_03_PanelA.pdf", replace 
	
		
  *** Panel B: wave #1 -> #4	
  twoway (kdensity w4_epi_12m  [aw=wgtE43]  if w1_pi_12m_be_abs<=2, w(2) kernel(triangle) lpatter(solid) lcolor(black) lwidth(vthick)) ///
		(kdensity w4_epi_12m  [aw=wgtE43]  if  w1_pi_12m_be_abs>=2 & w1_pi_12m_be_abs~=., w(2) kernel(triangle) lpatter(solid) lcolor(red)) ///
		, ///
		xlabel(0(5)20) ///
		xtitle("forecast") ///
		ytitle("density") ///
		legend(	label(1 "Informed") ///
				label(2 "Uninformed") ///
				rows(2) ///
				ring(0) position(1)) ///
		name(fig2, replace)	 ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_03_PanelB.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_03_PanelB.pdf", replace 
	

		

 
 
