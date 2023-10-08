/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Figure A2.- Distributions of the Size of Firms’ Nowcast Errors
* Last Modified on 09/27/2023 by Hassan Afrouzi
*****************************************************************************************************/

use "$workingdir/master_file_processed.dta", clear

* This part repeats Coibion, Gorodnichenko, and Kumar (2018) to merge with PPI data and define backcast errors
* See "step204---Figure-04.do" for construction of these variables:
joinby sic2 using "$CGK_2018/PPIdata.dta", unmatched(both)
tab sic2 _merge
drop _merge

joinby sic2 using  "$CGK_2018/PPIdata_2014Q4", unmatched(master)
tab sic2 _merge
drop _merge

gen w4_pii_12m_be = abs(actual_pi_yoy_2014q4 - w4_pii_12m)
gen w4_pi_12m_be = abs(0.8 - w4_pi_12m)

grstyle init
grstyle set plain
graph set eps fontface "Palatino"

twoway (kdensity w4_pii_12m_be, kernel(gaussian) lcolor(black) lwidth(thick)) ///
	   (kdensity w4_pi_12m_be, kernel(gaussian) lcolor(maroon) lwidth(thick) ///
	   lpattern(dash)), ytitle(Density, size(large)) xtitle(Size of Nowcast Errors (Percentage Points), size(large)) ///
	   legend(pos(1) ring(0) col(1) order(1 "Industry Inflation" 2 "Aggregate Inflation") size(large)) ///
	   xline(1.16, lcolor(black) lwidth(.2) lpattern(dash_dot)) ///
	   xline(3.5, lcolor(maroon) lwidth(.2) lpattern(dash_dot)) xsize(6) ysize(2.5) ylabel(, format(%3.1fc))

graph export "$outdir/Figure_A2.pdf", as(pdf) replace
graph export "$outdir/Figure_A2.eps", as(eps) replace

