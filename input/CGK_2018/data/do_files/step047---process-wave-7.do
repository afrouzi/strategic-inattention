clear all 
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

import excel using "Stage 6 follow-up.xls", sheet("data_for_stata")  firstrow case(lower)

	
gen firmid=w6_firmid if w6newfirm=="Old Firm"

replace firmid=10000+w6_firmid if w6newfirm=="New Firm"
* save wave6, replace

label var w6_firmid "Firm ID"	

label var anzsic_cod "ANZSIC Code"
rename  anzsic_cod w7_anzsic_cod

label var w6newfirm "Firm is new in Wave 6"
rename w6newfirm w6_newfirm


label var sic_description "SIC Description"
rename sic_description w7_sic_description

label var trading_name "Trading Name"
rename trading_name w7_trading_name

label var group "Group Divisions"
rename group w7_group

rename w6fu_* w7_*

label var w7_industry "Firm's Industry"

*=================================================================================*


label var w7_epi_12m "Q1. Expected inflation in the next 12 months"

label var w7_epi_lt "Q2. Expected inflation in the next 5-10 years"
rename w7_epi_lt w7_epi_5y

label var w7_egdp_12m "Q3. Expected Real GDP Growth in the next 12 months"

label var w7_eue_12m "Q4. Expected Unemployment in the next 12 months"

label var w7_epi_12m_ho "Q5. Other Managers Expected inflation in the next 12 months"
rename w7_epi_12m_ho w7_epi_ho_12m

label var w7_eindp_12m "Q6. Expected industry price changes in the next 12 months"
rename w7_eindp_12m w7_epi_ind_12m

label var w7_edp_12m_cust "Q7. Customers' expected price changes in the next 12 months"
rename w7_edp_12m_cust w7_epi_cust_12m


*====================================================================================*

label var w7_dp_main_6m "Q8a. Main product price change in the last 6 months"

label var w7_edp_main_6m "Q8b. Expected main product price change in the next 6 months"

label var w7_edp_main_12m "Q8c. Expected main product price change in the next 12 months"


*====================================================================================*
rename w7_dworker_6m w7_dn_6m
label var w7_dn_6m "Q9a. Change in the number of workers in the last 6 months"

rename w7_edworker_6m w7_edn_6m
label var w7_edn_6m "Q9b. Expected change in the number of workers in the next 6 months"

*====================================================================================*
rename w7_dinv_6m  w7_dk_6m
label var w7_dk_6m "Q10a. Change in investment in the last 6 months"

rename w7_edinv_6m w7_edk_6m
label var w7_edk_6m "Q10b. Expected change in investment in the next 6 months"

*====================================================================================*

label var w7_mc_6m "Q11a. Change in unit cost in the last 6 months"
rename w7_mc_6m w7_dmc_6m
label var w7_emc_6m "Q11b. Expected change in unit cost in the next 6 months"
rename w7_emc_6m w7_edmc_6m
*====================================================================================*

label var w7_dw_6m "Q12a. Change in wages in the last 6 months"

label var w7_edw_6m "Q12b. Expected change in wages in the next 6 months"

*====================================================================================*

label var w7_dsales_6m "Q13a. Change in unit sales in the last 6 months"

rename w7_esales_6m w7_edsales_6m
label var w7_edsales_6m "Q13b. Expected change in unit sales in the next 6 months"
destring w7_edsales_6m, force replace

*====================================================================================*


label var w7_epi_12m_25plus "Q14.(25%+)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_15_25 "Q14.(15-25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_10_15 "Q14.(10-15%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_8_10 "Q14.(8-10%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_6_8 "Q14.(6-8%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_4_6 "Q14.(4-6%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_2_4 "Q14.(2-4%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_2 "Q14.(0-2%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_neg2 "Q14.(0--2%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg2_neg4 "Q14. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg4_neg6 "Q14.(-4--6%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg6_neg8 "Q14.(-6--8%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg8_neg10 "Q14.(-8--10%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg10_neg15 "Q14.(-10--15%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg15_neg25 "Q14.(-15--25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_moreneg25 "Q14.(more-25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

*=========================================================

label var w7_epi_lt_25plus "Q15.(25%+)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_15_25 "Q15.(15-25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_10_15 "Q15.(10-15%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_8_10 "Q15.(8-10%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_6_8 "Q15.(6-8%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_4_6 "Q15.(4-6%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_2_4 "Q15.(2-4%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_0_2 "Q15.(0-2%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_0_neg2 "Q15.(0--2%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg2_neg4 "Q15. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg4_neg6 "Q15.(-4--6%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg6_neg8 "Q15.(-6--8%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg8_neg10 "Q15.(-8--10%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg10_neg15 "Q15.(-10--15%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_neg15_neg25 "Q15.(-15--25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w7_epi_lt_moreneg25 "Q15.(more-25%)	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w7_epi_lt`var' w7_epi_5y`var'
}

*=========================================================


label var w7_epi_12m_25plus_ho "Q16.(25%+) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_15_25_ho "Q16.(15-25%) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_10_15_ho "Q16.(10-15%) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_8_10_ho "Q16.(8-10%) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_6_8_ho "Q16.(6-8%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_4_6_ho "Q16.(4-6%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_2_4_ho "Q16.(2-4%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_2_ho "Q16.(0-2%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_neg2_ho "Q16.(0--2%) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg2_neg4_ho "Q16. (-2--4%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg4_neg6_ho "Q16.(-4--6%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg6_neg8_ho "Q16.(-6--8%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg8_neg10_ho "Q16.(-8--10%) OTHER MANAGERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg10_neg15_ho "Q16.(-10--15%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg15_neg25_ho "Q16.(-15--25%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_moreneg25_ho "Q16.(more-25%)	OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w7_epi_12m`var'_ho w7_epi_ho_12m`var'
}

*=========================================================


label var w7_epi_12m_25plus_cust "Q17.(25%+) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_15_25_cust "Q17.(15-25%) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_10_15_cust "Q17.(10-15%) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_8_10_cust "Q17.(8-10%) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_6_8_cust "Q17.(6-8%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_4_6_cust "Q17.(4-6%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_2_4_cust "Q17.(2-4%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_2_cust "Q17.(0-2%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_0_neg2_cust "Q17.(0--2%) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg2_neg4_cust "Q17. (-2--4%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg4_neg6_cust "Q17.(-4--6%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg6_neg8_cust "Q17.(-6--8%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg8_neg10_cust "Q17.(-8--10%) CUSTOMERS	Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg10_neg15_cust "Q17.(-10--15%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_neg15_neg25_cust "Q17.(-15--25%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w7_epi_12m_moreneg25_cust "Q17.(more-25%)	CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"


foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w7_epi_12m`var'_cust w7_epi_cust_12m`var'
}

*=========================================================

label var w7_eindp_12m_25plus "Q18.(25%+)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_15_25 "Q18.(15-25%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_10_15 "Q18.(10-15%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_8_10 "Q18.(8-10%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry priceover the next 12 months for New Zealand"

label var w7_eindp_12m_6_8 "Q18.(6-8%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_4_6 "Q18.(4-6%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_2_4 "Q18.(2-4%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_0_2 "Q18.(0-2%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_0_neg2 "Q18.(0--2%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg2_neg4 "Q18. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg4_neg6 "Q18.(-4--6%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg6_neg8 "Q18.(-6--8%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg8_neg10 "Q18.(-8--10%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg10_neg15 "Q18.(-10--15%)	Please assign probabilities (from 0-100) to the following ranges of ooverall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_neg15_neg25 "Q18.(-15--25%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w7_eindp_12m_moreneg25 "Q18.(more-25%)	Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w7_eindp_12m`var' w7_epi_ind_12m`var'
}
*=========================================================


label var w7_egdp_12m_6plus "Q19. (6%+)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_5_6 "Q19. (5-6%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_4_5 "Q19. (4-5%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_3_4 "Q19. (3-4%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_2_3 "Q19. (2-3%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_1_2 "Q19. (1-2%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_0_1 "Q19. (0-1%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var w7_egdp_12m_neg1_0 "Q19. (-1-0%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_neg2_neg1 "Q19. (-1--2%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_neg2_neg3 "Q19. (-2--3%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_neg3_neg4 "Q19. (-3--4%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_neg4_neg5 "Q19. (-4--5%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_neg5_neg6 "Q19. (-5--6%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w7_egdp_12m_moreneg6 "Q19. (less than-6%)	Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"
		   

*=========================================================


label var w7_eue_12m_10plus "Q20.	(10%+) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w7_eue_12m_9_10 "Q20.	(9-10%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w7_eue_12m_8_9 "Q20.	(8-9%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w7_eue_12m_7_8 "Q20.	(7-8%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w7_eue_12m_6_7 "Q20.	(6-7%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w7_eue_12m_5_6 "Q20.	(5-6%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w7_eue_12m_4_5 "Q20.	(4-5%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w7_eue_12m_3_4 "Q20.	(3-4%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w7_eue_12m_less3 "Q20.	(Less than 3%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"


*=========================================================


label var w7_rbnz_target "Q21.	 What annual percentage rate of change in overall prices do you think the Reserve Bank of New Zealand is trying to achieve?"

*=========================================================



cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
compress
notes: "process wave 7"

drop w7_trading_name

destring w7_epi_ho_12m_neg15_neg25, force replace

save wave7, replace

use wave7, clear
keep w7_anzsic_cod firmid 
rename w7_anzsic_cod anzsic_code
save ANZSICcodes_w7, replace
