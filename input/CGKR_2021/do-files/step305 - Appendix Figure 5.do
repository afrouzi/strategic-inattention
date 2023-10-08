clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"


*** distribtuion of the implied means
twoway (hist w8_epi_12m_implied if w8_epi_12m_implied>=-5,  start(-5) width(1) fraction) ///
	   (hist w8_epi_ho_12m_implied if w8_epi_ho_12m_implied>=-5, start(-5) width(1) fcolor(none) lcolor(black) fraction) ///
	   	, ///
		graphregion(color(white)) bgcolor(white) ///
		legend(off) ///
		ylabel(0(0.05)0.25) ///
		xtitle("Expected inflation, implied mean") ///
		xlabel(-5(5)15) ///
		title("Panel A: Distribution of expected inflation, implied mean") ///
		name(fig1, replace)
	

*** distribtuion of the implied uncertainty
twoway (hist w8_epi_12m_implied_std  ,  start(0) width(0.25) fraction) ///
	   (hist w8_epi_ho_12m_implied_std  , start(0) width(0.25) fcolor(none) lcolor(black) fraction) ///
	   	, ///
		graphregion(color(white)) bgcolor(white) ///
		legend(label(1 "First-order expectations") label(2 "Higher-order expectations") rows(2) ring(0) position(1)) ///
		ylabel(0(0.05)0.25) ///
		xtitle("Expected inflation, implied uncertainty") ///
		xlabel(0(1)5) ///
		title("Panel B: Distribution of expected inflation, uncertainty") ///
		name(fig2, replace)
		
		
graph combine fig1 fig2, ///
	imargin(tiny) rows(2) graphregion(color(white)) ///
	ysize(28) xsize(21)
	
	
