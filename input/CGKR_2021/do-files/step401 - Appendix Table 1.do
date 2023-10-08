clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"



gen S=1 if w9_epi_12m_implied~=.
replace S=0 if w9_epi_12m_implied==.

gen lnL=log(w8_empl)
gen lnAge=log(w8_age)

*** Classify level-k types for those who do 30+ seconds of thinking on firt level-k question
gen k=.
replace k=0 if w8_kguess_timetrack<20
replace k=0 if w8_kguess>=50 & w8_kguess_timetrack>=20 
replace k=1 if w8_kguess==33 & w8_kguess_timetrack>=20
replace k=2 if (w8_kguess==22|w8_kguess==26) & w8_kguess_timetrack>=20
replace k=3 if (w8_kguess==15|w8_kguess==14|w8_kguess==12) & w8_kguess_timetrack>=20
replace k=4 if w8_kguess==10 & w8_kguess_timetrack>=20
replace k=5 if w8_kguess<10 & w8_kguess_timetrack>=20

*** Classify level-k types for those who do 30+ seconds of thinking on firt level-k question
gen k1=.
replace k1=0 if w8_kguess_timetrack<20 & abs(w8_kguess-50)<=3
replace k1=0 if w8_kguess>=50 & w8_kguess_timetrack>=20 
replace k1=1 if w8_kguess==33 & w8_kguess_timetrack>=20
replace k1=2 if (w8_kguess==22|w8_kguess==26) & w8_kguess_timetrack>=20
replace k1=3 if (w8_kguess==15|w8_kguess==14|w8_kguess==12) & w8_kguess_timetrack>=20
replace k1=4 if w8_kguess==10 & w8_kguess_timetrack>=20
replace k1=5 if w8_kguess<10 & w8_kguess_timetrack>=20



tab k

gen k2=0 if k==0
replace k2=1 if k==1
replace k2=2 if k>1 & k~=.

gen anzsiccode1=floor(anzsiccode/1000)
recode anzsiccode1 7= 6

gen schooling=11 if w8_manager_educ==1
replace schooling=13 if w8_manager_educ==2
replace schooling=15 if w8_manager_educ==3
replace schooling=17 if w8_manager_educ==4
replace schooling=19 if w8_manager_educ==5




*=============================================================================
*				test missing at random
*=============================================================================
capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\stata\outregs"

reg S lnL lnAge w8_sales_domestic_share w8_competitors, robust
outreg2 using Table_selection.dta, dta replace dec(3)

reg S lnL lnAge w8_sales_domestic_share w8_competitors w8_manager_tenure_firm w8_manager_gender schooling, robust
outreg2 using Table_selection.dta, dta append dec(3)


reg S lnL lnAge w8_sales_domestic_share w8_competitors w8_manager_tenure_firm w8_manager_gender schooling k, robust
outreg2 using Table_selection.dta, dta append dec(3)

reg S lnL lnAge w8_sales_domestic_share w8_competitors w8_manager_tenure_firm w8_manager_gender schooling k i.anzsiccode1, robust
outreg2 using Table_selection.dta, dta append dec(3)


