* step 04 - import follow-up survey data

* sourcefile is Excel: Follow_up_survey_data_for_Stata.xlsx

clear all
set more off

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

 
 * load data
use survey_data_follow_up_raw, clear

* this data has same variable names as in original survey with _fs ending for "followup survey"

* add variable labels to repeat questions from previous survey
*===================================================================
label var p0_fs "Q1. Current price"
rename p0_fs w2_price
*===================================================================
label var p0_foreign_fs "Q1. Current price for foreign sales"
rename p0_foreign_fs w2_price_foreign

*===================================================================
label var pricedif_fs "Q2. Price difference between your and competitor's price"
rename pricedif_fs w2_price_difference
 
*===================================================================
label var p3l_fs "Q3. Price 3-months prior"
rename p3l_fs w2_price_3m

*===================================================================
label var p6l_fs "Q3. Price 6-months prior"
rename p6l_fs w2_price_6m

*===================================================================
label var p9l_fs "Q3. Price 9-months prior"
rename p9l_fs w2_price_9m

*===================================================================
label var p12l_fs "Q3.Price 12-months prior"
rename p12l_fs w2_price_12m

*===================================================================
label var margin_cur_fs "Q4. Current profit margin"
rename margin_cur_fs w2_margin_current

*===================================================================
label var totprodval_fs "Q5. Total firm production value"
rename totprodval_fs w2_actual_output_all

*===================================================================
label var potprodval_fs "Q5. Potential firm production value"
rename potprodval_fs w2_pot_output_all

*===================================================================
label var mainprodval_fs "Q5. Main product production value"
rename mainprodval_fs w2_actual_output_main

*===================================================================
label var potmainprodval_fs "Q5. Potential production value for main product"
rename potmainprodval_fs w2_pot_output_main

*===================================================================
label var q14a_fs "Q6. Size of current price change under price flexibility"
rename q14a_fs w2_dp_now

*===================================================================
label var q14b_fs "Q6. Current change in profits under price flexibility"
rename q14b_fs w2_dy_dp_now

*===================================================================
label var q14c_fs "Q6. Size of price change in 3-months under price flexibility"
rename q14c_fs w2_dp_3m

*===================================================================
label var q14d_fs "Q6. Expected change in profits in 3-months under price flexibility"
rename q14d_fs w2_dy_dp_3m

*===================================================================
* new variables: other products sold
label var numbprods_fs "Q7. Number of other products sold"
rename numbprods_fs w2_numbprods

*===================================================================
label var q13a_fs "Q8. Expected size of next price change, main product"
rename q13a_fs w2_edp_size_main

label var q13a_other_fs "Q8. Expected size of next price change, second product"
rename q13a_other_fs w2_edp_size_second

*===================================================================
label var q13b_fs "Q8. Expected duration (months) before next price change, main product"
rename q13b_fs w2_edp_time_main

label var q13b_other_fs "Q8. Expected duration (months) before next price change, second product"
rename q13b_other_fs w2_edp_time_second

*===================================================================
label var q12_fs "Q9. Frequency of price reviews (in months), main product"
rename q12_fs w2_price_review_frequency_main

replace w2_price_review_frequency_main=".25" if w2_price_review_frequency_main=="weekly"
replace w2_price_review_frequency_main="1"   if w2_price_review_frequency_main=="monthly"
replace w2_price_review_frequency_main="1"   if w2_price_review_frequency_main=="montly"
replace w2_price_review_frequency_main="3"   if w2_price_review_frequency_main=="quarterly"
replace w2_price_review_frequency_main="6"   if w2_price_review_frequency_main=="half-annually" 
replace w2_price_review_frequency_main="6"   if w2_price_review_frequency_main=="halh-annually" 
replace w2_price_review_frequency_main="12"  if w2_price_review_frequency_main=="annually" 
replace w2_price_review_frequency_main="18"  if w2_price_review_frequency_main=="less freq annual" 
replace w2_price_review_frequency_main="18"  if w2_price_review_frequency_main=="less frequently than annually" 

destring w2_price_review_frequency_main, replace force

label var q12_other_fs "Q9. Frequency of price reviews (in months), second product"
rename q12_other_fs w2_price_review_frequency_second

replace w2_price_review_frequency_second=".25" if w2_price_review_frequency_second=="weekly"
replace w2_price_review_frequency_second="1"   if w2_price_review_frequency_second=="monthly"
replace w2_price_review_frequency_second="1"   if w2_price_review_frequency_second=="montly"
replace w2_price_review_frequency_second="3"   if w2_price_review_frequency_second=="quarterly"
replace w2_price_review_frequency_second="6"   if w2_price_review_frequency_second=="half-annually" 
replace w2_price_review_frequency_second="6"   if w2_price_review_frequency_second=="halh-annually" 
replace w2_price_review_frequency_second="12"  if w2_price_review_frequency_second=="annually" 
replace w2_price_review_frequency_second="18"  if w2_price_review_frequency_second=="less freq annual" 
replace w2_price_review_frequency_second="18"  if w2_price_review_frequency_second=="less frequently than annually" 

destring w2_price_review_frequency_second, replace force

*===================================================================
label var synch_reviews_fs "Q10. Frequency of synchronization of price reviews across products"
rename synch_reviews_fs w2_synch_previews
label var synch_pchanges_fs "Q10. Frequency of synchronization of price changes across products"
rename synch_pchanges_fs w2_synch_pchanges

*===================================================================
* new variables: investment and employment changes   
label var dn3l_fs "Q11. % Change in Employment, previous 3 months"
rename dn3l_fs w2_dn_3m

label var dn3_fs "Q11. Expected % Change in Employment, next 3 months"
rename dn3_fs w2_edn_3m

label var di3l_fs "Q12. Investment (as share of revnues), previous 3 months"
rename di3l_fs w2_di_3m

label var di3_fs "Q12. Expected Investment (as share of revenues), next 3 months"
rename di3_fs w2_edi_3m

*===================================================================
label var bor_cost_firm_fs "Q14. Firm's borrowing cost, %"
rename bor_cost_firm_fs w2_borrow_cost_firm
label var bor_cost_others_fs "Q14. Firm's belief about other firms' borrowing cost, %"
rename bor_cost_others_fs w2_borrow_cost_others

*===================================================================
label var epi3l_fs "Q15. Belief about inflation over previous 3 months"
rename epi3l_fs w2_pi_3m 

*===================================================================
label var epi3_fs "Q16. Belief about inflation over next 3 months"
rename epi3_fs w2_epi_3m 

*===================================================================
label var epi12l_fs "Q17. Belief about inflation over previous 12 months"
rename epi12l_fs w2_pi_12m 

*===================================================================
label var epi12_fs "Q18. Belief about inflation over next 12 months"
rename epi12_fs w2_epi_12m 

*===================================================================
label var epi3_ho_fs "Q19. Belief about other firms' expectation for inflation over next 3 months"
rename epi3_ho_fs w2_epi_3m_ho

*===================================================================
label var epi12_ho_fs "Q20. Belief about other firms' expectation for inflation over next 12 months"
rename epi12_ho_fs w2_epi_12m_ho

*===================================================================
label var q22_fs "Q21. Belief about output gap"
rename q22_fs w2_output_gap

*===================================================================
* new variables: beliefs about current and future UE and interest rates
label var ue0_fs "Q22. Belief about current unemployment rate"
rename ue0_fs w2_ue

label var ue12_fs "Q22. Belief about UE rate in 12 months"
rename ue12_fs w2_eue_12m

*===================================================================
label var int0_fs "Q23. Belief about current 1-year interest rate"
rename int0_fs w2_interest_rate

label var int12_fs "Q23. Belief about 1-year interest rate in 12 months"
rename int12_fs w2_einterest_rate_12m

*===================================================================
* new variables: distribution of expected sales growth
label var esales_more25_fs "Q13. Probability of sales growing more than 25% in next 12-months"
label var esales_15_25_fs "Q13. Probability of sales growing between 15% & 25% in next 12-months"
label var esales_5_15_fs "Q13. Probability of sales growing between 5% & 15% in next 12-months"
label var esales_neg5_5_fs "Q13. Probability of sales growing between -5% & 5% in next 12-months"
label var esales_neg15_neg5_fs "Q13. Probability of sales growing between -15% & -5% in next 12-months"
label var esales_neg25_neg15_fs "Q13. Probability of sales growing between -25% & -15% in next 12-months"
label var esales_moreneg25_fs "Q13. Probability of sales growing less than -25% in next 12-months"
recode esales_more25_fs esales_15_25_fs esales_5_15_fs esales_neg5_5_fs esales_neg15_neg5_fs esales_neg25_neg15_fs esales_moreneg25_fs (mis=0) 

rename esales_more25_fs 		w2_esales_12m_more25
rename esales_15_25_fs 			w2_esales_12m_15_25
rename esales_5_15_fs 			w2_esales_12m_5_15
rename esales_neg5_5_fs 		w2_esales_neg5_5
rename esales_neg15_neg5_fs		w2_esales_neg15_neg5
rename esales_neg25_neg15_fs	w2_esales_neg25_neg15
rename esales_moreneg25_fs		w2_esales_moreneg25

*===================================================================

* new variables: distribution of expected GDP growth
label var dgdp_more5_fs 	"Q24. Probability of GDP growing more than 5% in next 12-months"
label var dgdp_4_5_fs 		"Q24. Probability of GDP growing between 4% & 5% in next 12-months"
label var dgdp_3_4_fs 		"Q24. Probability of GDP growing between 3% & 4% in next 12-months"
label var dgdp_2_3_fs 		"Q24. Probability of GDP growing between 2% & 3% in next 12-months"
label var dgdp_1_2_fs 		"Q24. Probability of GDP growing between 1% & 2% in next 12-months"
label var dgdp_0_1_fs 		"Q24. Probability of GDP growing between 0% & 1% in next 12-months"
label var dgdp_neg_fs 		"Q24. Probability of GDP falling in next 12-months"
recode dgdp_more5_fs dgdp_4_5_fs dgdp_3_4_fs dgdp_2_3_fs dgdp_1_2_fs dgdp_0_1_fs dgdp_neg_fs (mis=0) 

rename dgdp_more5_fs 	w2_egdp_12m_more5
rename dgdp_4_5_fs		w2_egdp_12m_4_5
rename dgdp_3_4_fs		w2_egdp_3_4
rename dgdp_2_3_fs		w2_egdp_2_3
rename dgdp_1_2_fs		w2_egdp_1_2
rename dgdp_0_1_fs		w2_egdp_0_1
rename dgdp_neg_fs		w2_egdp_neg

*===================================================================
* new variables: distribution of expected inflation
label var epi12_more5_fs "Q25. Probability of inflation more than 5% in next 12-months"
label var epi12_4_5_fs "Q25. Probability of inflation growing between 4% & 5% in next 12-months"
label var epi12_3_4_fs "Q25. Probability of inflation growing between 3% & 4% in next 12-months"
label var epi12_2_3_fs "Q25. Probability of inflation growing between 2% & 3% in next 12-months"
label var epi12_1_2_fs "Q25. Probability of inflation growing between 1% & 2% in next 12-months"
label var epi12_0_1_fs "Q25. Probability of inflation growing between 0% & 1% in next 12-months"
label var epi12_neg_fs "Q25. Probability of inflation falling in next 12-months"
recode epi12_more5_fs epi12_4_5_fs epi12_3_4_fs epi12_2_3_fs epi12_1_2_fs epi12_0_1_fs epi12_neg_fs (mis=0) 

rename epi12_more5_fs 	w2_epi_12m_more5
rename epi12_4_5_fs		w2_epi_12m_4_5
rename epi12_3_4_fs		w2_epi_12m_3_4
rename epi12_2_3_fs		w2_epi_12m_2_3
rename epi12_1_2_fs		w2_epi_12m_1_2
rename epi12_0_1_fs		w2_epi_12m_0_1
rename epi12_neg_fs		w2_epi_12m_neg


*===================================================================
* new variables borrowing costs & definition of units
label var def_units_fs "Firm's definition of a unit of its product"
rename def_units_fs w2_output_units

rename followsurveytype w2_followsurveytype
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
compress
notes: "step020 - process wave 2"
save wave2, replace

