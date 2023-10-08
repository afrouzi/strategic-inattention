clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"

gen MNFG=0
replace MNFG=1 if industry=="Manufacturing"

gen CONSTRUCTION=0
replace CONSTRUCTION=1 if industry=="Construction" | industry=="Construction and Transportation"

gen SERVICES=1 - MNFG - CONSTRUCTION


gen flag1=1 /* full sample */
gen flag2=(MNFG==1) /* Manufacturing sample */
gen flag3=(SERVICES==1) /* Services sample */
gen flag4=(CONSTRUCTION==1) /* Construction sample */

gen flag5=(w8_empl<=10) if w8_empl~=.
gen flag6=(w8_empl>10 & w8_empl<=49) if w8_empl~=.
gen flag7=(w8_empl>=50) if w8_empl~=.

gen flag8=(w8_manager_educ==1 | w8_manager_educ==2 | w8_manager_educ==3) /*some college or less*/
gen flag9=(w8_manager_educ==4) /*College Diploma*/
gen flag10=(w8_manager_educ==5) /*Graduate Studies (Masters or PhD)*/

gen flag11=(w8_manager_gender==0) /*males*/ 
gen flag12=(w8_manager_gender==1) /*females*/ 

gen flag13=(w8_age<=10) /*firm age*/ 
gen flag14=(w8_age>10 & w8_age<=25) 
gen flag15=(w8_age>25) 

gen flag16=(w8_manager_tenure_industry<=15) /*tenure (experience) in the industry*/ 
gen flag17=(w8_manager_tenure_industry>15 & w8_manager_tenure_industry<=29) 
gen flag18=(w8_manager_tenure_industry>29) 

gen flag19=(w8_competitors<=2) /* number of competitors */ 
gen flag20=(w8_competitors>2 & w8_competitors<=10) 
gen flag21=(w8_competitors>10) 

foreach var in w8_epi_12m_implied w8_epi_ho_12m_implied w8_epi_12m_implied_std w8_epi_ho_12m_implied_std ///
	{
	reg `var' ///
			flag3 flag4 ///   /* sector */
			flag6 flag7 ///    /* firm size */
			flag20 flag21 ///  /* number of competitors */
			flag14 flag15 ///  /*firm age */
			flag11 ///  /*male */
			flag9 flag10 /// /*manager education */
			flag17 flag18 /// /*manager tenure */
			, ///
			robust
	if "`var'"=="w8_epi_12m_implied" {
			outreg2 using table_predictors.dta, replace dta dec(3) ctitle("`var'")  
	}
	else {
			outreg2 using table_predictors.dta, append dta dec(3) ctitle("`var'")  		
	}

}	
		
