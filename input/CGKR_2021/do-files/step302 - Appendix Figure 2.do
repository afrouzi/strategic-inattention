clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

encode w8_exper_group, gen(w8_exper_groupN)
***==========================================================================
*** 				scatter plot: high order expectations
***==========================================================================
twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==1, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==1, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==1, lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Implied E{super:2}{bf:{&pi}}, prior") ///
		ytitle("Point prediction E{super:2}{bf:{&pi}}, posterior") ///
		title("Panel 1: Control group") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig1, replace)
		
twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==2, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==2, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==2, lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Implied E{super:2}{bf:{&pi}}, prior") ///
		ytitle("Point prediction E{super:2}{bf:{&pi}}, posterior") ///
		title("Panel 2: Treatment B") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig2, replace)		
		
		
twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==3, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==3, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==3, lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Implied E{super:2}{bf:{&pi}}, prior") ///
		ytitle("Point prediction E{super:2}{bf:{&pi}}, posterior") ///
		title("Panel 3: Treatment C") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig3, replace)	

twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==4, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==4, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==4, lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Implied E{super:2}{bf:{&pi}}, prior") ///
		ytitle("Point prediction E{super:2}{bf:{&pi}}, posterior") ///
		title("Panel 4: Treatment D") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig4, replace)	
		

twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==5, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==5, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==5, lcolor(blue)) ///
		, ///
		legend(off) ///
		xtitle("Implied E{super:2}{bf:{&pi}}, prior") ///
		ytitle("Point prediction E{super:2}{bf:{&pi}}, posterior") ///
		title("Panel 5: Treatment E") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig5, replace)	

twoway (scatter w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==-1, msymbol(oh)) ///
		(lfit w8_epi_ho_12m_exper w8_epi_ho_12m_implied if w8_exper_groupN==-1, lcolor(red) lwidth(vthick)) ///
		(lfit w8_epi_ho_12m_implied w8_epi_ho_12m_implied if w8_exper_groupN==-1, lcolor(blue)) ///
		, ///
		yscale(lcolor(white))  xscale(lcolor(white)) ///
		legend(order(2 3) label(2 "fitted line") label(3 "45-degree line") rows(2) ring(0) position(0)) ///
		xtitle(" ") ///
		ytitle(" ") ///
		title(" ") ///
		graphregion(color(white)) bgcolor(white) ///
		name(fig6, replace)	

		
graph combine fig1 fig2 fig3 fig4 fig5 fig6, ///
	imargin(tiny) rows(3) graphregion(color(white)) ///
	ysize(10) xsize(8) ///
	name(figHOE, replace)
		
