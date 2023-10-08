******** Effects of Information on Actions ******************	
clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"

encode w8_exper_group, gen(w8_exper_groupN)

*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 		compute the size of the surprise in the treatment
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gen surp_pi =1.9 - w8_pi_12m if w8_exper_groupN==5
replace surp_pi=0 if w8_exper_groupN==1


gen surp_epi=3.3 - w8_epi_12m_implied if w8_exper_groupN==2 | w8_exper_groupN==4
replace surp_epi=0 if w8_exper_groupN==1

gen surp_epi_ho=3.5 - w8_epi_ho_12m_implied if w8_exper_groupN==3 | w8_exper_groupN==4
replace surp_epi_ho=0 if w8_exper_groupN==1

*** average inflation expectations
gen surp_epi_ave=(surp_epi + surp_epi_ho)/2

/*
epi12m: 3.926
epiho12m: 3.476867
pi12m 1.6
*/

gen surp_all=0 if w8_exper_groupN==1
replace surp_all=surp_epi if w8_exper_groupN==2
replace surp_all=surp_epi_ho if w8_exper_groupN==3
replace surp_all=surp_epi_ave if w8_exper_groupN==4
replace surp_all=surp_pi if w8_exper_groupN==5

*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 		compute forecast errors and forecast revisions
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gen FE_dp_3m=w9_edp_main_3m	-w8_edp_6m
gen FE_dn_3m=w9_edn_3m		-w8_edworkers_6m
gen FE_dk_3m=w9_edassets_3m	-w8_edassets_6m
gen FE_dw_3m=w9_edw_3m		-w8_edw_6m

gen rev_epi_12m_exper	=w8_epi_12m_exper 		- w8_epi_12m_implied
gen rev_epi_ho_12m_exper=w8_epi_ho_12m_exper 	- w8_epi_ho_12m_implied
gen rev_epi_12m			=w9_epi_12m_implied 	- w8_epi_12m_implied
gen rev_epi_ho_12m		=w9_epi_ho_12m_implied 	- w8_epi_ho_12m_implied

gen rev_epi_av_12m_exper = (rev_epi_12m_exper + rev_epi_ho_12m_exper)/2
gen rev_epi_av_12m		 = (rev_epi_12m + rev_epi_ho_12m)/2


*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 				treatment effect (control vs group B)
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

foreach var in dn dk dp dw {
	ivreg2  FE_`var'_3m (rev_epi_12m_exper=surp_epi) ///
		if w8_exper_groupN==2 | w8_exper_groupN==1, ffirst robust
	local F1=e(widstat)
	if "`var'"=="dn" {
		outreg2 using TableG3_cont_treatment2.dta, ///
			dta replace dec(3) ctitle("`var'") addstat("1 stage F",`F1') nocons
	}
	else {
	outreg2 using TableG3_cont_treatment2.dta, ///	
		dta append dec(3) ctitle("`var'") addstat("1 stage F",`F1')	 nocons
	}	
}


*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 				treatment effect (control vs group C)
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

foreach var in dn dk dp dw {
	ivreg2  FE_`var'_3m (rev_epi_12m_exper=surp_epi_ho) ///
		if w8_exper_groupN==3 | w8_exper_groupN==1, ffirst robust
	local F1=e(widstat)
	if "`var'"=="dn" {
		outreg2 using TableG3_cont_treatment3.dta, ///
			dta replace dec(3) ctitle("`var'") addstat("1 stage F",`F1')
	}
	else {
	outreg2 using TableG3_cont_treatment3.dta, ///	
		dta append dec(3) ctitle("`var'") addstat("1 stage F",`F1')	
	}
	
}


*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 				treatment effect (control vs group D)
***					the surprise is the average of LOE and HOE
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

foreach var in dn dk dp dw {
	ivreg2  FE_`var'_3m (rev_epi_12m_exper=surp_epi_av) ///
		if w8_exper_groupN==4 | w8_exper_groupN==1, ffirst robust
	local F1=e(widstat)
	if "`var'"=="dn" {
		outreg2 using TableG3_cont_treatment4.dta, ///
			dta replace dec(3) ctitle("dummy: `var'") addstat("1 stage F",`F1')
	}
	else {
	outreg2 using TableG3_cont_treatment4.dta, ///	
		dta append dec(3) ctitle("cont: `var'") addstat("1 stage F",`F1')
	}	
}


*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 				treatment effect (control vs group E)
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

foreach var in dn dk dp dw {
	ivreg2  FE_`var'_3m (rev_epi_12m_exper=surp_pi) ///
		if w8_exper_groupN==5 | w8_exper_groupN==1, ffirst robust
	local F1=e(widstat)
		if "`var'"=="dn" {
		outreg2 using TableG3_cont_treatment5.dta, ///
			dta replace dec(3) ctitle("`var'") addstat("1 stage F",`F1')
	}
	else {
	outreg2 using TableG3_cont_treatment5.dta, ///	
		dta append dec(3) ctitle("`var'") addstat("1 stage F",`F1')	
	}
	
}

*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 				treatment effect (control vs pooled)
*** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

foreach var in dn dk dp dw {
	ivreg2  FE_`var'_3m  (rev_epi_12m_exper=surp_all) ///
		, ffirst robust
	local F1=e(widstat)
		if "`var'"=="dn" {
		outreg2 using TableG3_cont_treatment_all.dta, ///
			dta replace dec(3) ctitle("`var'") addstat("1 stage F",`F1')
	}
	else {
	outreg2 using TableG3_cont_treatment_all.dta, ///	
		dta append dec(3) ctitle("`var'") addstat("1 stage F",`F1')	
	}
	
}

