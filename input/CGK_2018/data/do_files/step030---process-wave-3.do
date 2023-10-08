clear all 

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\raw_data_not_for_sharing"

import excel using ///
	"Third Stage Data - formatted for STATA.xlsx", ///
	sheet("Data")  firstrow

rename Industry industry
rename FirmID firmid
rename SubIndustry subindustry
rename FirstName w3_manager_first_name
rename Surname w3_manager_surname
rename Age w3_manager_age
rename Gender w3_manager_gender
gen w3_manager_gender_a=0
replace w3_manager_gender_a=1 if w3_manager_gender=="F" | w3_manager_gender=="Female"
drop w3_manager_gender
rename w3_manager_gender_a w3_manager_gender
rename Position w3_manager_position

*=========================================================
rename HighestEducationalQualificatio w3_manager_educ
label var w3_manager_educ ///
	"Q3. What is your highest educational qualification?"
	
	
label define educ0 ///
	1 "Less than high school" ///
    2 "High school diploma" ///
	3 "Some college or Associates degree" /// 
	4 "College diploma" ///
	5 "Graduate studies (Masters or PhD)"

label values w3_manager_educ educ0

*=========================================================	
rename ExpFirm w3_manager_tenure_firm
label var w3_manager_tenure_firm ///
	"Q4. How many years of work experience do you have in this firm?"

*=========================================================	
rename ExpInd w3_manager_tenure_industry
label var  w3_manager_tenure_industry ///
	"Q5. How many years of work experience do you have in this industry?"

*=========================================================	
rename ExpOutsideNZ w3_manager_tenure_outside	
label var w3_manager_tenure_outside ///
		"Q6. How many years have you worked outside of NZ?"
	
*=========================================================	
rename GrossIncome w3_manager_income
destring w3_manager_income, replace force
label var w3_manager_income ///
	"Q7. How much is your gross income per annum?"
label define inc0 ///
	1 "Less than $30,000" ///
	2  "30,000-49,999" ///
	3 "50,000-74,999" ///
	4  "75,000-99,999" ///
	5  "100,000-149,999" ///
	6 "150,000 or more"
label values w3_manager_income inc0
replace w3_manager_income=3 if w3_manager_income==2
	
*=========================================================
rename MediaNews w3_manager_news
label var w3_manager_news ///
	"Q8. How closely do you follow media news about the NZ economy? Please rate your answer according to the scale:"
label define news0 ///
	1 "daily" ///
	2 "weekly" ///
	3 "monthly" ///
	4 "every few months" ///
	5 "once a year" ///
	6 "less than once a year"
label values w3_manager_news news0
	
*=========================================================	
rename PublicSources w3_manager_public
label var w3_manager_public ///
	"Q9. How often do you read information from public sources (e.g., monetary policy reports by RBNZ, Treasury country reports, etc)? Please rate your answer according to the scale:"
label values w3_manager_public news0

*=========================================================
rename AnyAffiliation w3_manager_affiliation
label var w3_manager_affiliation ///
		"Are you affiliated with any business association, congress, government department or statutory body?"

*=========================================================		
rename   UnitCostsOverNext12Mths w3_euc12
label var w3_euc12 ///
	"Q11. During the next 12 months, by how much do you think your firm's unit costs will change? Please provide an answer in % terms."

*=========================================================
gen w3_pi_randomization=1 if TypeofInflationQuestion=="Alternative inflation question #1" 
replace w3_pi_randomization=2 if TypeofInflationQuestion=="Alternative inflation question #2" 
replace w3_pi_randomization=3 if TypeofInflationQuestion=="Benchmark inflation question" 
label define pirand0 ///
	1 "Alternative inflation question #1" ///
	2 "Alternative inflation question #2" ///
	3 "Benchmark inflation question"
label values w3_pi_randomization pirand0
label var w3_pi_randomization "Q12. Type of Inflation Question"

drop TypeofInflationQuestion

*=========================================================
rename PriceChangeNext12Mths w3_epi_12
label var w3_epi_12 ///
	"During the next 12 months, by how much do you think overall prices in the economy will change?  Please provide an answer in percentage terms."

*=========================================================	
rename PriceChange510Years w3_epi_5y
label var w3_epi_5y ///
		"Q13. Over the next 5 to 10 years, at what average percentage rate per year do you think that overall prices in the economy will be changing?"
		
		
*=========================================================		
rename PriceImpact w3_price_response
label var 	w3_price_response ///	
	"Q14. If you thought overall prices in the economy over the next 12 months were going to rise by more than what you are currently forecasting, would you:"
replace w3_price_response="1" if w3_price_response=="a"
replace w3_price_response="2" if w3_price_response=="b"
replace w3_price_response="3" if w3_price_response=="c"
destring w3_price_response, force replace

label define price_response0 ///
	1 "Be more likely to increase your prices" ///
	2 "No change" ///
	3 "Be more likely to decrease your prices"
label values w3_price_response price_response0

rename Anyexplanation w3_price_response_explanation
label var 	w3_price_response_explanation ///	
	"Q14. explain"

*==============================================
rename WageImpact w3_wage_response
label var 	w3_wage_response ///	
	"Q15. If you thought overall prices in the economy over the next 12 months were going to rise by more than what you are currently forecasting, would you:"
replace w3_wage_response="1" if w3_wage_response=="a"
replace w3_wage_response="2" if w3_wage_response=="b"
replace w3_wage_response="3" if w3_wage_response=="c"
destring w3_wage_response, force replace

label define wage_response0 ///
	1 "Be more likely to increase the wages that you pay" ///
	2 "No change" ///
	3 "Be more likely to decrease the wages that pay"
label values w3_wage_response wage_response0

rename X w3_wage_response_explanation
label var 	w3_wage_response_explanation ///	
	"Q15. explain"

*==============================================
rename EmploymentImpact w3_empl_response
label var 	w3_empl_response ///	
	"Q16. If you thought overall prices in the economy over the next 12 months were going to rise by more than what you are currently forecasting, would you:"
replace w3_empl_response="1" if w3_empl_response=="a"
replace w3_empl_response="2" if w3_empl_response=="b"
replace w3_empl_response="3" if w3_empl_response=="c"
destring w3_empl_response, force replace

label define empl_response0 ///
	1 "Be more likely to increase your employment " ///
	2 "No change" ///
	3 "Be more likely to decrease your employment"
label values w3_empl_response empl_response0

rename Z w3_empl_response_explanation
label var 	w3_empl_response_explanation ///	
	"Q16. explain"
	
*==============================================
rename InvestmentImpact w3_invest_response
label var 	w3_invest_response ///	
	"Q17. f you thought overall prices in the economy over the next 12 months were going to rise by more than what you are currently forecasting, would you:"
replace w3_invest_response="1" if w3_invest_response=="a"
replace w3_invest_response="2" if w3_invest_response=="b"
replace w3_invest_response="3" if w3_invest_response=="c"
destring w3_invest_response, force replace

label define invest_response0 ///
	1 "Be more likely to increase your investments (capital expenditures)" ///
	2 "No change" ///
	3 "Be more likely to decrease your investments (capital expenditures)"
label values w3_invest_response empl_response0

rename AB w3_invest_response_explanation
label var 	w3_invest_response_explanation ///	
	"Q17. explain"	

*==============================================	
rename RealorNominal w3_fin_literacy

label var w3_fin_literacy ///
 "Q18. Suppose you are considering buying a house and you expect your income to grow at the same rate as overall prices in the future. Consider the following two scenarios for inflation and interest rates"
 
/*
Scenario 1: The interest rate on the loan is 5% per year and prices will rise at 2% per year
Scenario 2: The interest rate on the loan is 8% per year and prices will rise at 5% per year
*/

replace w3_fin_literacy="1" if w3_fin_literacy=="a"
replace w3_fin_literacy="2" if w3_fin_literacy=="b"
replace w3_fin_literacy="3" if w3_fin_literacy=="c"
destring w3_fin_literacy, force replace

label define fin_literacy0 ///
	1 "take 5% loan (2% inflation) rather than 8% loan (5% inflation)" ///
	2 "take 8% loan (5% inflation) rather than 5% loan (2% inflation)" ///
	3 "You are equally likely to take out the loan in both scenarios"
label values w3_fin_literacy fin_literacy0

*==============================================

cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

compress
notes: "step030 - process wave 3"
save wave3, replace


		
	
