clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

*** mean own forecast vs. mean other forecast
reg w8_epi_ho_12m_implied w8_epi_12m_implied, robust 
	
reg w8_epi_ho_12m_implied w8_epi_12m_implied
predict bb, dfbeta(w8_epi_12m_implied)

gen flag=1
replace flag=0 if abs(bb)>2/sqrt(e(N))
reg w8_epi_ho_12m_implied w8_epi_12m_implied if flag==1, robust
predict yhat

twoway (scatter w8_epi_ho_12m_implied w8_epi_12m_implied, msymbol(oh) ) ///
		(lfit yhat w8_epi_12m_implied , lcolor(red) lwidth(thick)) ///
		(lfit w8_epi_12m_implied w8_epi_12m_implied , lcolor(blue) ) ///
		, legend(off) ///
		ytitle("Implied E{bf:{&pi}}, other managers") ///
		xtitle("Implied E{bf:{&pi}}, own") ///
		text(-1.5 9 "slope = 0.66 (0.02)", color(red)) ///
		text(-2.5 9 "R2 = 0.61", color(red)) ///
		text(13 10.8 "45 degree", color(blue)) ///
		ylabel(-4(2)14) xlabel(-4(2)14)  ysize(8) xsize(9) ///
		graphregion(color(white)) bgcolor(white) ///
		name(ho_own_w8, replace)
		
 
