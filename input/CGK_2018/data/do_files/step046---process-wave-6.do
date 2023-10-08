clear all 
set more off

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

import excel using "Stage 6 Data_Variable Imports.xls", sheet("data_for_stata")  firstrow case(lower)

 
*========================================================= 

label var w6_main  "Q1. What is the main product of the firm?"
*=========================================================
 
label var w6_employment "Q2a. What is the total number of employees working at this firm?"
 
 
label var w6_employment_main "Q2b. How many employees are used for the main product or product line?"
 
*=========================================================
 

label var w6_firm_age "Q3. How many years old is the firm? "

*=========================================================
 
label var w6_actual_output_all "Q4a. $ value of the total amount produced by this firm over the last 12 months" 
 
label var w6_actual_output_main "Q4c. Output (main product) over the last 12 months" 

rename w6_potential_output_all w6_pot_output_all
label var w6_pot_output_all  "Q4b. $ value of the POTENTIAL amount produced by this firm over the last 12 months" 
 
rename w6_potential_output_main w6_pot_output_main 
label var w6_pot_output_main "Q4d. $ value of the POTENTIAL output (main product) by this firm over the last 12 months"

*=========================================================
 
label var w6_sales_nz ///
 "Q5. What % of the firm’s revenues in the last 12 months came from sales in New Zealand "

*========================================================= 
 
label var w6_competitors ///
 "Q6. How many direct competitors does the firm face in its main product line?"

*========================================================= 

label var w6_labor_cost_share "Q7. share of revenue used for compensation of all employees?"
 
label var w6_energy_cost_share "Q7. share of revenue used for energy costs?"
 
label var w6_materials_cost_share "Q7. share of revenue used used for the purchase of raw materials?"

*=========================================================


label var w6_price "Q8. What is the average selling price of this firm’s main product? (NZ)"

label var w6_price_foreign "Q8. What is the average selling price of this firm’s main product? (overseas)"

label var w6_overseas_curr "Q8. What is the currency for overseas sales?"


*=========================================================

label var w6_dp_main_6m "Q9. By how much has your firm changed the price of its main product over the last six months?"

label var w6_edp_main_6m "Q9. By how much do you think your firm will change the price of its main product over the next 6 months?"

label var w6_edp_main_12m "Q9. By how much do you think your firm will change the price of its main product over the next 12 months?"

*=========================================================

label var w6_dn_12m "Q10. By how much has your firm changed the it's number of employees over the last twelve months?"

label var w6_edn_6m "Q10. By how much do you think your firm will change it's number of employees over the next 6 months?"


*=========================================================
 
destring w6_dk_12m, replace force 
 
label var w6_dk_12m "Q11. Has your firm invested in new capital over the last twelve months?"

label var w6_edk_6m "Q11. Does your firm expect to invest in new capital over the next 6 months?"


*=========================================================

label var w6_dmc_12m "Q12. Has your firm experienced changes in unit costs over the last twelve months?"

label var w6_edmc_6m "Q12. How much do you think your firm's unit costs will change over the next 6 months?"


*=========================================================
label var w6_dw_12m "Q13. Has your firm experiences changes in average wages over the last twelve months?"

label var w6_edw_6m "Q13. How much do you think your firm's average wages will changeover the next 6 months?"


*=========================================================
label var w6_sales_12m "Q14. Has your firm experiences changes in number of units sold over the last twelve months?"
rename w6_sales_12m w6_dsales_12m

label var w6_esales_6m "Q14. How much do you think your firm's number of units sold will changeover the next 6 months?"
rename w6_esales_6m w6_edsales_6m

*=========================================================
 
label var w6_esales_12m_more25 "Q15. (25%+) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

label var w6_esales_12m_15_25 "Q15. (15-25%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

label var w6_esales_12m_5_15 "Q15. (5-15%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

rename w6_esales_neg5_5 w6_esales_12m_neg5_5
label var w6_esales_12m_neg5_5 "Q15. (-5-5%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

label var w6_esales_12m_neg15_neg5 "Q15. (-15--5%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

label var w6_esales_12m_neg25_neg15 "Q15. (-25--15%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

label var w6_esales_12m_moreneg25 "Q15. (-25%) Please assign probabilities to the following ranges of growth rates for the number of units sold of your main product line or service over the next 12 months"

*=========================================================
rename w6_dp_cust_exp w6_edp_cust_12m
label var w6_edp_cust_12m "Q16. By how much do you think your customers expect your firm to change the price of its main product over the next twelve months?"
*===========================================================
label var w6_dp_now "Q17. If this firm was free to change its price right now, by how much would change its price?"

label var w6_dy_dp_now "Q17. By how much do you think profits would change as a share of revenues?" 

*===========================================================
label var w6_dp_comp_10p_p "Q18a. Prices up 10%: By what percentage do you think your competitors would raise their prices on average?"

label var w6_dp_10p_p  "Q18b. Prices up 10%: By what would your firm raise its price on average?"

label var  w6_dp_nocomp_10p_p "Q18c. Prices up 10%: c. By what percentage would your firm raise its price if your competitors did not change their price at all in response to this news? "

*===========================================================

label var w6_dp_vcomp_10p_d "Q19. Demand up 10%: How much would your firm like to change its price relative to competitors?"

*=========================================================
label var w6_stocks "Q20. (Stocks) What is the approximate breakdown of your assets between...?"

label var w6_bonds "Q20. (Bonds) What is the approximate breakdown of your assets between...?"

label var w6_infl_prot_bond "Q20a. (Inflation Protected Bonds) What is the approximate breakdown of your assets between...?"

label var w6_cash  "Q20. (Cash) What is the approximate breakdown of your assets between...?"

label var w6_realestate "Q20. (Real Estate) What is the approximate breakdown of your assets between...?"

label var w6_prec_comm "Q20. (Precious Commodities) What is the approximate breakdown of your assets between...?"

label var w6_other_assets "Q20. (Other) What is the approximate breakdown of your assets between...?"

*=========================================================
label var w6_speed_dp_growth "21. When overall prices in the economy are rising faster than typical, do you think"

replace w6_speed_dp_growth="1" if  w6_speed_dp_growth=="a"
replace w6_speed_dp_growth="2" if  w6_speed_dp_growth=="b"
replace w6_speed_dp_growth="3" if  w6_speed_dp_growth=="c"

destring w6_speed_dp_growth, replace force

label define lb_w6_speed_dp_growth ///
	1 "Faster than typical economic growth" ///
	2 "Slower than typical economic growth" ///
	3 "No systematic connection to the rate of economic growth"

label values w6_speed_dp_growth lb_w6_speed_dp_growth
label var w6_group_rand "Group 1 or 2"


*=========================================================

label var w6_pi_12m "Q22. During the last 12 months, by how much do you think prices changed overall in the economy?  "

label var w6_epi_12m "Q23. During the next 12 months, by how much do you think prices will change overall in the economy?  "

*=========================================================


label var w6_epi_12m_25plus "Q24.(25%+) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_15_25 "Q24.(15-25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_10_15 "Q24.(10-15%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_8_10 "Q24.(8-10%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_6_8 "Q24.(6-8%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_4_6 "Q24.(4-6%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_2_4 "Q24.(2-4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_2 "Q24.(0-2%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_neg2 "Q24.(0--2%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg2_neg4 "Q24. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg4_neg6 "Q24.(-4--6%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg6_neg8 "Q24.(-6--8%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg8_neg10 "Q24.(-8--10%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg10_neg15 "Q24.(-10--15%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg15_neg25 "Q24.(-15--25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_moreneg25 "Q24.(more-25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"






*=========================================================

label var w6_epi_lt_25plus "Q25.(25%+) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_15_25 "Q25.(15-25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_10_15 "Q25.(10-15%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_8_10 "Q25.(8-10%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_6_8 "Q25.(6-8%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_4_6 "Q25.(4-6%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_2_4 "Q25.(2-4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_0_2 "Q25.(0-2%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_0_neg2 "Q25.(0--2%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg2_neg4 "Q25. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg4_neg6 "Q25.(-4--6%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg6_neg8 "Q25.(-6--8%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg8_neg10 "Q25.(-8--10%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg10_neg15 "Q25.(-10--15%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_neg15_neg25 "Q25.(-15--25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"

label var w6_epi_lt_moreneg25 "Q25.(more-25%) Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 5-10 years for New Zealand"


foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w6_epi_lt`var' w6_epi_5y`var'
}
	

*=========================================================

label var w6_epi_12m_25plus_ho "Q26.(25%+) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_15_25_ho "Q26.(15-25%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_10_15_ho "Q26.(10-15%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_8_10_ho "Q26.(8-10%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_6_8_ho "Q26.(6-8%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_4_6_ho "Q26.(4-6%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_2_4_ho "Q26.(2-4%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_2_ho "Q26.(0-2%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_neg2_ho "Q26.(0--2%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg2_neg4_ho "Q26. (-2--4%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg4_neg6_ho "Q26.(-4--6%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg6_neg8_ho "Q26.(-6--8%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg8_neg10_ho "Q26.(-8--10%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg10_neg15_ho "Q26.(-10--15%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg15_neg25_ho "Q26.(-15--25%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_moreneg25_ho "Q26.(more-25%) OTHER MANAGERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w6_epi_12m`var'_ho w6_epi_ho_12m`var'
}
	
	
	
*=========================================================

label var w6_epi_12m_25plus_cust "Q27.(25%+) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_15_25_cust "Q27.(15-25%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_10_15_cust "Q27.(10-15%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_8_10_cust "Q27.(8-10%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_6_8_cust "Q27.(6-8%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_4_6_cust "Q27.(4-6%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_2_4_cust "Q27.(2-4%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_2_cust "Q27.(0-2%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_0_neg2_cust "Q27.(0--2%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg2_neg4_cust "Q27. (-2--4%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg4_neg6_cust "Q27.(-4--6%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg6_neg8_cust "Q27.(-6--8%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg8_neg10_cust "Q27.(-8--10%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg10_neg15_cust "Q27.(-10--15%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_neg15_neg25_cust "Q27.(-15--25%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

label var w6_epi_12m_moreneg25_cust "Q27.(more-25%) CUSTOMERS Please assign probabilities (from 0-100) to the following ranges of overall price changes in the economy over the next 12 months for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w6_epi_12m`var'_cust w6_epi_cust_12m`var'
}

*=========================================================


label var w6_eindp_12m_25plus "Q28.(25%+) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_15_25 "Q28.(15-25%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_10_15 "Q28.(10-15%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_8_10 "Q28.(8-10%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry priceover the next 12 months for New Zealand"

label var w6_eindp_12m_6_8 "Q28.(6-8%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_4_6 "Q28.(4-6%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_2_4 "Q28.(2-4%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_0_2 "Q28.(0-2%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_0_neg2 "Q28.(0--2%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg2_neg4 "Q28. (-2--4%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg4_neg6 "Q28.(-4--6%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg6_neg8 "Q28.(-6--8%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg8_neg10 "Q28.(-8--10%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg10_neg15 "Q28.(-10--15%) Please assign probabilities (from 0-100) to the following ranges of ooverall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_neg15_neg25 "Q28.(-15--25%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

label var w6_eindp_12m_moreneg25 "Q28.(more-25%) Please assign probabilities (from 0-100) to the following ranges of overall change in industry price over the next 12 months for New Zealand"

foreach var in _25plus  _15_25  _10_15  _8_10  _6_8  _4_6  _2_4  _0_2  _0_neg2  _neg2_neg4  _neg4_neg6  _neg6_neg8 _neg8_neg10  _neg10_neg15  _neg15_neg25 _moreneg25 { 
	rename w6_eindp_12m`var' w6_epi_ind_12m`var'
}

*=========================================================


label var w6_egdp_12m_6plus "Q29. (6%+) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_5_6 "Q29. (5-6%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_4_5 "Q29. (4-5%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_3_4 "Q29. (3-4%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_2_3 "Q29. (2-3%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_1_2 "Q29. (1-2%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_0_1 "Q29. (0-1%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var w6_egdp_12m_neg1_0 "Q29. (-1-0%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_neg2_neg1 "Q29. (-1--2%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_neg2_neg3 "Q29. (-2--3%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_neg3_neg4 "Q29. (-3--4%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_neg4_neg5 "Q29. (-4--5%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"

label var  w6_egdp_12m_neg5_neg6 "Q29. (-5--6%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"


label var  w6_egdp_12m_moreneg6 "Q29. (less than-6%) Please assign probabilities (from 0-100) to the following ranges of growth rates of the overall economy (real GDP) over the next 12 months"
     



*=========================================================

label var w6_ueu_12m_10plus "Q30. (10%+) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w6_ueu_12m_9_10 "Q30. (9-10%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w6_ueu_12m_8_9 "Q30. (8-9%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w6_ueu_12m_7_8 "Q30. (7-8%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w6_ueu_12m_6_7 "Q30. (6-7%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w6_ueu_12m_5_6 "Q30. (5-6%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w6_ueu_12m_4_5 "Q30. (4-5%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var  w6_ueu_12m_3_4 "Q30. (3-4%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

label var w6_ueu_12m_less3 "Q30. (Less than 3%) Please assign probabilities (from 0-100) to the following ranges for what the unemployment rate might be in 12 months in New Zealand"

foreach var in _10plus _9_10 _8_9 _7_8 _6_7 _5_6 _4_5 _3_4 _less3 {

	rename w6_ueu_12m`var' w6_eue_12m`var'
}



*=========================================================

//Group 1

label var w6_emc_gr1_12m_lessneg1 "Q31 - 1. (less than -1%) Projecting ahead, to the best of your ability, please assign a percent likelihood to the following changes to unit costs over the next twelve months "

label var  w6_emc_gr1_12m_neg1_1 "Q31 - 1. (-1%-1%) Projecting ahead, to the best of your ability, please assign a percent likelihood to the following changes to unit costs over the next twelve months "

label var  w6_emc_gr1_12m_1_3 "Q31 - 1. (1%-3%) Projecting ahead, to the best of your ability, please assign a percent likelihood to the following changes to unit costs over the next twelve months "

label var  w6_emc_gr1_12m_3_5 "Q31 - 1. (3%-5%) Projecting ahead, to the best of your ability, please assign a percent likelihood to the following changes to unit costs over the next twelve months "

rename w6_emc_gr1_12m_more6 w6_emc_gr1_12m_more5
label var  w6_emc_gr1_12m_more5 "Q31 - 1. (more than 5%) Projecting ahead, to the best of your ability, please assign a percent likelihood to the following changes to unit costs over the next twelve months "



*=========================================================


label var w6_ecore_gr1_12m_4plus "Q32 - 1. (more than 4%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var  w6_ecore_gr1_12m_3p5_3p9 "Q32 - (3.5-3.9%) 1. Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var  w6_ecore_gr1_12m_3_3p4 "Q32 - 1. (3.0-3.4%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var  w6_ecore_gr1_12m_2p5_2p9 "Q32 - 1. (2.5-2.9%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_2_2p4 "Q32 - 1. (2.0-2.4%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_1p5_1p9 "Q32 - 1. (1.5-1.9%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_1_1p4 "Q32 - 1. (1.0-1.4%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_0p5_0p6 "Q32 - 1. (0.5-0.6%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_0_0p4 "Q32 - 1. (0.0-0.4%) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

label var w6_ecore_gr1_12m_less0 "Q32 - 1. (Will decline) Please indicate what probabilities you would attach to the various possible percentage changes to the CORE (excluding food and energy) CONSUMER PRICE INDEX over the next twelve months (values should sum to 100%)."

*=========================================================

//Group2

label var w6_emc_gr2_12m_25plus "Q31 - 2.(25%+) Please assign probabilities (from 0-100) to the following changes in unit costs over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_15_25 "Q31 - 2.(15-25%) Please assign probabilities (from 0-100) to the following changes in unit costs over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_10_15 "Q31 - 2.(10-15%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_8_10 "Q31 - 2.(8-10%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_6_8 "Q31 - 2.(6-8%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_4_6 "Q31 - 2.(4-6%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_2_4 "Q31 - 2.(2-4%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_0_2 "Q31 - 2.(0-2%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_0_neg2 "Q31 - 2.(0--2%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg2_neg4 "Q31 - 2. (-2--4%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg4_neg6 "Q31 - 2.(-4--6%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg6_neg8 "Q31 - 2.(-6--8%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg8_neg10 "Q31 - 2.(-8--10%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg10_neg15 "Q31 - 2.(-10--15%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_neg15_neg25 "Q31 - 2.(-15--25%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"

label var w6_emc_gr2_12m_moreneg25 "Q31 - 2.(more-25%) Please assign probabilities (from 0-100) to the following changes in unit costs  over the next 12 months for New Zealand"





*=========================================================


label var w6_ecore_gr2_12m_25plus "Q32 - 2.(25%+) Please assign probabilities (from 0-100) to the following changes in core CPI inflation over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_15_25 "Q32 - 2.(15-25%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation  over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_10_15 "Q32 - 2.(10-15%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_8_10 "Q32 - 2.(8-10%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_6_8 "Q32 - 2.(6-8%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation  over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_4_6 "Q32 - 2.(4-6%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_2_4 "Q32 - 2.(2-4%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_0_2 "Q32 - 2.(0-2%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_0_neg2 "Q32 - 2.(0--2%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg2_neg4 "Q32 - 2. (-2--4%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg4_neg6 "Q32 - 2.(-4--6%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg6_neg8 "Q32 - 2.(-6--8%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg8_neg10 "Q32 - 2.(-8--10%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg10_neg15 "Q32 - 2.(-10--15%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_neg15_neg25 "Q32 - 2.(-15--25%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"

label var w6_ecore_gr2_12m_moreneg25 "Q32 - 2.(more-25%) Please assign probabilities (from 0-100) to the following changes in core CPI inflation   over the next 12 months for New Zealand"





*=========================================================

label var w6_rbnz_target "Q33.  What annual percentage rate of change in overall prices do you think the Reserve Bank of New Zealand is trying to achieve?"

*=========================================================

//Experiment

label var w6_epi_12m_exper "Q34. During the next twelve months, by how much do you think prices will change overall in the economy?"
rename w6_epi_12m_exper w6_epi_exper_12m

*=========================================================
label var w6_epi_lt_exper "Q35. Over the five-ten years, by what average annual rate do you think prices will change overall in the economy?"
rename w6_epi_lt_exper w6_epi_exper_5y

*=========================================================
label var  w6_egdp_12m_exper "Q36. What do you think will be the annual growth rate of real GDP in New Zealand in twelve months? "
rename w6_egdp_12m_exper w6_egdp_exper_12m

*=========================================================
label var  w6_eue_12m_exper "Q37. In twelve months, what do you think the unemployment rate will be in New Zealand? "
rename w6_eue_12m_exper w6_eue_exper_12m

*=========================================================
label var w6_epi_12m_ho_exper "Q38. What do you think other managers of firms believe will be the growth rate of overall prices in the New Zealand economy over the next twelve months?  "
rename w6_epi_12m_ho_exper w6_epi_ho_exper_12m

*=========================================================
label var  w6_edp_ind_12m_exper "Q39. During the next twelve months, by how much do you think prices in your industry will change?"
rename w6_edp_ind_12m_exper w6_epi_ind_exper_12m

*=========================================================
label var  w6_edp_12m_cust_exper "Q40. By how much do you think your customers expect overall prices in the economy to change over the next twelve months?"
rename w6_edp_12m_cust_exper w6_epi_cust_exper_12m

*=========================================================
label var  w6_edp_main_exper "Q41. During the next twelve months, by how much do you think the price of your main product is going to change? "
rename w6_edp_main_exper w6_edp_exper_main_12m

*=========================================================

****cd "C:\Dropbox\Firm Survey\Stata_cleaned\workfiles"
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
compress
notes: "process wave 6"

rename firmid w6_firmid
gen firmid=w6_firmid if w6newfirm=="Old Firm"

replace firmid=10000+w6_firmid if w6newfirm=="New Firm"

foreach var in anzsiccode industry sic_description  {
	rename `var' w6_`var'
}
drop 	trading_name
save wave6, replace
