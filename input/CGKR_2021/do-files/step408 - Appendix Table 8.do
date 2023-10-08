clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use wave_2020_test, clear
capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"


encode w10_order_randomization, gen(w10_order_randomizationN)

***=============================================================================
*** Test difference between groups by ordering and different question types
***=============================================================================
*** Answers Q17 then Q18 but one group is presented with the option "Don't Know" for all
gen test_1 = .
replace test_1 = 0 if w10_order_randomizationN == 1
replace test_1 = 1 if w10_order_randomizationN == 2

gen test_2 = .
replace test_2 = 0 if w10_order_randomizationN == 3
replace test_2 = 1 if w10_order_randomizationN == 4

gen test_3 = .
replace test_3 = 0 if w10_order_randomizationN == 1
replace test_3 = 1 if w10_order_randomizationN == 3

gen test_4 = .
replace test_4 = 0 if w10_order_randomizationN == 2
replace test_4 = 1 if w10_order_randomizationN == 4

ttest w10_epi_12m_implied, by(test_1)
ttest w10_epi_12m_implied, by(test_2)
ttest w10_epi_12m_implied, by(test_3)
ttest w10_epi_12m_implied, by(test_4)

ttest w10_epi_ho_12m_implied, by(test_1)
ttest w10_epi_ho_12m_implied, by(test_2)
ttest w10_epi_ho_12m_implied, by(test_3)
ttest w10_epi_ho_12m_implied, by(test_4)

*** see how many people use "do not know"
tabstat w10_epi_12m_implied w10_epi_ho_12m_implied w10_order_randomizationN, by(w10_order_randomizationN) stat(N)
*** fraction of firms choosing DNK for FO expectations
di 1-(118+117)/(120+120)
*** fraction of firms choosing DNK for HO expectations
di 1-(113+105)/(120+120)

tempname 1
postfile `1'  ///
	str20 test_label ///
	str10 mean_group1 ///
	str10 mean_group2 ///
	str10 pval ///	
	using "ordering_tests.dta", replace every(1)
	
	
***=============================================================================
***				test as a regression
***=============================================================================
reg w10_epi_ho_12m_implied i.w10_order_randomizationN

***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
***		first-order expectations
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
foreach  i in 3 4 1 2 {
    

    *** test equality of means
    ttest w10_epi_12m_implied, by(test_`i')
	local m1=string(r(mu_1),"%4.3f")
	local m2=string(r(mu_2),"%4.3f")
	local p_mean=string(r(p),"%4.3f")

	local N1=string(r(N_1),"%4.0fc")
	local N2=string(r(N_2),"%4.0fc")
	
	*** test equality of variances
    sdtest w10_epi_12m_implied, by(test_`i')
	local sd1=string(r(sd_1),"%4.3f")
	local sd2=string(r(sd_2),"%4.3f")
	local p_sd=string(r(p),"%4.3f")	
	
	local str0="FO expectations:" + "`i'"

	post `1'  ("`str0'") ("`m1'") ("`m2'") ("`p_mean'")    
	post `1'  (" ") ("`sd1'") ("`sd2'") ("`p_sd'")  
	post `1'  (" ") ("`N1'") ("`N2'") (" ")  	
}


***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
***		higher-order expectations
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
foreach  i in 3 4 1 2 {
    *** test equality of means
    ttest w10_epi_ho_12m_implied, by(test_`i')
	local m1=string(r(mu_1),"%4.3f")
	local m2=string(r(mu_2),"%4.3f")
	local p_mean=string(r(p),"%4.3f")

	local N1=string(r(N_1),"%4.0fc")
	local N2=string(r(N_2),"%4.0fc")
	
	*** test equality of variances
    sdtest w10_epi_ho_12m_implied, by(test_`i')
	local sd1=string(r(sd_1),"%4.3f")
	local sd2=string(r(sd_2),"%4.3f")
	local p_sd=string(r(p),"%4.3f")	
	
	local str0="HO expectations:" + "`i'"

	post `1'  ("`str0'") ("`m1'") ("`m2'") ("`p_mean'")    
	post `1'  (" ") ("`sd1'") ("`sd2'") ("`p_sd'")  
	post `1'  (" ") ("`N1'") ("`N2'") (" ")  	
}

postclose `1'
