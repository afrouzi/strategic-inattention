******** Effects of Information on Actions ******************	

clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear


capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"

gen anzsiccode1=floor(anzsiccode/1000)
recode anzsiccode1 7= 6

gen sic_code1=floor(sic_code/10000)
recode sic_code1 9=8



gen schooling=11 if w8_manager_educ==1
replace schooling=13 if w8_manager_educ==2
replace schooling=15 if w8_manager_educ==3
replace schooling=17 if w8_manager_educ==4
replace schooling=19 if w8_manager_educ==5


gen share_MFG=(industry=="Manufacturing")
gen share_trade=(industry=="Retail Trade") | (industry=="Trade") | (industry=="Wholesale Trade") | (industry=="Wholesale trade") 
gen share_CONSTR=(industry=="Construction") | (industry=="Construction and Transportation")
gen share_TRANS=(industry=="Transport and communication") | (industry=="Transport, Postal and Warehousing")
gen share_SERV=(industry=="Professional and financial services") | (industry=="Information Media and Telecommunications") | (industry=="Accommodation and Food Services")

*=============================================================================
*				test missing at random
*=============================================================================

tabstat w8_empl w8_age w8_sales_domestic_share w8_competitors ///
		w8_manager_tenure_firm w8_manager_gender schooling ///
		share* , stat(N mean sd) col(stat) format("%4.2f")
	
