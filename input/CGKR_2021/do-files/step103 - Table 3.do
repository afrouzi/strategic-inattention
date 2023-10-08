clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"

sort w8_exper_group

encode w8_exper_group, gen(w8_exper_groupN)


****============================================================================
*** check whether treatment had an effect
****============================================================================

*** implied mean prediction of inflation
reghdfe  w8_epi_12m_exper i.w8_exper_groupN#c.w8_epi_12m_implied, absorb(w8_exper_groupN) vce(robust)
outreg2 using table03.dta, dta replace dec(3) ctitle("LOE")
estimates store LOE

*** implied mean prediction of HO inflation
reghdfe  w8_epi_ho_12m_exper i.w8_exper_groupN#c.w8_epi_ho_12m_implied, absorb(w8_exper_groupN) vce(robust) 
outreg2 using table03.dta, dta append dec(3) ctitle("HOE")
estimates store HOE
 
quiet { 
	reg  w8_epi_12m_exper i.w8_exper_groupN##c.w8_epi_12m_implied 
	estimates store LOE 
	reg  w8_epi_ho_12m_exper i.w8_exper_groupN##c.w8_epi_ho_12m_implied
	estimates store HOE
	suest LOE HOE, vce(robust)
} 
*** test equality of slopes for low-order and high-order inflation expectations
*** control group
test [LOE_mean]w8_epi_12m_implied = [HOE_mean]w8_epi_ho_12m_implied

*** group B
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]2.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]2.w8_exper_groupN#c.w8_epi_ho_12m_implied

*** group C
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]3.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]3.w8_exper_groupN#c.w8_epi_ho_12m_implied


*** group D
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]4.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]4.w8_exper_groupN#c.w8_epi_ho_12m_implied
		
*** group E
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]5.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]5.w8_exper_groupN#c.w8_epi_ho_12m_implied
	
	

***** Follow-up ******

*** implied mean prediction of inflation
reghdfe  w9_epi_12m_implied i.w8_exper_groupN#c.w8_epi_12m_implied, absorb(w8_exper_groupN) vce(robust)
outreg2 using table03.dta, dta append dec(3) ctitle("LOE: follow-up")
 
*** implied mean prediction of HO inflation
reghdfe  w9_epi_ho_12m_implied i.w8_exper_groupN#c.w8_epi_ho_12m_implied, absorb(w8_exper_groupN) vce(robust) 
outreg2 using table03.dta, dta append dec(3) ctitle("HOE: follow-up")
 

quiet { 
	reg  w9_epi_12m_implied i.w8_exper_groupN##c.w8_epi_12m_implied 
	estimates store LOE 
	reg  w9_epi_ho_12m_implied i.w8_exper_groupN##c.w8_epi_ho_12m_implied
	estimates store HOE
	suest LOE HOE, vce(robust)
} 
*** test equality of slopes for low-order and high-order inflation expectations
*** control group
test [LOE_mean]w8_epi_12m_implied = [HOE_mean]w8_epi_ho_12m_implied

*** group B
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]2.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]2.w8_exper_groupN#c.w8_epi_ho_12m_implied

*** group C
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]3.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]3.w8_exper_groupN#c.w8_epi_ho_12m_implied


*** group D
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]4.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]4.w8_exper_groupN#c.w8_epi_ho_12m_implied
		
*** group E
test 		[LOE_mean]w8_epi_12m_implied + [LOE_mean]5.w8_exper_groupN#c.w8_epi_12m_implied ///
		= 	[HOE_mean]w8_epi_ho_12m_implied + [HOE_mean]5.w8_exper_groupN#c.w8_epi_ho_12m_implied
	
