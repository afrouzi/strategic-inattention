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
	str20 bin ///
	binN ///
    str10 FO ///
	str10 HO ///
	str10 FO_minus_HO ///
	using "FO_HO_descriptive_stats.dta", replace every(1)
	
							
						
forvalues smpl0=1(1)21 {	
	local cc=16
quiet foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
			  0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
			{

				 capture drop diff_`i'
				 gen diff_`i'=w8_epi_12m_`i' - w8_epi_ho_12m_`i'
				 
				 *** First order beliefs
				 sum w8_epi_12m_`i' if flag`smpl0'==1
				 local FO_mean=string(r(mean),"%3.1f")
				 local FO_sd="(" + string(r(sd),"%3.1f") + ")"
				 
				 *** Higher order beliefs
				 sum w8_epi_ho_12m_`i' if flag`smpl0'==1
				 local HO_mean=string(r(mean),"%3.1f")
				 local HO_sd="(" + string(r(sd),"%3.1f") + ")"	
				 
				 *** Difference
				 sum diff_`i' if flag`smpl0'==1
				 local diff_mean=string(r(mean),"%3.1f")
				 local diff_sd="(" + string(r(sd),"%3.1f") + ")"					 
				 
				 post `2' ("`smpl0'") ("`i'") (`cc') ("`FO_mean'") ("`HO_mean'") ("`diff_mean'") 
				 post `2' (" ") (" ")  (`cc')  ("`FO_sd'") ("`HO_sd'") ("`diff_sd'") 
				  
				local cc=`cc'-1
				 
			}
}			
postclose `2'	

use FO_HO_descriptive_stats, clear		

gen t=_n
keep if t<=32
edit
