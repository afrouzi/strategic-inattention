***  step 00 - create and label variables in data

* this file takes raw survey data and defines/labels variables from questionaire

clear all
set more off

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"
 
 * load data
 use survey_data_raw, clear
 
 *** naming/labeling series for convenience from survey questions

 *========================================================
 gen emp = (q2a1+q2a2+q2a3+q2a4)
 label var emp "Q2. Total Employment in Firm"
 rename emp w1_employment
 
 gen ftemp = 100*q2a1/(q2a1+q2a2+q2a3+q2a4)
 label var ftemp "Q2. Share of Full-Time Workers"
 rename ftemp w1_employment_share_fulltime
 
 *========================================================
 gen age = q3
 label var age "Q3. (Log) Age of Firm"
 rename age w1_age
 
 *========================================================
 
 gen totprodval = q4a
 label var totprodval "Q4. Total Firm Production Value"
 rename totprodval w1_actual_output_all
 
 gen potprodval = q4b
 label var potprodval "Q4. Potential Firm Production Value"
 rename potprodval w1_pot_output_all

 gen mainprodval = q4c
 label var mainprodval "Q4. Production Value: Main Product"
 rename mainprodval w1_actual_output_main

 
 gen potmainprodval = q4d
 label var potmainprodval "Q4. Potential Production Value: Main Product"
 rename potmainprodval w1_pot_output_main

 gen w1_cu_main = w1_actual_output_main/w1_pot_output_main
 label var w1_cu_main "Q4. Capacity utilitzation for main product"
 
 gen w1_cu_all = w1_actual_output_all/w1_pot_output_all
 label var w1_cu_all "Q4. Overall capacity utilization"
 
 
 *========================================================
 gen competitors = q6
 label var competitors "Q6. Number of Competitors"
 rename competitors w1_competitors
 
 *========================================================
 gen laborcosts = q7a
 label var laborcosts "Q7. Share of Labor in Costs"
  
 gen materialcosts = q7b
 label var materialcosts "Q7. Share of Materials in Costs"
 
 
 gen othercosts = 100- laborcosts - materialcosts
 label var othercosts "Q7. Share of Other Costs"
 
 ** YG: ensure that labor+mat costs do not exceed 100%
 gen temp_cs=(othercosts<0) if othercosts~=.
 replace laborcosts=laborcosts/(laborcosts+materialcosts)*100 if temp_cs==1
 replace laborcosts=materialcosts/(laborcosts+materialcosts)*100 if temp_cs==1
 replace othercosts=0 if temp_cs==1
 drop temp_cs
 
 rename laborcosts w1_labor_cost_share
 rename materialcosts w1_material_cost_share
 rename othercosts w1_other_cost_share
 
 *========================================================
 gen trade = 100-q5
 label var trade "Q5. Share of Foreign Sales"
 rename trade w1_trade_share
 
 *======================================================== 
 gen w1_exporter=0
 replace w1_exporter=1 if .>0 & .~=.
 label var w1_exporter "Dummy for Exporters"

 *========================================================  
 gen p0 = q8a
 label var p0 "Q8. Current price"
 rename p0 w1_price

 gen p0_foreign = q8b
 label var p0_foreign "Q8. Current price for foreign sales"
 rename p0_foreign w1_price_foreign
 
 *========================================================
 gen pricedif= q9
 label var pricedif "Q9. Difference between Firm's Price and Competitors'"
 rename pricedif w1_price_difference

 *======================================================== 
 gen p3l = q10_3
 label var p3l "Q10. Price 3-months prior"
 rename p3l w1_price_3m
 
 gen p6l = q10_6
 label var p6l "Q10. Price 6-months prior"
 rename p6l w1_price_6m
 
 gen p9l = q10_9
 label var p9l "Q10. Price 9-months prior"
 rename p9l w1_price_9m
 
 gen p12l = q10_12
 label var p12l "Q10. Price 12-months prior"
 rename p12l w1_price_12m
 
 *========================================================
 gen margin_cur = q11a
 label var margin_cur "Q11. Current profit margin"
 rename margin_cur w1_margin_current
 
 gen margin_avg = q11b
 label var margin_avg "Q11. Average profit margin"
 rename margin_avg w1_margin_average
  
*======================================================== 
 * construct durations between price reviews (in months)
 gen preview = 0
 replace preview=.25 if q12=="weekly"
 replace preview=1   if q12=="monthly"
 replace preview=1   if q12=="montly"
 replace preview=3   if q12=="quarterly"
 replace preview=6   if q12=="half-annually" 
 replace preview=6   if q12=="halh-annually" 
 replace preview=12  if q12=="annually" 
 replace preview=18  if q12=="less freq annual" 
 replace preview=18  if q12=="less frequently than annually" 
 label var preview "Q12. Months between price reviews"
 rename preview w1_price_review_frequency
 
 *========================================================
 label var q13a "Q13. Expected size of next price change"
 rename q13a w1_edp_size_main
 
 label var q13b "Q13. Expected duration (months) before next price change"
 rename q13b w1_edp_time_main
 
 *========================================================
 
 label var q14a "Q14. Size of current price change under price flexibility"
 rename q14a w1_dp_now
 
 label var q14b "Q14. Current change in profits under price flexibility"
 rename q14b w1_dy_dp_now
 
 label var q14c "Q14. Size of price change in 3-months under price flexibility"
 rename q14c w1_dp_3m
 
 label var q14d "Q14. Expected change in profits in 3-months under price flexibility"
 rename q14d w1_dy_dp_3m
 
 *========================================================

 
 * inflation expectations variables
 gen epi3 = q16
 label var epi3 "Q16. Expected price changes over next 3 months"
 rename epi3 w1_epi_3m
 
 gen epi12 = q19
 label var epi12 "Q19. Expected price changes over next 12 months"
 rename epi12 w1_epi_12m
  
 gen epi3l = q15
 label var epi3l "Q15. Expected price changes over previous 3 months"
 rename epi3l w1_pi_3m
 
 gen epi12l = q18
 label var epi12l "Q18. Expected price changes over previous 12 months"
 rename epi12l w1_pi_12m
  
 gen epi3ho = q17
 label var epi3ho "Q17. Others' expected price changes over next 3 months"
 rename epi3ho w1_epi_3m_ho
 
 gen epi12ho = q20
 label var epi12ho "Q20. Others' expected price changes over next 12 months"
 rename epi12ho w1_epi_12m_ho
 
 *============================================================================
 label var q22 "Q22. Belief about output gap"
 rename q22 w1_output_gap
 
 *============================================================================
 label var q23 "Q23. Elasticity of demand"
 rename q23 w1_demand_elasticity
 
 *============================================================================
 label var q24 "Q24. Elasticity of labor supply curve"
 rename q24 w1_labor_supply_elasticity
 
 *============================================================================
 label var q25 "Q25. Real rigidity: change price by X% if increase output by 10% and others hold prices constant"
 rename q25 w1_real_rigidity

 *============================================================================
 label var q26a "Q26. Cost increase % if output increases by 1%"
 rename q26a w1_cost_elasticity_1
 
 label var q26b "Q26. Cost increase % if output increases by 10%"
 rename q26b w1_cost_elasticity_10
 
 *============================================================================
 foreach var in a b c d e f g  {
	label var q21`var' "Q21. How informative are these sources for expectations of other firms (1=irrelevant; 5=extremeley useful)?"
	replace q21`var'=. if q21`var'==6
}

rename	q21a	w1_infosource_family_friends
rename	q21b	w1_infosource_former_employees
rename	q21c	w1_infosource_cust_supplier
rename	q21d	w1_infosource_survey_reports
rename	q21e	w1_infosource_media
rename	q21f	w1_infosource_trade_fairs
rename	q21g	w1_infosource_business_assoc

 *============================================================================
 
 * dummy variables for manufacturing, others, and "finance, insurance and business services"
 gen ind_manuf = 0 
 replace ind_manuf=1 if industry=="Manufacturing"
 label var ind_manuf "Manufacturing Firms"
 rename ind_manuf w1_ind_manuf
 
 gen ind_fibs = 0
 replace ind_fibs=1 if industry=="Fin,Ins, Bus Services"
 label var ind_fibs "Finance, Insurance and Business Services"
 rename ind_fibs w1_ind_fibs
 
 gen ind_others = 0
  replace ind_others=1 if industry=="others"
 label var ind_others "Other Industries"
 rename ind_others w1_ind_others
 
 * aggregate subsectors
 gen q1a=q1
 replace q1a="clothing" if q1=="leather" | q1=="textile"
 replace q1a="food" if q1=="food-beverage" | q1=="food-fruit,oil,cereal" | q1=="food-meat and dairy" ///
 | q1=="food-other"  | q1=="food-seafood"
 replace q1a="other manufacturing" if q1=="other-furniture" | q1=="other-petroleum and chemical" | q1=="other-plastic and rubber product" ///
 | q1=="other-printing" | q1=="other-wood and paper product" | q1=="others-furniture" | q1=="others-petroleum and chemical" ///
 | q1=="others-plastic and rubber product" | q1=="others-printing" | q1=="others-wood and paper product" 
 rename q1a w1_subsector
 
 *========================================================

 *** month of the survey
 gen survey_month=.
 replace survey_month=9 if firmid>=1 & firmid<=450 & firmid~=.
 replace survey_month=10 if firmid>=451 & firmid<=1165 & firmid~=.
 replace survey_month=11 if firmid>=1166 & firmid<=1920 & firmid~=.
 replace survey_month=12 if firmid>=1920 & firmid<=2856 & firmid~=.
 replace survey_month=1 if firmid>=2857 & firmid~=.
 
 rename survey_month w1_survey_month
 
drop q* 
 
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
compress
notes: "step010 - process wave 1"
save wave1, replace
 
 
 
 
 
 
