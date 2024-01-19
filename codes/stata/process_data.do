/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Purpose: process data
*****************************************************************************************************/

* Wave 6: merge with industry classification --------
use "$CGK_2018/master_file_public_release.dta", clear

* Create mean of subjective distributions
* if the firm did not assign a probability to a bin, replace that probability with zero
replace w6_epi_12m_25plus=0 if w6_epi_12m_25plus==. 
replace w6_epi_12m_15_25=0 if w6_epi_12m_15_25==. 
replace w6_epi_12m_10_15=0 if w6_epi_12m_10_15==. 
replace w6_epi_12m_8_10=0 if w6_epi_12m_8_10==. 
replace w6_epi_12m_6_8=0 if w6_epi_12m_6_8==. 
replace w6_epi_12m_4_6=0 if w6_epi_12m_4_6==. 
replace w6_epi_12m_2_4=0 if w6_epi_12m_2_4==. 
replace w6_epi_12m_0_2=0 if w6_epi_12m_0_2==. 
replace w6_epi_12m_0_neg2=0 if w6_epi_12m_0_neg2==. 
replace w6_epi_12m_neg2_neg4=0 if w6_epi_12m_neg2_neg4==. 
replace w6_epi_12m_neg4_neg6=0 if w6_epi_12m_neg4_neg6==. 
replace w6_epi_12m_neg6_neg8=0 if w6_epi_12m_neg6_neg8==. 
replace w6_epi_12m_neg8_neg10=0 if w6_epi_12m_neg8_neg10==. 
replace w6_epi_12m_neg10_neg15=0 if w6_epi_12m_neg10_neg15==. 
replace w6_epi_12m_neg15_neg25=0 if w6_epi_12m_neg15_neg25==. 
replace w6_epi_12m_moreneg25=0 if w6_epi_12m_moreneg25==. 

* check if probabilities sum to 100
gen sum_w6_epi_12m = w6_epi_12m_25plus + w6_epi_12m_15_25 + w6_epi_12m_10_15 + w6_epi_12m_8_10 + w6_epi_12m_6_8 + w6_epi_12m_4_6 + w6_epi_12m_2_4 + w6_epi_12m_0_2 + w6_epi_12m_0_neg2 + w6_epi_12m_neg2_neg4 + w6_epi_12m_neg4_neg6 + w6_epi_12m_neg6_neg8 + w6_epi_12m_neg8_neg10 + w6_epi_12m_neg10_neg15 + w6_epi_12m_neg15_neg25 + w6_epi_12m_moreneg25


gen w6_epi_12m_mean=(30*w6_epi_12m_25plus ///
				+20*w6_epi_12m_15_25 ///
				+12.5*w6_epi_12m_10_15 ///
				+9*w6_epi_12m_8_10 ///
				+7*w6_epi_12m_6_8 ///
				+5*w6_epi_12m_4_6 ///
				+3*w6_epi_12m_2_4 ///
				+1*w6_epi_12m_0_2 ///
				+(-1)*w6_epi_12m_0_neg2 ///
				+(-3)*w6_epi_12m_neg2_neg4 ///
				+(-5)*w6_epi_12m_neg4_neg6 ///
				+(-7)*w6_epi_12m_neg6_neg8 ///
				+(-9)*w6_epi_12m_neg8_neg10 ///
				+(-12.5)*w6_epi_12m_neg10_neg15 ///
				+(-20)*w6_epi_12m_neg15_neg25 ///
				+(-30)*w6_epi_12m_moreneg25)/100

* Create variance of subjective distributions
gen w6_epi_12m_var=(30^2*w6_epi_12m_25plus ///
				+20^2*w6_epi_12m_15_25 ///
				+12.5^2*w6_epi_12m_10_15 ///
				+9^2*w6_epi_12m_8_10 ///
				+7^2*w6_epi_12m_6_8 ///
				+5^2*w6_epi_12m_4_6 ///
				+3^2*w6_epi_12m_2_4 ///
				+1^2*w6_epi_12m_0_2 ///
				+(-1)^2*w6_epi_12m_0_neg2 ///
				+(-3)^2*w6_epi_12m_neg2_neg4 ///
				+(-5)^2*w6_epi_12m_neg4_neg6 ///
				+(-7)^2*w6_epi_12m_neg6_neg8 ///
				+(-9)^2*w6_epi_12m_neg8_neg10 ///
				+(-12.5)^2*w6_epi_12m_neg10_neg15 ///
				+(-20)^2*w6_epi_12m_neg15_neg25 ///
				+(-30)^2*w6_epi_12m_moreneg25)/100 ///
				-w6_epi_12m_mean^2

* Create industry var 
label define industry_values 0 "Manufacturing" 1 "Construction" 2 "Trade" ///
	3 "Services"

gen w6_flag = 1 if w6_competitors ~= .
gen industry_1 = .
replace industry_1=0 if w6_anzsiccode<2600  & w6_anzsiccode>1099
replace industry_1=1 if w6_anzsiccode<3300 & w6_anzsiccode>2999
replace industry_1=2 if w6_anzsiccode<4400 & w6_anzsiccode>3299
replace industry_1=3 if w6_anzsiccode>4399

label values industry_1 industry_values

* Create standard deviation of subjective distributions
gen w6_epi_12m_sd=sqrt(w6_epi_12m_var)

gen w6_str_comp=(w6_dp_10p_p - w6_dp_nocomp_10p_p)/w6_dp_comp_10p_p
gen w6_log_K=log(w6_competitors)

save "$workingdir/master_file_processed.dta", replace

* Generate data for Table A1 and Appendix D for summary stats of K and alpha
keep w6_competitors w6_dp_comp_10p_p w6_dp_10p_p w6_dp_nocomp_10p_p w6_anzsiccode 

gen survey = 6

rename (w6_competitors w6_dp_comp_10p_p ///
	w6_dp_10p_p w6_dp_nocomp_10p_p w6_anzsiccode) ///
	 (competitors response_dp_competitor /// 
	 response_dp_own response_dp_own_fixed anzsiccode)

save "$workingdir/K_and_alpha.dta", replace


* Wave 8 --------------------------------------------
use "$CGKR_2021/workfile_QJE.dta", clear

gen survey = 8

keep w8_competitors w8_response_dp_competitor w8_response_dp_own w8_response_dp_own_fixed survey anzsiccode

rename (w8_competitors w8_response_dp_competitor /// 
	 w8_response_dp_own w8_response_dp_own_fixed) ///
	 (competitors response_dp_competitor /// 
	 response_dp_own response_dp_own_fixed)


* Append wave 6 -------------------------------------
append using "$workingdir/K_and_alpha.dta"


* Create additional variables ------------------------
gen Y=response_dp_own-response_dp_own_fixed
gen X=response_dp_competitor
gen alpha = Y/X 
gen K=competitors

gen industry_2 = ""

// Assign industry labels to different ranges of ANZSIC codes
replace industry_2 = "Agriculture, Forestry, and Fishing" if anzsiccode >= 1 & anzsiccode <= 599
replace industry_2 = "Mining" if anzsiccode >= 600 & anzsiccode <= 1099
replace industry_2 = "Food Product Manufacturing" if anzsiccode >= 1100 & anzsiccode <= 1199
replace industry_2 = "Beverage and Tobacco Product Manufacturing" if anzsiccode >= 1200 & anzsiccode <= 1299
replace industry_2 = "Textile, Leather, Clothing and Footwear Manufacturing" if anzsiccode >= 1300 & anzsiccode <= 1399
replace industry_2 = "Wood Product Manufacturing" if anzsiccode >= 1400 & anzsiccode <= 1499
replace industry_2 = "Pulp, Paper and Converted Paper Product Manufacturing" if anzsiccode >= 1500 & anzsiccode <= 1599
replace industry_2 = "Printing" if anzsiccode >= 1600 & anzsiccode <= 1699
replace industry_2 = "Petroleum and Coal Product Manufacturing" if anzsiccode >= 1700 & anzsiccode <= 1799
replace industry_2 = "Basic Chemical and Chemical Product Manufacturing" if anzsiccode >= 1800 & anzsiccode <= 1899
replace industry_2 = "Polymer Product and Rubber Product Manufacturing" if anzsiccode >= 1900 & anzsiccode <= 1999
replace industry_2 = "Non-Metallic Mineral Product Manufacturing" if anzsiccode >= 2000 & anzsiccode <= 2099
replace industry_2 = "Primary Metal and Metal Product Manufacturing" if anzsiccode >= 2100 & anzsiccode <= 2199
replace industry_2 = "Fabricated Metal Product Manufacturing" if anzsiccode >= 2200 & anzsiccode <= 2299
replace industry_2 = "Transport Equipment Manufacturing" if anzsiccode >= 2300 & anzsiccode <= 2399
replace industry_2 = "Machinery and Equipment Manufacturing" if anzsiccode >= 2400 & anzsiccode <= 2499
replace industry_2 = "Furniture and Other Manufacturing" if anzsiccode >= 2500 & anzsiccode <= 2599
replace industry_2 = "Electricity, Gas, Water, and Waste Services" if anzsiccode >= 2600 & anzsiccode <= 2999
replace industry_2 = "Construction" if anzsiccode >= 3000 & anzsiccode <= 3299
replace industry_2 = "Wholesale Trade" if anzsiccode >= 3300 & anzsiccode <= 3899
replace industry_2 = "Retail Trade" if anzsiccode >= 3900 & anzsiccode <= 4399
replace industry_2 = "Accommodation and Food Services" if anzsiccode >= 4400 & anzsiccode <= 4599
replace industry_2 = "Transport, Postal, and Warehousing" if anzsiccode >= 4600 & anzsiccode <= 5399
replace industry_2 = "Information Media and Telecommunications" if anzsiccode >= 5400 & anzsiccode <= 6199
replace industry_2 = "Financial and Insurance Services" if anzsiccode >= 6200 & anzsiccode <= 6599
replace industry_2 = "Rental, Hiring, and Real Estate Services" if anzsiccode >= 6600 & anzsiccode <= 6899
replace industry_2 = "Professional, Scientific, and Technical Services" if anzsiccode >= 6900 & anzsiccode <= 7199

* Save
save "$workingdir/K_and_alpha.dta", replace