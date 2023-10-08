clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear


gen w7_anzsic_code3=floor(w7_anzsic_cod/10)
gen w7_anzsic_code2=floor(w7_anzsic_cod/100)
gen w7_anzsic_code1=floor(w7_anzsic_cod/1000)


gen d_edmc=w7_edmc_6m-w6_edmc_6m
gen d_epi= w7_epi_12m- w6_epi_12m

*==============================================================================
*			unit cost vs. expected inflation: Appendix Figure 3.3
*==============================================================================

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Wave 6
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
corr w6_edmc_6m w6_epi_12m [aw=w6_wgtE_43]
local rp=string(r(rho),"%4.3f")

twoway (scatter     w6_edmc_6m w6_epi_12m, msize(1.2) mcolor(blue) mfcolor(white) msymbol(ch) mlwidth(thin) jitter(2)) ///
	(lfit   w6_edmc_6m w6_epi_12m) ///
	, legend(off) ///
	xtitle("Inflation forecast, 12 months") ///
	ytitle("Unit cost change forecast, 6 months") ///
	xlabel(-1(1)9) ylabel(-4(2)10) ///
	title("Wave 5") name(wave5, replace) ///
	text(9 8 "{&rho} = `rp'")

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
*** Wave 7	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
corr  w7_edmc_6m w7_epi_12m [aw=w7_wgtE_43]
local rp=string(r(rho),"%4.3f")
twoway (scatter     w7_edmc_6m w7_epi_12m, msize(1.2) mcolor(blue) mfcolor(white) msymbol(ch) mlwidth(thin) jitter(2)) ///
	(lfit   w7_edmc_6m w7_epi_12m) ///
	, legend(off) ///
	xtitle("Inflation forecast, 12 months") ///
	ytitle("Unit cost change forecast, 6 months") ///
	xlabel(-1(1)9) ylabel(-4(2)10) ///
	title("Wave 6") name(wave6, replace) ///
	text(9 8 "{&rho} = `rp'")
	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
*** Wave 3
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
corr   w3_euc12 w3_epi_12 [aw=wgtE43]
local rp=string(r(rho),"%4.3f")
replace w3_euc12=20 if w3_euc12>20 & w3_euc12~=.
twoway (scatter     w3_euc12 w3_epi_12, msize(1.2) mcolor(blue) mfcolor(white) msymbol(ch) mlwidth(thin) jitter(2)) ///
	(lfit   w3_euc12 w3_epi_12) ///
	, legend(off) ///
	xtitle("Inflation forecast, 12 months") ///
	ytitle("Unit cost change forecast, 12 months") ///
	xlabel(0(2)18) ylabel(-2(2)20) ///
	title("Wave 3") name(wave3, replace) ///
	text(15 15 "{&rho} = `rp'")
	
graph combine wave3 wave5 wave6, imargin(tiny) name(unitcost, replace)
	

*==============================================================================
*	own price changes cost vs. expected inflation: Appendix Figure 3.4
*==============================================================================

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Wave 6
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
corr w6_edp_main_12m w6_epi_12m [aw=w6_wgtE_43]
local rp=string(r(rho),"%4.3f")

twoway (scatter     w6_edp_main_12m w6_epi_12m, msize(1.2) mcolor(blue) mfcolor(white) msymbol(ch) mlwidth(thin) jitter(2)) ///
	(lfit   w6_edp_main_12m w6_epi_12m) ///
	, legend(off) ///
	xtitle("Inflation forecast, 12 months") ///
	ytitle("Main product price change forecast, 12 months") ///
	xlabel(-1(1)9) ylabel(-4(2)10) ///
	title("Wave 5") name(wave5_edp, replace) ///
	text(9 8 "{&rho} = `rp'")

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
*** Wave 7	
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
corr  w7_edp_main_12m w7_epi_12m [aw=w7_wgtE_43]
local rp=string(r(rho),"%4.3f")

twoway (scatter     w7_edp_main_12m w7_epi_12m, msize(1.2) mcolor(blue) mfcolor(white) msymbol(ch) mlwidth(thin) jitter(2)) ///
	(lfit   w7_edp_main_12m w7_epi_12m) ///
	, legend(off) ///
	xtitle("Inflation forecast, 12 months") ///
	ytitle("Main product price change forecast, 12 months") ///
	xlabel(-1(1)9) ylabel(-4(2)10) ///
	title("Wave 6") name(wave6_edp, replace) ///
	text(9 8 "{&rho} = `rp'")
	

graph combine wave5_edp wave6_edp, imargin(tiny)
	
*==============================================================================
*					descriptive statistics:  Appendix Table 3.5
*==============================================================================

sum  w7_epi_12m w7_edmc_6m w7_edp_main_12m [aw=w7_wgtE_43]
sum  w6_epi_12m w6_edmc_6m w6_edp_main_12m [aw=w6_wgtE_43]
sum  w3_epi_12 w3_euc12 [aw=wgtE43]

tabstat w7_epi_12m w7_edmc_6m w7_edp_main_12m [aw=w7_wgtE_43], stat(N mean p50 sd) columns(statistics)
tabstat w6_epi_12m w6_edmc_6m w6_edp_main_12m [aw=w6_wgtE_43], stat(N mean p50 sd) columns(statistics)
tabstat w3_epi_12 w3_euc12 [aw=wgtE43], stat(N mean p50 sd) columns(statistics)
