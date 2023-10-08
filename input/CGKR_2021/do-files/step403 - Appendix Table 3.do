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

gen flag19=(w8_competitors<=2) /*tenure (experience) in the industry*/ 
gen flag20=(w8_competitors>2 & w8_competitors<=10) 
gen flag21=(w8_competitors>10) 



tempname 2
postfile `2'  str10 sample ///
    str10 FO_mean ///
	str10 HO_mean ///
	str10 FO_sd ///
	str10 HO_sd ///
	str10 FO_uncertainty ///
	str10 HO_uncertainty ///
	str10 rho_corr ///
	using "FO_HO_descriptive_stats_by_subsample.dta", replace every(1)
	
							
						
forvalues smpl0=1(1)21 {	
				 *** First order beliefs
				 sum w8_epi_12m_implied if flag`smpl0'==1
				 local FO_mean=string(r(mean),"%3.2f")
				 local FO_sd= string(r(sd),"%3.2f")  
				 
				 *** Higher order beliefs
				 sum w8_epi_ho_12m_implied if flag`smpl0'==1
				 local HO_mean=string(r(mean),"%3.2f")
				 local HO_sd= string(r(sd),"%3.2f")  	
				 
				 *** Uncertainty: first-order beliefs
				 sum w8_epi_12m_implied_std if flag`smpl0'==1
				 local FO_uncertainty=string(r(mean),"%3.2f")
				 
				 *** Uncertainty: higher-order beliefs
				 sum w8_epi_ho_12m_implied_std if flag`smpl0'==1
				 local HO_uncertainty=string(r(mean),"%3.2f")
				 
				 *** correlated with expected inflation
				 corr  w8_epi_12m_implied w8_epi_ho_12m_implied  if flag`smpl0'==1
				 local rho_corr=string(r(rho),"%3.2f")
				 post `2' ("`smpl0'") ("`FO_mean'") ("`HO_mean'")  ("`FO_sd'") ("`HO_sd'")   ("`FO_uncertainty'") ("`HO_uncertainty'")  ("`rho_corr'") 
				  
}			
postclose `2'	

use FO_HO_descriptive_stats_by_subsample, clear
