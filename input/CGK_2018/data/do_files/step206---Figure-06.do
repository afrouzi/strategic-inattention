clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

 
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

			
  	  
*==============================================================================
*					plot posterior vs. prior
*==============================================================================

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*							inflation
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reg w4_epi_12m_treated w4_epi_12m i.w4_epi_12m_treatment, robust
local X1_pi=string(_b[w4_epi_12m],"%3.2f")
local X2_pi=string(_se[w4_epi_12m],"%3.2f")

 twoway (scatter w4_epi_12m_treated w4_epi_12m if w4_epi_12m_treatment<=6, mfcolor(none)) ///
		(line w4_epi_12m w4_epi_12m, lcolor(red)) ///
		(lfit w4_epi_12m_treated w4_epi_12m if w4_epi_12m_treatment<=6, lpattern(dash) lwidth(thick) lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Prior") ///
		ytitle("Posterior") ///
		title("Inflation") ///
		name(panelA, replace) ///
		  graphregion(color(white)) bgcolor(white)  
		
 

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*							unemployment rate
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
reg w4_eue_12m_treated w4_eue_12m, robust
local X1_ue=string(_b[w4_eue_12m],"%3.2f")
local X2_ue=string(_se[w4_eue_12m],"%3.2f")
 
 twoway (scatter w4_eue_12m_treated w4_eue_12m, mfcolor(none)) ///
		(line w4_eue_12m w4_eue_12m, lcolor(red)) ///
		(lfit w4_eue_12m_treated w4_eue_12m, lpattern(dash) lwidth(thick) lcolor(blue)) ///	
		, ///
		legend(off) ///
		xtitle("Prior") ///
		ytitle("Posterior") ///
		title("Unemployment") ///
		xlabel(3(1)9) ///
		name(panelB, replace) ///
		  graphregion(color(white)) bgcolor(white)  
	

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*							GDP
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
reg w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated<10, robust
local X1_gdp=string(_b[w4_egdp_12m],"%3.2f")
local X2_gdp=string(_se[w4_egdp_12m],"%3.2f")
 
 twoway (scatter w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated<10, mfcolor(none)) ///
		(line w4_egdp_12m w4_egdp_12m, lcolor(red)) ///
		(lfit w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated<10, lpattern(dash) lwidth(thick) lcolor(blue)) ///			
		, ///
		legend(off) ///
		xtitle("Prior") ///
		ytitle("Posterior") ///
		title("GDP") ///
		name(panelC, replace) ///
		  graphregion(color(white)) bgcolor(white)  
		
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
*								legend panel
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 twoway (scatter w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated>100, mfcolor(none)) ///
		(line w4_egdp_12m w4_egdp_12m if w4_egdp_12m>100, lcolor(red)) ///
		(lfit w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated>100, lpattern(dash) lwidth(thick) lcolor(blue)) ///
		(lfit w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated>100, lpattern(dash) lwidth(thick) lcolor(white)) ///			
		(lfit w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated>100, lpattern(dash) lwidth(thick) lcolor(white)) ///			
		(lfit w4_egdp_12m_treated w4_egdp_12m if w4_egdp_12m_treated>100, lpattern(dash) lwidth(thick) lcolor(white)) ///			
		, ///
		legend(order(2 3 4 5 6) ///
				label(2 "45-degree line") ///
				label(3 "Fitted line") ///
				label(4 "   Inflation slope = `X1_pi' (`X2_pi')") ///
				label(5 "   Unemp. rate slope = `X1_ue' (`X2_ue')") ///
				label(6 "   GDP slope = `X1_gdp' (`X2_gdp')") ///
				ring(0) position(0) rows(5) col(1)) ///
		subtitle("") ///
		ylabel(none) yscale(off) ///
		xlabel(none) xscale(off) ///
		ytitle("") xtitle("") ///
		graphregion(color(none) fcolor(none)) ///
		plotregion(color(none) fcolor(none)) ///
		name(panel_legend, replace)  ///
		  graphregion(color(white)) bgcolor(white)  
		
			
graph combine panelA panelB panelC panel_legend, imargin(tiny)	 ///
		  graphregion(color(white))  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_06.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_06.pdf", replace 
	
		
