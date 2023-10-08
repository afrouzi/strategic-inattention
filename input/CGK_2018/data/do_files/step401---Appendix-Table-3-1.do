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
quiet foreach wave0 in w6 w7 {
noisily di "`wave0': eue"
capture drop _rm
 egen _rm=rownonmiss(w6_eue_12m_*)

foreach var in 	`wave0'_eue_12m_10plus `wave0'_eue_12m_9_10 `wave0'_eue_12m_8_9 ///
				`wave0'_eue_12m_7_8 `wave0'_eue_12m_6_7 `wave0'_eue_12m_5_6 ///
				`wave0'_eue_12m_4_5 `wave0'_eue_12m_3_4 `wave0'_eue_12m_less3 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_eue_12m_implied_hold = `wave0'_eue_12m_10plus*10 ///
								+ `wave0'_eue_12m_9_10*9.5 ///
								+ `wave0'_eue_12m_8_9*8.5 ///
								+ `wave0'_eue_12m_7_8*7.5 ///
								+ `wave0'_eue_12m_6_7*6.5 ///
								+ `wave0'_eue_12m_5_6*5.5 ///
								+ `wave0'_eue_12m_4_5*4.5 ///
								+ `wave0'_eue_12m_3_4*3.5 ///
								+ `wave0'_eue_12m_less3*3
gen `wave0'_eue_12m_implied =`wave0'_eue_12m_implied_hold/100

*****
noisily di "`wave0': epi_5y"
egen _rm=rownonmiss(`wave0'_epi_5y_*)

foreach var in 	`wave0'_epi_5y_25plus `wave0'_epi_5y_15_25 ///
				`wave0'_epi_5y_10_15 `wave0'_epi_5y_8_10 `wave0'_epi_5y_6_8 ///
				`wave0'_epi_5y_4_6 `wave0'_epi_5y_2_4 `wave0'_epi_5y_0_2 ///
				`wave0'_epi_5y_0_neg2 `wave0'_epi_5y_neg2_neg4 `wave0'_epi_5y_neg4_neg6 ///
				`wave0'_epi_5y_neg6_neg8 `wave0'_epi_5y_neg8_neg10 ///
				`wave0'_epi_5y_neg10_neg15 `wave0'_epi_5y_neg15_neg25 `wave0'_epi_5y_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_5y_implied = `wave0'_epi_5y_25plus*25 ///
							+ `wave0'_epi_5y_15_25*20 ///
							+ `wave0'_epi_5y_10_15*12.5 ///
							+ `wave0'_epi_5y_8_10*9 ///
							+ `wave0'_epi_5y_6_8*7 ///
							+ `wave0'_epi_5y_4_6*5 ///
							+ `wave0'_epi_5y_2_4*3 ///
							+ `wave0'_epi_5y_0_2*1 ///
							+ `wave0'_epi_5y_0_neg2*(-1) ///
							+ `wave0'_epi_5y_neg2_neg4*(-3) ///
							+ `wave0'_epi_5y_neg4_neg6*(-5) ///
							+ `wave0'_epi_5y_neg6_neg8*(-7) ///
							+ `wave0'_epi_5y_neg8_neg10*(-9) ///
							+ `wave0'_epi_5y_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_5y_neg15_neg25*(-20) ///
							+ `wave0'_epi_5y_moreneg25*(-25)

replace `wave0'_epi_5y_implied=`wave0'_epi_5y_implied/100

*****
noisily di "`wave0': epi_ind"
egen _rm=rownonmiss(`wave0'_epi_ind_12m_*)

foreach var in 	`wave0'_epi_ind_12m_25plus `wave0'_epi_ind_12m_15_25 ///
				`wave0'_epi_ind_12m_10_15 `wave0'_epi_ind_12m_8_10 `wave0'_epi_ind_12m_6_8 ///
				`wave0'_epi_ind_12m_4_6 `wave0'_epi_ind_12m_2_4 `wave0'_epi_ind_12m_0_2 ///
				`wave0'_epi_ind_12m_0_neg2 `wave0'_epi_ind_12m_neg2_neg4 `wave0'_epi_ind_12m_neg4_neg6 ///
				`wave0'_epi_ind_12m_neg6_neg8 `wave0'_epi_ind_12m_neg8_neg10 ///
				`wave0'_epi_ind_12m_neg10_neg15 `wave0'_epi_ind_12m_neg15_neg25 `wave0'_epi_ind_12m_moreneg25 ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

gen `wave0'_epi_ind_12m_implied = `wave0'_epi_ind_12m_25plus*25 ///
							+ `wave0'_epi_ind_12m_15_25*20 ///
							+ `wave0'_epi_ind_12m_10_15*12.5 ///
							+ `wave0'_epi_ind_12m_8_10*9 ///
							+ `wave0'_epi_ind_12m_6_8*7 ///
							+ `wave0'_epi_ind_12m_4_6*5 ///
							+ `wave0'_epi_ind_12m_2_4*3 ///
							+ `wave0'_epi_ind_12m_0_2*1 ///
							+ `wave0'_epi_ind_12m_0_neg2*(-1) ///
							+ `wave0'_epi_ind_12m_neg2_neg4*(-3) ///
							+ `wave0'_epi_ind_12m_neg4_neg6*(-5) ///
							+ `wave0'_epi_ind_12m_neg6_neg8*(-7) ///
							+ `wave0'_epi_ind_12m_neg8_neg10*(-9) ///
							+ `wave0'_epi_ind_12m_neg10_neg15*(-12.5) ///
							+ `wave0'_epi_ind_12m_neg15_neg25*(-20) ///
							+ `wave0'_epi_ind_12m_moreneg25*(-25)

replace `wave0'_epi_ind_12m_implied=`wave0'_epi_ind_12m_implied/100


******
noisily di "`wave0': egdp"
egen _rm=rownonmiss(`wave0'_egdp_12m_*)

foreach var in 	`wave0'_egdp_12m_6plus `wave0'_egdp_12m_5_6 `wave0'_egdp_12m_4_5 ///
				`wave0'_egdp_12m_3_4 `wave0'_egdp_12m_2_3 `wave0'_egdp_12m_1_2 `wave0'_egdp_12m_0_1 ///
				`wave0'_egdp_12m_neg1_0 `wave0'_egdp_12m_neg2_neg1 ///
				`wave0'_egdp_12m_neg2_neg3 ///
				 `wave0'_egdp_12m_neg3_neg4 `wave0'_egdp_12m_neg4_neg5 ///
				 `wave0'_egdp_12m_neg5_neg6 `wave0'_egdp_12m_moreneg6 ///
				{
				noisily di "`var'"
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm

 gen `wave0'_egdp_12m_implied_hold = `wave0'_egdp_12m_6plus*6 ///
								+ `wave0'_egdp_12m_5_6*5.5 ///
								+ `wave0'_egdp_12m_4_5*4.5 ///
								+ `wave0'_egdp_12m_3_4*3.5 ///
								+ `wave0'_egdp_12m_2_3*2.5 ///
								+ `wave0'_egdp_12m_1_2*1.5 ///
								+ `wave0'_egdp_12m_0_1*0.5 ///
								+ `wave0'_egdp_12m_neg1_0*(-0.5) ///
								+ `wave0'_egdp_12m_neg2_neg1*(-1.5) ///
								+ `wave0'_egdp_12m_neg2_neg3*(-2.5) ///
								+ `wave0'_egdp_12m_neg3_neg4*(-3.5) ///
								+ `wave0'_egdp_12m_neg4_neg5*(-4.5) ///
								+ `wave0'_egdp_12m_neg5_neg6*(-5.5) ///
								+ `wave0'_egdp_12m_moreneg6*(-6)
								
 gen `wave0'_egdp_12m_implied=`wave0'_egdp_12m_implied_hold /100
 
 





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
quiet foreach wave0 in w6 w7 {
foreach var0 in _12m_ _5y_ _ind_12m_ {
noisily di "uncertainty: `wave0': `var0'"
gen `wave0'_epi`var0'uncertainty_hold= ///
								  `wave0'_epi`var0'25plus*((25-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'15_25*((20-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'10_15*((12.5-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'8_10*((9-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'6_8*((7-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'4_6*((5-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'2_4*((3-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'0_2*((1-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'0_neg2*(((-1)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg2_neg4*(((-3)-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'neg4_neg6*(((-5)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg6_neg8*(((-7)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg8_neg10*(((-9)-`wave0'_epi`var0'implied)^2) ///
								+ `wave0'_epi`var0'neg10_neg15*(((-12.5)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'neg15_neg25*(((-20)-`wave0'_epi`var0'implied)^2) ///
								+`wave0'_epi`var0'moreneg25*(((-25)-`wave0'_epi`var0'implied)^2)

gen `wave0'_epi`var0'uncertainty=`wave0'_epi`var0'uncertainty_hold/100
gen `wave0'_epi`var0'std=sqrt(`wave0'_epi`var0'uncertainty)
}
}

******
quiet foreach wave0 in w6 w7 {
capture drop `wave0'_eue_12m_implied_hold

gen `wave0'_eue_12m_implied_hold = `wave0'_eue_12m_10plus*(10-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_9_10*(9.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_8_9*(8.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_7_8*(7.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_6_7*(6.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_5_6*(5.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_4_5*(4.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_3_4*(3.5-`wave0'_eue_12m_implied)^2 ///
								+ `wave0'_eue_12m_less3*(3-`wave0'_eue_12m_implied)^2
								
gen `wave0'_eue_12m_uncertainty =`wave0'_eue_12m_implied_hold/100
gen `wave0'_eue_12m_std=sqrt(`wave0'_eue_12m_uncertainty)
}

******
quiet foreach wave0 in w6 w7 {
capture drop `wave0'_egdp_12m_implied_hold 

 gen `wave0'_egdp_12m_implied_hold = `wave0'_egdp_12m_6plus*(6-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_5_6*(5.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_4_5*(4.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_3_4*(3.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_2_3*(2.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_1_2*(1.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_0_1*(0.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg1_0*(-0.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg2_neg1*(-1.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg2_neg3*(-2.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg3_neg4*(-3.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg4_neg5*(-4.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_neg5_neg6*(-5.5-`wave0'_egdp_12m_implied)^2 ///
								+ `wave0'_egdp_12m_moreneg6*(-6-`wave0'_egdp_12m_implied)^2
								
gen `wave0'_egdp_12m_uncertainty =`wave0'_egdp_12m_implied_hold/100
gen `wave0'_egdp_12m_std=sqrt(`wave0'_egdp_12m_uncertainty) 
 
}

*=========================================================================
*				compare moments across groups
*=========================================================================

tabstat w6_epi_12m, by(w6_group_rand_s) stat(N mean sd)
tabstat w6_epi_12m_std, by(w6_group_rand_s) stat(N mean sd)
tabstat  w6_epi_5y_implied, by(w6_group_rand_s) stat(N mean sd)
tabstat  w6_epi_5y_std, by(w6_group_rand_s) stat(N mean sd)

tabstat w6_pi_12m, by(w6_group_rand_s) stat(N mean sd)
