***  step 01 - add NZSIOC industry classifications


clear all
set more off

capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

*** EMPLOYMENT
insheet using "TABLECODE7602_Data_987b1649-890a-4e02-a574-c6858f2ec218.csv", clear

gen sic=substr(anzsic06,1,strpos(anzsic06," ")-1)
rename value emp
keep employmentsizegroup anzsic06 emp sic

compress
saveold NZ_employment, replace

*** FIRM COUNT
insheet using "TABLECODE7602_Data_9003a516-e1b8-4662-8adf-2cc87c45231f.csv", clear
gen sic=substr(anzsic06,1,strpos(anzsic06," ")-1)
rename value firm_count
keep if measure=="Geographic Units"
keep employmentsizegroup anzsic06 firm_count sic

compress
saveold NZ_firm_count, replace

*** MERGE FILES
capture drop _merge
joinby employmentsizegroup anzsic06 sic using NZ_employment, unmatched(both)
tab _merge
drop _merge

saveold all_data, replace

/*
*===================================================================
*  weigths based on ANZIC 3 digit and 5 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic3) force
replace anzic3=. if length(anzic)~=3

destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group5=.
replace emp_group5=1 if employmentsizegroup=="6 to 9"
replace emp_group5=2 if employmentsizegroup=="10 to 19"
replace emp_group5=3 if employmentsizegroup=="20 to 49"
replace emp_group5=4 if employmentsizegroup=="50 to 99"
replace emp_group5=5 if employmentsizegroup=="100+"

drop if emp_group==.
keep if anzic3~=.

keep emp firm_count anzic3 emp_group
collapse (sum) emp firm_count, by(anzic3 emp_group5)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
 
saveold NZ_census53, replace 
	  

*===================================================================
*  weigths based on ANZIC 2 digit and 5 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group5=.
replace emp_group5=1 if employmentsizegroup=="6 to 9"
replace emp_group5=2 if employmentsizegroup=="10 to 19"
replace emp_group5=3 if employmentsizegroup=="20 to 49"
replace emp_group5=4 if employmentsizegroup=="50 to 99"
replace emp_group5=5 if employmentsizegroup=="100+"

drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic2 emp_group
collapse (sum) emp firm_count, by(anzic2 emp_group5)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

saveold NZ_census52, replace 


*===================================================================
*  weigths based on ANZIC 1 digit and 5 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen anzic1=substr(anzic,1,1)
destring anzic1, replace force


gen emp_group5=.
replace emp_group5=1 if employmentsizegroup=="6 to 9"
replace emp_group5=2 if employmentsizegroup=="10 to 19"
replace emp_group5=3 if employmentsizegroup=="20 to 49"
replace emp_group5=4 if employmentsizegroup=="50 to 99"
replace emp_group5=5 if employmentsizegroup=="100+"

drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic1 emp_group
collapse (sum) emp firm_count, by(anzic1 emp_group5)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

saveold NZ_census51, replace 

	  */

*===================================================================
*  weigths based on ANZIC 3 digit and 4 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic3) force
replace anzic3=. if length(anzic)~=3

destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group4=.
replace emp_group4=1 if employmentsizegroup=="6 to 9"
replace emp_group4=2 if employmentsizegroup=="10 to 19"
replace emp_group4=3 if employmentsizegroup=="20 to 49"
replace emp_group4=4 if employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"

drop if emp_group==.
keep if anzic3~=.

keep emp firm_count anzic3 emp_group4
collapse (sum) emp firm_count, by(anzic3 emp_group4)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
 
saveold NZ_census43, replace 
	  
/*
*===================================================================
*  weigths based on ANZIC 2 digit and 4 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group4=.
replace emp_group4=1 if employmentsizegroup=="6 to 9"
replace emp_group4=2 if employmentsizegroup=="10 to 19"
replace emp_group4=3 if employmentsizegroup=="20 to 49"
replace emp_group4=4 if employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"


drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic2 emp_group
collapse (sum) emp firm_count, by(anzic2 emp_group4)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
 
saveold NZ_census42, replace 

*===================================================================
*  weigths based on ANZIC 1 digit and 4 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen anzic1=substr(anzic,1,1)
destring anzic1, replace force

gen emp_group4=.
replace emp_group4=1 if employmentsizegroup=="6 to 9"
replace emp_group4=2 if employmentsizegroup=="10 to 19"
replace emp_group4=3 if employmentsizegroup=="20 to 49"
replace emp_group4=4 if employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"


drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic1 emp_group
collapse (sum) emp firm_count, by(anzic1 emp_group4)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
 
saveold NZ_census41, replace 
	  

*===================================================================
*  weigths based on ANZIC 3 digit and 3 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic3) force
replace anzic3=. if length(anzic)~=3

destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group3=.
replace emp_group3=1 if employmentsizegroup=="6 to 9"
replace emp_group3=2 if employmentsizegroup=="10 to 19"
replace emp_group3=3 if employmentsizegroup=="20 to 49" | employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"

drop if emp_group==.
keep if anzic3~=.

keep emp firm_count anzic3 emp_group
collapse (sum) emp firm_count, by(anzic3 emp_group3)

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
 
saveold NZ_census33, replace 
	  

*===================================================================
*  weigths based on ANZIC 2 digit and 3 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen emp_group3=.
replace emp_group3=1 if employmentsizegroup=="6 to 9"
replace emp_group3=2 if employmentsizegroup=="10 to 19"
replace emp_group3=3 if employmentsizegroup=="20 to 49" | employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"


drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic2 emp_group3
collapse (sum) emp firm_count, by(anzic2 emp_group3)
 

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

saveold NZ_census32, replace 

*===================================================================
*  weigths based on ANZIC 1 digit and 3 employment groups
*===================================================================
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

use all_data, clear

gen anzic=substr(sic,2,length(sic)-1)
destring anzic, gen(anzic2) force
replace anzic2=. if length(anzic)~=2

gen anzic1=substr(anzic,1,1)
destring anzic1, replace force

gen emp_group3=.
replace emp_group3=1 if employmentsizegroup=="6 to 9"
replace emp_group3=2 if employmentsizegroup=="10 to 19"
replace emp_group3=3 if employmentsizegroup=="20 to 49" | employmentsizegroup=="50 to 99" | employmentsizegroup=="100+"


drop if emp_group==.
keep if anzic2~=.

keep emp firm_count anzic1 emp_group3
collapse (sum) emp firm_count, by(anzic1 emp_group3)
 

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

saveold NZ_census31, replace 
*/


*==========================================================================
*	calculate number of firms in the sample for each industry/size bin
*==========================================================================
clear all
set more off

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

 
* load data
use wave1, clear
joinby firmid using wave2, unmatched(both)
tab _merge
rename _merge _merge12
keep if w2_epi_12m~=.
 
joinby firmid using ANZSICcodes.dta
 * data now includes anzsic_code variable 
 
 *===================================================================
 *  weigths based on ANZIC 3 digit and 5 employment groups
 *===================================================================
 **  create industry codes to merge with census data
 gen anzic3=floor(anzsic_code/10)
 gen anzic2=floor(anzsic_code/100)
 gen anzic1=floor(anzsic_code/1000)

 ** generate employment bins
 gen L=w1_employment
 /*
gen emp_group5=.
replace emp_group5=1 if L>=6 & L<=9 & L~=.
replace emp_group5=2 if L>=10 & L<=19 & L~=.
replace emp_group5=3 if L>=20 & L<=49 & L~=.
replace emp_group5=4 if L>=50 & L<=99 & L~=.
replace emp_group5=5 if L>=100 & L~=.
*/

gen emp_group4=.
replace emp_group4=1 if L>=6 & L<=9 & L~=.
replace emp_group4=2 if L>=10 & L<=19 & L~=.
replace emp_group4=3 if L>=20 & L<=49 & L~=.
replace emp_group4=4 if L>=50 & L~=.

/*
gen emp_group3=.
replace emp_group3=1 if L>=6  & L<=9 & L~=.
replace emp_group3=2 if L>=10 & L<=19 & L~=.
replace emp_group3=3 if L>=20 & L~=.
*/

saveold temp_anzic_weights, replace

* foreach sic_digit in 1 2 3  {
*	foreach emp_group_size in 3 4 5 {
	
foreach sic_digit in   3  {
	foreach emp_group_size in   4   {	
		use temp_anzic_weights, clear
		collapse (sum) L, by(anzic`sic_digit' emp_group`emp_group_size')
		rename L L_sample

		joinby anzic`sic_digit' emp_group`emp_group_size' ///
			using NZ_census`emp_group_size'`sic_digit', ///
			unmatched(master)


		gen wgt`emp_group_size'`sic_digit'=emp/L_sample
		label var wgt`emp_group_size'`sic_digit' "weights; `emp_group_size' employment groups; `sic_digit'-digit anzic"
		keep anzic emp_group wgt
		saveold weights_wgt`emp_group_size'`sic_digit', replace
	}
}


use temp_anzic_weights	, clear

* foreach sic_digit in 1 2 3  {
* 	foreach emp_group_size in 3 4 5 {
foreach sic_digit in   3  {
	foreach emp_group_size in  4   {
		capture drop _merge
		joinby  anzic`sic_digit' emp_group`emp_group_size' using ///
			weights_wgt`emp_group_size'`sic_digit', unmatched(both)
		tab _merge
		drop _merge
		
	}
}

* erase temp files
* foreach sic_digit in 1 2 3  {
* 	foreach emp_group_size in 3 4 5 {
foreach sic_digit in   3  {
	foreach emp_group_size in   4   {
		erase weights_wgt`emp_group_size'`sic_digit'.dta
		erase NZ_census`emp_group_size'`sic_digit'.dta
	}
}

keep firmid wgt*
compress


 *============================================================================= 
 *	censor firm weights at 100 to avoid a handful of firms dominating
 *  the sample
 *=============================================================================

* foreach sic_digit in 1 2 3  {
*	foreach emp_group_size in 3 4 5 {
foreach sic_digit in   3  {
	foreach emp_group_size in   4   {	
		replace wgt`emp_group_size'`sic_digit'=100 if  wgt`emp_group_size'`sic_digit'>100 &  wgt`emp_group_size'`sic_digit'~=.
		rename  wgt`emp_group_size'`sic_digit'  wgtE`emp_group_size'`sic_digit'
	}
}

* drop wgtE31 wgtE41 wgtE51
/* 
foreach var in 32 42 52 33 43 53 {
	rename wgtE`var' w2_wgtE_`var'
}	
*/

foreach var in   43   {
	rename wgtE`var' w2_wgtE_`var'
}	

compress
notes: "created by step050 - create sample weights.do"
save NZ_census_weights_employment_w2, replace

