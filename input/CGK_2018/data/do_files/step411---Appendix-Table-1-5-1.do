clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

*=======================================================================
* basic stats for all firms
mean w1_age w1_employment w1_labor_cost_share ///
	w1_trade_share  w1_margin_current  w1_margin_average ///
	w1_price_review_frequency w1_edp_time_main w1_edp_size_main [aw=wgtE43]  if sic2!="not classified"

egen countN=count(w1_age), by(agg1)

*========================================================================
* basic stats for four main industrial groupings
gen groupnum = 1 if agg1=="Manufacturing"
replace groupnum = 2 if agg1=="Trade"
replace groupnum = 3 if agg1=="Professional and Financial Services"
replace groupnum = 4 if agg1=="Construction and Transportation"

gen str7 group= ""
preserve
keep group
keep in 1/1
save "temp.dta", replace

restore
capture program drop maketable
program define maketable
   preserve 
   replace group= "`2'"
   mean w1_age w1_employment w1_labor_cost_share ///
	w1_trade_share  w1_margin_current  w1_margin_average ///
	w1_price_review_frequency w1_edp_time_main w1_edp_size_main countN [aw=wgtE43] if groupnum == `1'
   matrix emeans=e(b)
   gen meanage= emeans[1,1]
   gen meannemp= emeans[1,2]
   gen meanlaborcosts= emeans[1,3]
   gen meantrade= emeans[1,4]
   gen meanmarg_cur= emeans[1,5]
   gen meanmarg_avg= emeans[1,6]
   gen meanpreview= emeans[1,7]
   gen meanq13b= emeans[1,8]
   gen meanq13a= emeans[1,9]
   gen meanN= emeans[1,10]
   
   keep group mean*
   keep  in 1/1
   save "temp1.dta", replace
   use "temp.dta", clear
   append using "temp1.dta"
   save "temp.dta", replace
   restore
end
maketable 1 "Manufacturing"
maketable 2 "Trade"
maketable 3 "Professional and Financial Services"
maketable 4 "Construction and Transportation"

use "temp.dta",clear
list
drop  in 1
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
export excel "means_AggInd.xlsx", firstrow(variables) replace

clear all

*=============================================================================
* basic stats for 16 subindustries
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

gen groupnum = 1 	 if agg2=="Chemicals and Metals"
replace groupnum = 2 if agg2=="Equipment and Machinery"
replace groupnum = 3 if agg2=="Food and Beverage"
replace groupnum = 4 if agg2=="Paper/Wood, Printing and Furniture"
replace groupnum = 5 if agg2=="Textile and Clothing"
replace groupnum = 6 if agg2=="Car, Supermarket and Food Retailing"
replace groupnum = 7 if agg2=="Other Store Retailing"
replace groupnum = 8 if agg2=="Hotel and Food Services"
replace groupnum = 9 if agg2=="Wholesale Trade"
replace groupnum = 10 if agg2=="Accounting"
replace groupnum = 11 if agg2=="Finance"
replace groupnum = 12 if agg2=="Insurance"
replace groupnum = 13 if agg2=="Aux. Finance and Insurance Services"
replace groupnum = 14 if agg2=="Legal Services"
replace groupnum = 15 if agg2=="Rental, Hiring and Real Estate Services"
replace groupnum = 16 if agg2=="All other professional services"

egen countN=count(w1_age), by(groupnum)

gen str7 group= ""
preserve
keep group
keep in 1/1
save "temp.dta", replace

restore
capture program drop maketable
program define maketable
   preserve 
   replace group= "`2'"
   mean w1_age w1_employment w1_labor_cost_share ///
	w1_trade_share  w1_margin_current  w1_margin_average ///
	w1_price_review_frequency w1_edp_time_main w1_edp_size_main ///
	countN  [aw=wgtE43] if groupnum == `1'
	
   matrix emeans=e(b)
   gen meanage= emeans[1,1]
   gen meannemp= emeans[1,2]
   gen meanlaborcosts= emeans[1,3]
   gen meantrade= emeans[1,4]
   gen meanmarg_cur= emeans[1,5]
   gen meanmarg_avg= emeans[1,6]
   gen meanpreview= emeans[1,7]
   gen meanq13b= emeans[1,8]
   gen meanq13a= emeans[1,9]
   gen meanN= emeans[1,10]

   keep group mean*
   keep  in 1/1
   save "temp1.dta", replace
   use "temp.dta", clear
   append using "temp1.dta"
   save "temp.dta", replace
   restore
end
maketable 1 "Chemicals and Metals"
maketable 2 "Equipment and Machinery"
maketable 3 "Food and Beverage"
maketable 4 "Paper/Wood, Printing and Furniture"
maketable 5 "Textile and Clothing"
maketable 6 "Car, Supermarket and Food Retailing"
maketable 7 "Other Store Retailing"
maketable 8 "Hotel and Food Services"
maketable 9 "Wholesale Trade"
maketable 10 "Accounting"
maketable 11 "Finance"
maketable 12 "Insurance"
maketable 13 "Aux. Finance and Insurance Services"
maketable 14 "Legal Services"
maketable 15 "Rental, Hiring and Real Estate Services"
maketable 16 "All other professional services""

use "temp.dta",clear
erase temp.dta

list
drop  in 1
capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
export excel "means_SubInd.xlsx", firstrow(variables) replace

