clear all 

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

import excel using ///
	"Stage 4 Data.xlsx", ///
	sheet("Data")  firstrow cellrange(A4)

	
*=========================================================	
rename q1 w4_pii_12m
label var w4_pii_12m ///
	"Q1. During the last twelve months, by how much do you think prices have changed in your industry"
*=========================================================
	
rename q2 w4_epii_12m
label var w4_epii_12m ///
	"Q2. 2.	During the next twelve months, by how much do you think prices will change in your industry?"
*=========================================================
	
rename q3 w4_RBNZ_obj
label var w4_RBNZ_obj ///
	"Q3. What is the main objective of the Reserve Bank"

replace w4_RBNZ_obj="1" if w4_RBNZ_obj=="a"
replace w4_RBNZ_obj="2" if w4_RBNZ_obj=="b"
replace w4_RBNZ_obj="3" if w4_RBNZ_obj=="c"
replace w4_RBNZ_obj="4" if w4_RBNZ_obj=="d"
replace w4_RBNZ_obj="5" if w4_RBNZ_obj=="e"


destring w4_RBNZ_obj, replace force

label define w4_RBNZ_obj0 ///
	1 "a. Keep the exchange rate stable" ///
    2 "b. Promote full employment" ///
	3 "c. Keep interest rates low and stable" /// 
	4 "d. Keep inflation low and stable" ///
	5 "e. Help the government finance its spending"

label values w4_RBNZ_obj w4_RBNZ_obj0

*=========================================================
	
rename q4 w4_RBNZ_target
label var w4_RBNZ_target ///
	"Q4. What annual % rate of change in overall prices do you think RBNZ is trying to achieve"	
*=========================================================
	
rename q5 w4_RBNZ_governor
label var w4_RBNZ_governor ///
	"Q5. What is the name of the Governor of the Reserve Bank of New Zealand"	

replace w4_RBNZ_governor="Graeme Wheeler (correct)" if w4_RBNZ_governor=="Graeme"	
replace w4_RBNZ_governor="Alan Bollard (past: up to 2012)" if w4_RBNZ_governor=="Alan"	
replace w4_RBNZ_governor="Bill English" if w4_RBNZ_governor=="Bill"	
replace w4_RBNZ_governor="Charles Cowley" if w4_RBNZ_governor=="Charles"	
replace w4_RBNZ_governor="do not know" if w4_RBNZ_governor=="I dont know"	

tab w4_RBNZ_governor	
	

*=========================================================	

rename q6 w4_pi_12m
label var w4_pi_12m ///
	"Q6. During the last twelve months, by how much do you think prices have changed overall in the economy? "

*=========================================================

rename q7 w4_gdp_12m
label var w4_gdp_12m ///
	"Q7. What do you think the real GDP growth rate has been in New Zealand during the last 12 months?"

*=========================================================

rename q8 w4_ue
label var w4_ue ///
	"Q8.	What do you think the unemployment rate currently is in New Zealand?"

*=========================================================

rename q9a w4_epi_12m_25plus
rename q9b w4_epi_12m_15_25
rename q9c w4_epi_12m_10_15
rename q9d w4_epi_12m_8_10
rename q9e w4_epi_12m_6_8
rename q9f w4_epi_12m_4_6
rename q9g w4_epi_12m_2_4
rename q9h w4_epi_12m_0_2
rename q9i w4_epi_12m_0_minus

foreach var in 25plus 15_25 10_15 8_10 6_8 4_6 2_4 0_2 0_minus {
	label var w4_epi_12m_`var' ///
		"Assign probabilitiesto the following ranges of inflation in NZ: `var'"
}

*=========================================================

rename q10a w4_egdp_12m_5plus
rename q10b w4_egdp_12m_4_5
rename q10c w4_egdp_12m_3_4
rename q10d w4_egdp_12m_2_3
rename q10e w4_egdp_12m_1_2
rename q10f w4_egdp_12m_0_1
rename q10g w4_egdp_12m_0_minus


foreach var in 5plus 4_5 3_4 2_3 1_2 0_1 0_minus {
	label var w4_egdp_12m_`var' ///
		"Assign probabilitiesto the following ranges of GDP growth in NZ: `var'"
}
		

*=========================================================

rename q11a w4_eue_12m_8plus
rename q11b w4_eue_12m_7_8
rename q11c w4_eue_12m_6_7
rename q11d w4_eue_12m_5_6
rename q11e w4_eue_12m_4_5
rename q11f w4_eue_12m_4_minus


foreach var in 8plus 7_8 6_7 5_6 4_5 4_minus{
	label var w4_eue_12m_`var' ///
		"Assign probabilitiesto the following ranges of unemployment rate in NZ: `var'"
}
				
*=========================================================
rename q12a w4_epi_12m_treatment
label var w4_epi_12m_treatment ///
		"Q12. Provide firms with more information"
		
label define w4_epi_12m_treatment0 ///
	1 "no additional information" ///
    2 "professional forecasters" ///
	3 "professional forecasters + RBNZ target" /// 
	4 "RBNZ target" ///
	5 "past inflation" ///
	6 "forecasts of other firms in your industry"
label values w4_epi_12m_treatment w4_epi_12m_treatment0
	
*=========================================================
rename q12b w4_epi_12m_treated
label var w4_epi_12m_treated ///
		"Q12. Inflation forecast after treatment"
	
	
*=========================================================
rename q13a w4_egdp_12m_treated
label var w4_egdp_12m_treated ///
		"Q13. GDP over next 12 months: Provide firms with more information"
	
rename q13b w4_egdp_12m_control
label var w4_egdp_12m_control ///
		"Q13. GDP over next 12 months:  Provide firms with no information"
		

*=========================================================
rename q14a w4_eue_12m_treated
label var w4_eue_12m_treated ///
		"Q14. Unemployment rate in 12 months: Provide firms with more information"
	
rename q14b w4_eue_12m_control
label var w4_eue_12m_control ///
		"Q14. Unemployment rate in 12 months:  Provide firms with no information"
		

*=========================================================
rename q15a w4_track_ue
label var w4_track_ue ///
		"Q15. Macro var firms care about/track most closely: rank unemployment rate"
replace w4_track_ue="" if w4_track_ue=="none"
destring w4_track_ue, replace force
	
rename q15b w4_track_gdp
label var w4_track_gdp ///
		"Q15. Macro var firms care about/track most closely: rank GDP"
replace w4_track_gdp="" if w4_track_gdp=="none"
destring w4_track_gdp, replace force
	
rename q15c w4_track_pi
label var w4_track_pi ///
		"Q15. Macro var firms care about/track most closely: rank inflation"
replace w4_track_pi="" if w4_track_pi=="none"
destring w4_track_pi, replace force	
		
		
*=========================================================
rename q16a w4_track_uef
label var w4_track_uef ///
		"Q16. Macro var YOU care about/track most closely: rank unemployment rate"
replace w4_track_uef="" if w4_track_uef=="none"
replace w4_track_uef="1" if w4_track_uef=="yes"
replace w4_track_uef="0" if w4_track_uef=="no"
destring w4_track_uef, replace force
	
rename q16b w4_track_gdpf
label var w4_track_gdpf ///
		"Q16. Macro var YOU care about/track most closely: rank GDP"
replace w4_track_gdpf="" if w4_track_gdpf=="none"
replace w4_track_gdpf="1" if w4_track_gdpf=="yes"
replace w4_track_gdpf="0" if w4_track_gdpf=="no"
destring w4_track_gdpf, replace force
	
rename q16c w4_track_pif
label var w4_track_pif ///
		"Q16. Macro var YOU care about/track most closely: rank inflation"
replace w4_track_pif="" if w4_track_pif=="none"
replace w4_track_pif="1" if w4_track_pif=="yes"
replace w4_track_pif="0" if w4_track_pif=="no"
destring w4_track_pif, replace force		


*=========================================================
rename q161a w4_track_time3
label var w4_track_time3 ///
		"Q16. How do you acquire information about macroeconomic variables"

replace w4_track_time3="1" if w4_track_time3=="a"
replace w4_track_time3="2" if w4_track_time3=="b"
replace w4_track_time3="3" if w4_track_time3=="c"
replace w4_track_time3="4" if w4_track_time3=="d"
replace w4_track_time3="5" if w4_track_time3=="e"
destring w4_track_time3, replace force
		
label define w4_track_time0 ///
	1 "I try to look at all these indictors at the same time" ///
    2 "I try to look at unemployment and GDP together" ///
	3 "I try to look at unemployment and inflation together" /// 
	4 "I try to look at inflation and GDP together" ///
	5 "I look at each of these variables separately" 
	
label values w4_track_time3 w4_track_time0

*=========================================================
rename q161b w4_track_time2
label var w4_track_time2 ///
		"Q16. How do you acquire information about macroeconomic variables"

replace w4_track_time2="1" if w4_track_time2=="a"
replace w4_track_time2="2" if w4_track_time2=="b"
destring w4_track_time2, replace force
		
label define w4_track_time20 ///
	1 "I try to look at both indictors at the same time" ///
	2 "I look at each of these variables separately" 
	
label values w4_track_time2 w4_track_time20	

*=========================================================
rename q17 w4_pay_pi
label var w4_pay_pi ///
		"Q17. pay $/year for access to monthly forecasts of future inflation"
replace w4_pay_pi="" if w4_pay_pi=="none"
destring w4_pay_pi, replace force

rename q18 w4_pay_gdp
label var w4_pay_gdp ///
		"Q18. pay $/year for access to monthly forecasts of future GDP"
replace w4_pay_gdp="" if w4_pay_gdp=="none"
destring w4_pay_gdp, replace force
	
rename q19 w4_pay_ue
label var w4_pay_ue ///
		"Q19. pay $/year for access to monthly forecasts of future unemployment rate"
replace w4_pay_ue="" if w4_pay_ue=="none"
destring w4_pay_ue, replace force

*=========================================================
rename q20 w4_ssatt_good
label var w4_ssatt_good ///
		"Q20. Economy is doing well. Would it make you more likely to look for more information? "

replace w4_ssatt_good="1" if w4_ssatt_good=="a"
replace w4_ssatt_good="2" if w4_ssatt_good=="b"
replace w4_ssatt_good="3" if w4_ssatt_good=="c"
replace w4_ssatt_good="4" if w4_ssatt_good=="d"
replace w4_ssatt_good="5" if w4_ssatt_good=="e"
destring w4_ssatt_good, replace force
		
label define w4_ssatt_good0 ///
	1 "a.	Much more likely" ///
    2 "b.	Somewhat more likely" ///
	3 "c.	No change" /// 
	4 "d.	Somewhat less likely" ///
	5 "e.	Much less likely" 
	
label values w4_ssatt_good w4_ssatt_good0	

*=========================================================
rename q21 w4_ssatt_bad
label var w4_ssatt_bad ///
		"Q21. Economy is doing poorly. Would it make you more likely to look for more information? "

replace w4_ssatt_bad="1" if w4_ssatt_bad=="a"
replace w4_ssatt_bad="2" if w4_ssatt_bad=="b"
replace w4_ssatt_bad="3" if w4_ssatt_bad=="c"
replace w4_ssatt_bad="4" if w4_ssatt_bad=="d"
replace w4_ssatt_bad="5" if w4_ssatt_bad=="e"
destring w4_ssatt_bad, replace force
		
label define w4_ssatt_bad0 ///
	1 "a.	Much more likely" ///
    2 "b.	Somewhat more likely" ///
	3 "c.	No change" /// 
	4 "d.	Somewhat less likely" ///
	5 "e.	Much less likely" 
	
label values w4_ssatt_bad w4_ssatt_bad0	
	
	
*=========================================================
rename q22 w4_price_complementarity
label var w4_price_complementarity ///
		"Q22. Suppose a firm in your indus. cuts its price by 10%. By how much would YOUR sales be affected?"

*=========================================================
rename q23 w4_info_complementarity
label var w4_info_complementarity ///
		"Q23. Suppose that there are two sources of information about the state of the economy."

replace w4_info_complementarity="1" if w4_info_complementarity=="a"
replace w4_info_complementarity="2" if w4_info_complementarity=="b"
destring w4_info_complementarity, replace force
		
label define w4_info_complementarity0 ///
	1 "The source that can be seen by other firms" ///
    2 "The source that can be seen only by you" 
	
label values w4_info_complementarity w4_info_complementarity0	
	
*=========================================================
rename q24 w4_info_complementarity2
label var w4_info_complementarity2 ///
		"Q24. Your main competitor raises the price by 10 percent. By how much would you revise your expectation of inflation over the next 12 months"

*=========================================================
rename q25 w4_info_uncertainty
label var w4_info_uncertainty ///
		"Q25. Suppose you want to adjust your prices but you are uncertain about the state of the economy."

replace w4_info_uncertainty="1" if w4_info_uncertainty=="a"
replace w4_info_uncertainty="2" if w4_info_uncertainty=="b"
replace w4_info_uncertainty="3" if w4_info_uncertainty=="c"
replace w4_info_uncertainty="4" if w4_info_uncertainty=="d"
destring w4_info_uncertainty, replace force
		
label define w4_info_uncertainty0 ///
	1 "a.	Collect more information now and then make a decision" ///
    2 "b.	Wait another quarter until more information comes in" ///
	3 "c.	Wait until other firms make a price adjustment" /// 
	4 "d.	Change your price right away" 	

	
label values w4_info_uncertainty w4_info_uncertainty0		

*=========================================================
foreach var in a b c d e f g h {
	label var q26`var' "Q26. How informative are these sources for your decisions (1=irrelevant; 6 =extremeley useful)?"
}

rename	q26a	w4_infosource_Newspapers
rename	q26b	w4_infosource_Television
rename	q26c	w4_infosource_Mon_Policy_Reports
rename	q26d	w4_infosource_RSS_feed
rename	q26e	w4_infosource_Twitter
rename	q26f	w4_infosource_Youtube
rename	q26g	w4_infosource_Subscription
rename	q26h	w4_infosource_Treasury_Reports

*=========================================================
rename q27a w4_turnover_lt
label var w4_turnover_lt ///
		"Q27. What share of your turnover comes from long-term customers"

		
rename q27b w4_turnover_st
label var w4_turnover_st ///
		"Q27. What share of your turnover comes from short-term customers"
	
rename q27c w4_turnover_lt_main
label var w4_turnover_lt_main ///
		"Q27. What share of your turnover (main product) comes from long-term customers"

		
rename q27d w4_turnover_st_main
label var w4_turnover_st_main ///
		"Q27. What share of your turnover (main product) comes from short-term customers"
	
*=========================================================
rename q28 w4_exrate
label var w4_exrate ///
		"Q28. The current exchange rate of the NZ Dollar to the USD"	
replace w4_exrate=1/w4_exrate if w4_exrate>1 & w4_exrate~=.
		
rename q29 w4_eexrate_12m
label var w4_eexrate_12m ///
		"Q28. The exchange rate of the NZ Dollar to the USD in 12 months"	

replace w4_eexrate_12m=1/w4_eexrate_12m if w4_eexrate_12m>1 & w4_eexrate_12m~=.
		
*=========================================================

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

compress
notes: "step040 - process wave 4"
save wave4, replace
