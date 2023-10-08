clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear


gen w7_anzsic_code3=floor(w7_anzsic_cod/10)
gen w7_anzsic_code2=floor(w7_anzsic_cod/100)
gen w7_anzsic_code1=floor(w7_anzsic_cod/1000)

tab w6_group_rand

gen w6_group_rand_s=w6_group_rand
replace w6_group_rand_s="a-grp1"  if w6_group_rand_s=="a-grp2"
replace w6_group_rand_s="b-grp1"  if w6_group_rand_s=="b-grp2"
replace w6_group_rand_s="c-grp1"  if w6_group_rand_s=="c-grp2"



*=========================================================================
*			compute implied means from distrib. questions
*=========================================================================
quiet foreach wave0 in w6 {

*****
noisily di "`wave0': w6_ecore_gr2_"
egen _rm=rownonmiss(`wave0'_ecore_gr2_12m_*)

foreach var in 	`wave0'_ecore_gr2_12m_25plus `wave0'_ecore_gr2_12m_15_25 ///
				`wave0'_ecore_gr2_12m_10_15 `wave0'_ecore_gr2_12m_8_10 `wave0'_ecore_gr2_12m_6_8 ///
				`wave0'_ecore_gr2_12m_4_6 `wave0'_ecore_gr2_12m_2_4 `wave0'_ecore_gr2_12m_0_2 ///
				`wave0'_ecore_gr2_12m_0_neg2 `wave0'_ecore_gr2_12m_neg2_neg4 `wave0'_ecore_gr2_12m_neg4_neg6 ///
				`wave0'_ecore_gr2_12m_neg6_neg8 `wave0'_ecore_gr2_12m_neg8_neg10 ///
				`wave0'_ecore_gr2_12m_neg10_neg15 `wave0'_ecore_gr2_12m_neg15_neg25 `wave0'_ecore_gr2_12m_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_ecore_gr2_12m_implied = `wave0'_ecore_gr2_12m_25plus*25 ///
							+ `wave0'_ecore_gr2_12m_15_25*20 ///
							+ `wave0'_ecore_gr2_12m_10_15*12.5 ///
							+ `wave0'_ecore_gr2_12m_8_10*9 ///
							+ `wave0'_ecore_gr2_12m_6_8*7 ///
							+ `wave0'_ecore_gr2_12m_4_6*5 ///
							+ `wave0'_ecore_gr2_12m_2_4*3 ///
							+ `wave0'_ecore_gr2_12m_0_2*1 ///
							+ `wave0'_ecore_gr2_12m_0_neg2*(-1) ///
							+ `wave0'_ecore_gr2_12m_neg2_neg4*(-3) ///
							+ `wave0'_ecore_gr2_12m_neg4_neg6*(-5) ///
							+ `wave0'_ecore_gr2_12m_neg6_neg8*(-7) ///
							+ `wave0'_ecore_gr2_12m_neg8_neg10*(-9) ///
							+ `wave0'_ecore_gr2_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_ecore_gr2_12m_neg15_neg25*(-20) ///
							+ `wave0'_ecore_gr2_12m_moreneg25*(-25)

replace `wave0'_ecore_gr2_12m_implied=`wave0'_ecore_gr2_12m_implied/100

*****
noisily di "`wave0': w6_emc_gr2_"
egen _rm=rownonmiss(`wave0'_emc_gr2_12m_*)

foreach var in 	`wave0'_emc_gr2_12m_25plus `wave0'_emc_gr2_12m_15_25 ///
				`wave0'_emc_gr2_12m_10_15 `wave0'_emc_gr2_12m_8_10 `wave0'_emc_gr2_12m_6_8 ///
				`wave0'_emc_gr2_12m_4_6 `wave0'_emc_gr2_12m_2_4 `wave0'_emc_gr2_12m_0_2 ///
				`wave0'_emc_gr2_12m_0_neg2 `wave0'_emc_gr2_12m_neg2_neg4 `wave0'_emc_gr2_12m_neg4_neg6 ///
				`wave0'_emc_gr2_12m_neg6_neg8 `wave0'_emc_gr2_12m_neg8_neg10 ///
				`wave0'_emc_gr2_12m_neg10_neg15 `wave0'_emc_gr2_12m_neg15_neg25 `wave0'_emc_gr2_12m_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_emc_gr2_12m_implied = `wave0'_emc_gr2_12m_25plus*25 ///
							+ `wave0'_emc_gr2_12m_15_25*20 ///
							+ `wave0'_emc_gr2_12m_10_15*12.5 ///
							+ `wave0'_emc_gr2_12m_8_10*9 ///
							+ `wave0'_emc_gr2_12m_6_8*7 ///
							+ `wave0'_emc_gr2_12m_4_6*5 ///
							+ `wave0'_emc_gr2_12m_2_4*3 ///
							+ `wave0'_emc_gr2_12m_0_2*1 ///
							+ `wave0'_emc_gr2_12m_0_neg2*(-1) ///
							+ `wave0'_emc_gr2_12m_neg2_neg4*(-3) ///
							+ `wave0'_emc_gr2_12m_neg4_neg6*(-5) ///
							+ `wave0'_emc_gr2_12m_neg6_neg8*(-7) ///
							+ `wave0'_emc_gr2_12m_neg8_neg10*(-9) ///
							+ `wave0'_emc_gr2_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_emc_gr2_12m_neg15_neg25*(-20) ///
							+ `wave0'_emc_gr2_12m_moreneg25*(-25)

replace `wave0'_emc_gr2_12m_implied=`wave0'_emc_gr2_12m_implied/100



******				
noisily di "`wave0': w6_emc_gr1"
egen _rm=rownonmiss(`wave0'_emc_gr1_12m_*)

foreach var in 	`wave0'_emc_gr1_12m_lessneg1 `wave0'_emc_gr1_12m_neg1_1 `wave0'_emc_gr1_12m_1_3 ///
				`wave0'_emc_gr1_12m_3_5 `wave0'_emc_gr1_12m_more5 ///
				{
				noisily di "`var'"
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

 gen `wave0'_emc_gr1_12m_implied = `wave0'_emc_gr1_12m_lessneg1*-2 ///
								+ `wave0'_emc_gr1_12m_neg1_1*0 ///
								+ `wave0'_emc_gr1_12m_1_3*2 ///
								+ `wave0'_emc_gr1_12m_3_5*4 ///
								+ `wave0'_emc_gr1_12m_more5*6
								
 replace `wave0'_emc_gr1_12m_implied=`wave0'_emc_gr1_12m_implied /100
 
 

*****

noisily di "`wave0': _ecore_gr1_12m"
egen _rm=rownonmiss(`wave0'_ecore_gr1_12m_*)

foreach var in 	`wave0'_ecore_gr1_12m_4plus `wave0'_ecore_gr1_12m_3p5_3p9 ///
				`wave0'_ecore_gr1_12m_3_3p4 `wave0'_ecore_gr1_12m_2p5_2p9 `wave0'_ecore_gr1_12m_2_2p4 ///
				`wave0'_ecore_gr1_12m_1p5_1p9 `wave0'_ecore_gr1_12m_1_1p4 `wave0'_ecore_gr1_12m_0p5_0p6 ///
				`wave0'_ecore_gr1_12m_0_0p4 `wave0'_ecore_gr1_12m_less0  ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_ecore_gr1_12m_implied = `wave0'_ecore_gr1_12m_4plus*4.2 ///
							+ `wave0'_ecore_gr1_12m_3p5_3p9*3.7 ///
							+ `wave0'_ecore_gr1_12m_3_3p4*3.2 ///
							+ `wave0'_ecore_gr1_12m_2p5_2p9*2.7 ///
							+ `wave0'_ecore_gr1_12m_2_2p4*2.2 ///
							+ `wave0'_ecore_gr1_12m_1p5_1p9*1.7 ///
							+ `wave0'_ecore_gr1_12m_1_1p4*1.2 ///
							+ `wave0'_ecore_gr1_12m_0p5_0p6*0.7 ///
							+ `wave0'_ecore_gr1_12m_0_0p4*0.2 ///
							+ `wave0'_ecore_gr1_12m_less0*(-0.3) 
replace `wave0'_ecore_gr1_12m_implied=`wave0'_ecore_gr1_12m_implied/100



*****
noisily di "`wave0': epi_12m"
egen _rm=rownonmiss(`wave0'_epi_12m_*)

foreach var in 	`wave0'_epi_12m_25plus `wave0'_epi_12m_15_25 ///
				`wave0'_epi_12m_10_15 `wave0'_epi_12m_8_10 `wave0'_epi_12m_6_8 ///
				`wave0'_epi_12m_4_6 `wave0'_epi_12m_2_4 `wave0'_epi_12m_0_2 ///
				`wave0'_epi_12m_0_neg2 `wave0'_epi_12m_neg2_neg4 `wave0'_epi_12m_neg4_neg6 ///
				`wave0'_epi_12m_neg6_neg8 `wave0'_epi_12m_neg8_neg10 ///
				`wave0'_epi_12m_neg10_neg15 `wave0'_epi_12m_neg15_neg25 `wave0'_epi_12m_moreneg25 ///
				{	
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_12m_implied = `wave0'_epi_12m_25plus*25 ///
							+ `wave0'_epi_12m_15_25*20 ///
							+ `wave0'_epi_12m_10_15*12.5 ///
							+ `wave0'_epi_12m_8_10*9 ///
							+ `wave0'_epi_12m_6_8*7 ///
							+ `wave0'_epi_12m_4_6*5 ///
							+ `wave0'_epi_12m_2_4*3 ///
							+ `wave0'_epi_12m_0_2*1 ///
							+ `wave0'_epi_12m_0_neg2*(-1) ///
							+ `wave0'_epi_12m_neg2_neg4*(-3) ///
							+ `wave0'_epi_12m_neg4_neg6*(-5) ///
							+ `wave0'_epi_12m_neg6_neg8*(-7) ///
							+ `wave0'_epi_12m_neg8_neg10*(-9) ///
							+ `wave0'_epi_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_12m_neg15_neg25*(-20) ///
							+ `wave0'_epi_12m_moreneg25*(-25)

replace `wave0'_epi_12m_implied=`wave0'_epi_12m_implied/100

}

di "done"
*=========================================================================
*			compute implied std from distrib. questions
*=========================================================================
quiet foreach wave0 in w6 {
foreach var0 in epi_12m_ emc_gr2_12m_ ecore_gr2_12m_ {
noisily di "uncertainty: `wave0': `var0'"
gen `wave0'_`var0'_hold= ///
								  `wave0'_`var0'25plus*((25-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'15_25*((20-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'10_15*((12.5-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'8_10*((9-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'6_8*((7-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'4_6*((5-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'2_4*((3-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'0_2*((1-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'0_neg2*(((-1)-`wave0'_`var0'implied)^2) ///
								+`wave0'_`var0'neg2_neg4*(((-3)-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'neg4_neg6*(((-5)-`wave0'_`var0'implied)^2) ///
								+`wave0'_`var0'neg6_neg8*(((-7)-`wave0'_`var0'implied)^2) ///
								+`wave0'_`var0'neg8_neg10*(((-9)-`wave0'_`var0'implied)^2) ///
								+ `wave0'_`var0'neg10_neg15*(((-12.5)-`wave0'_`var0'implied)^2) ///
								+`wave0'_`var0'neg15_neg25*(((-20)-`wave0'_`var0'implied)^2) ///
								+`wave0'_`var0'moreneg25*(((-25)-`wave0'_`var0'implied)^2)

gen `wave0'_`var0'uncertainty=`wave0'_`var0'_hold/100
gen `wave0'_`var0'std=sqrt(`wave0'_`var0'uncertainty)
}
}

******
quiet foreach wave0 in w6  {

capture drop `wave0'_emc_gr1_12m_implied_hold
noisily di "`wave0': _emc_gr1_12m"


 gen `wave0'_emc_gr1_12m_implied_hold = `wave0'_emc_gr1_12m_lessneg1*(-2-`wave0'_emc_gr1_12m_implied)^2 ///
								+ `wave0'_emc_gr1_12m_neg1_1*(0-`wave0'_emc_gr1_12m_implied)^2 ///
								+ `wave0'_emc_gr1_12m_1_3*(2-`wave0'_emc_gr1_12m_implied)^2 ///
								+ `wave0'_emc_gr1_12m_3_5*(4-`wave0'_emc_gr1_12m_implied)^2 ///
								+ `wave0'_emc_gr1_12m_more5*(6-`wave0'_emc_gr1_12m_implied)^2
								

gen `wave0'_emc_gr1_12m_uncertainty =`wave0'_emc_gr1_12m_implied_hold/100
gen `wave0'_emc_gr1_12m_std=sqrt(`wave0'_emc_gr1_12m_uncertainty)
 

*****
capture drop `wave0'_ecore_gr1_12m_implied_hold

gen `wave0'_ecore_gr1_12m_implied_hold = ///
							`wave0'_ecore_gr1_12m_4plus*(4.2-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_3p5_3p9*(3.7-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_3_3p4*(3.2-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_2p5_2p9*(2.7-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_2_2p4*(2.2-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_1p5_1p9*(1.7-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_1_1p4*(1.2-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_0p5_0p6*(0.7-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_0_0p4*(0.2-`wave0'_ecore_gr1_12m_implied)^2 ///
							+ `wave0'_ecore_gr1_12m_less0*(-0.3-`wave0'_ecore_gr1_12m_implied)^2

								
gen `wave0'_ecore_gr1_12m_uncertainty =`wave0'_ecore_gr1_12m_implied_hold/100
gen `wave0'_ecore_gr1_12m_std=sqrt(`wave0'_ecore_gr1_12m_uncertainty)
}

drop *_hold
drop *_uncer*

*=========================================================================
*				compare moments across groups
*=========================================================================
tabstat w6_epi_12m_implied w6_epi_12m_std  [aw=w6_wgtE_43], stat(N mean p50 sd)

*** compare implied means for core CPI
tabstat w6_ecore_gr1_12m_implied w6_ecore_gr2_12m_implied [aw=w6_wgtE_43], stat(N mean p50 sd)

*** compare implied means for unit costs
tabstat w6_emc_gr1_12m_implied w6_emc_gr2_12m_implied [aw=w6_wgtE_43], stat(N mean p50 sd)

*** compare implied uncertainty for core CPI
tabstat w6_ecore_gr1_12m_std w6_ecore_gr2_12m_std [aw=w6_wgtE_43], stat(N mean p50 sd)

*** compare implied uncertainty for unit costs
tabstat w6_emc_gr1_12m_std w6_emc_gr2_12m_std [aw=w6_wgtE_43], stat(N mean p50 sd)

*** correlation between implied measures
corr w6_ecore_gr1_12m_implied w6_epi_12m_implied [aw=w6_wgtE_43]
corr w6_ecore_gr2_12m_implied w6_epi_12m_implied [aw=w6_wgtE_43]

corr w6_emc_gr1_12m_implied w6_epi_12m_implied [aw=w6_wgtE_43]
corr w6_emc_gr2_12m_implied w6_epi_12m_implied [aw=w6_wgtE_43]


*** compare responses for the general inflation question
scatter w6_ecore_gr1_12m_implied w6_epi_12m_implied, ///
	msymbol(oh) mlwidth(thin) jitter(2) ///
	xtitle("Inflation forecast (general level of prices)") ///
	ytitle("Inflation forecast (core CPI)") ///
	title("Core CPI: Small/few bins") ///
	name(core1, replace)
	
scatter w6_ecore_gr2_12m_implied w6_epi_12m_implied, ///
	msymbol(oh) mlwidth(thin) jitter(2) ///
	xtitle("Inflation forecast (general level of prices)") ///
	ytitle("Inflation forecast (core CPI)") ///
	title("Core CPI: Large/many bins") ///
	name(core2, replace)

scatter w6_emc_gr1_12m_implied w6_epi_12m_implied, ///
	msymbol(oh) mlwidth(thin) jitter(2) ///
	xtitle("Inflation forecast (general level of prices)") ///
	ytitle("Unit cost forecast") ///
	title("Unit cost: Small/few bins") ///
	name(uc1, replace)
	
scatter w6_emc_gr2_12m_implied w6_epi_12m_implied, ///
	msymbol(oh) mlwidth(thin) jitter(2) ///
	xtitle("Inflation forecast (general level of prices)") ///
	ytitle("Unit cost forecast") ///
	title("Unit cost: Large/many bins") ///
	name(uc2, replace)		

graph combine core1 core2 uc1 uc2, rows(2) imargin(tiny) name(mean_forecast, replace)






**** distribution
sum w6_ecore_gr2_12m_* [aw=w6_wgtE_43]
sum w6_ecore_gr1_12m_* [aw=w6_wgtE_43]
