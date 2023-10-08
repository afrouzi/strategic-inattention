clear all
set more off
* step 06 - properties of inattention

clear all
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
import excel using "macro_data_NZ.xlsx", ///
	sheet("Sheet1") firstrow


cd "C:\Dropbox\Firm Survey\Stata_cleaned\workfiles"
joinby year quarter using aggregate_inflation, unmatched(both)
tab _merge
tab year _merge

sort year quarter


gen t1=_n
tsset t1

gen t2=year+(quarter-1)/4


*=======================================
*		compute inflation measures
*=======================================

**** CPI
gen piQ=(CPI/l.CPI-1)*400
gen pi3=(CPI/l4.CPI-1)*100

gen piA=pi
replace piA=pi3 if pi==.

**** CPI (food)
gen pi_foodQ=(CPI_food/l.CPI_food-1)*400
gen pi_foodA=(CPI_food/l4.CPI_food-1)*100

**** CPI (petrol)
gen pi_petrolQ=(CPI_petrol/l.CPI_petrol-1)*400
gen pi_petrolA=(CPI_petrol/l4.CPI_petrol-1)*100

**** House price
gen pi_hpQ=(house_price/l.house_price-1)*400
gen pi_hpA=(house_price/l4.house_price-1)*100

gen pi_hpAT=pi_hpA
replace pi_hpAT=-3 if pi_hpA<-3
replace pi_hpAT=20 if pi_hpA>20

*=====================================================
*		enter inflation measures from the survey
*=====================================================

gen pi_survey=.
replace pi_survey=5.3 if year==2013 & quarter==4
replace pi_survey=5.9 if year==2014 & quarter==1
replace pi_survey=4.3 if year==2014 & quarter==3
replace pi_survey=4.7 if year==2014 & quarter==4
replace pi_survey=2.8 if year==2016 & quarter==2
replace pi_survey=2.7 if year==2016 & quarter==4



*====================================================== 
*			Panel A
*======================================================
keep if t2>=1965
	

twoway (line  piA t2 if t2>=1980, lpattern(solid) lcolor(black) lwidth(thick)) ///
		(scatter pi_survey t2 if t2>=1980, mcolor(red) mfcolor(red)) ///
		, ylabel(-2(2)20) xlabel(1980(5)2016) ///
		ytitle("annual inflation rate, %", axis(1)) ///
		xtitle("") ///
		legend(	label(1 "CPI") ///
				label(2 "Survey") ///
				  rows(1)) ///
	text(19 1990.2 "Inflation", placement(e) color(green)) /// 
	text(18 1990.2 "targeting", placement(e) color(green)) /// 
	text(17 1990.2 "is introduced", placement(e) color(green)) ///
	xline(1990, lcolor(green))  ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_02_PanelA.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_02_PanelA.pdf", replace 

	
	
*====================================================== 
*			Panel B
*======================================================
keep if t2>=1965
	
sum CPI_petrol if year==2013  
capture drop CPI_petrolN
gen CPI_petrolN=log(CPI_petrol/r(mean))


twoway (scatter pi_survey t2 if t2>=2010, mcolor(red) mfcolor(red)) ///
		(line  CPI_petrolN t2 if t2>=2010, lpattern(solid) lcolor(blue) yaxis(2)) ///
		, ylabel(2(1)6) xlabel(2010(1)2016)  ///
		ytitle("annual expected inflation rate, %", axis(1)) ///
		ytitle("log deviation from 2013 average value, %", axis(2)) ///
		xtitle("") ///
		legend(	label(1 "Survey") ///
				label(2 "Petrol CPI, right axis")  rows(1)) ///
	name(fig2c, replace)  ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_02_PanelB.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_02_PanelB.pdf", replace 


