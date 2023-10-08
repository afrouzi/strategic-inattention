clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 				time before next price change
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 gen pricedate="0-3 months" if w1_edp_time_main<4
 replace pricedate="4-6 months" if w1_edp_time_main>3 & w1_edp_time_main<7
 replace pricedate="7-12 months" if w1_edp_time_main>6 & w1_edp_time_main<13
 replace pricedate=">12 months" if w1_edp_time_main>12 
  
 collapse (mean) w1_epi_12m  w1_pi_12m  , by(pricedate) 
 
 rename w1_epi_12m d1_epi_12m
 rename w1_pi_12m d1_pi_12m
 egen tt=fill(1(1)4)
 save temp_d1, replace
 
 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
* 					by number of competitors
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 
 gen compet = "1-5" if w1_competitors<6
 replace compet = "6-10" if w1_competitors>5 & w1_competitors<11
 replace compet = "10-20" if w1_competitors>10 & w1_competitors<21
 replace compet = ">20 competitors" if w1_competitors>20 
 
 collapse (mean) w1_epi_12m  w1_pi_12m , by(compet) 
 rename w1_epi_12m d2_epi_12m
 rename w1_pi_12m d2_pi_12m
  egen tt=fill(1(1)4)
  gen tt2=tt
  replace tt2=2 if tt==3
  replace tt2=3 if tt==2
  sort tt2
  drop tt
  rename tt2 tt
   
 save temp_d2, replace
 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* 				by slope of profit function
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear
 
 *** calculate the curvature of the profit function
gen prof_curv=abs(w1_dy_dp_now)/abs(w1_dp_now)
replace prof_curv=0 if w1_dp_now==0
 

 gen quart = "Flat" if prof_curv<1
 replace quart = "Medium" if prof_curv>.99 & prof_curv<1.2
 replace quart = "Steep" if prof_curv>1.19 
 
 collapse (mean) w1_epi_12m  w1_pi_12m , by(quart) 
 rename w1_epi_12m d3_epi_12m
 rename w1_pi_12m  d3_pi_12m
 egen tt=fill(1(1)3)
 save temp_d3, replace
 
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*				plot the figure
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
 use temp_d1, clear
 joinby tt using temp_d2
 joinby tt using temp_d3, unmatched(both)
 
 twoway ///
 (scatter d1_epi_12m d1_pi_12m , msymbol(Dh) mlabel(pricedate) mlabposition(6) xtitle("Mean Belief about Past Inflation") ytitle("Mean Forecast of Future Inflation")) ///
 (scatter d2_epi_12m d2_pi_12m  , msymbol(X) mlabel(compet)  mlabposition(6) xtitle("Mean Belief about Past Inflation") ytitle("Mean Forecast of Future Inflation")) ///
 (scatter d3_epi_12m d3_pi_12m  , msymbol(O) mlabel(quar)  mlabposition(1) xtitle("Mean Belief about Past Inflation") ytitle("Mean Forecast of Future Inflation") xsc(r(4.3 7.2))), ///
 legend(label(1 "time before next price adjustment") ///
		label(2 "number of competitors") ///
		label(3 "curvature of the profit function") rows(3) position(5) ring(0)) ///
		xlabel(3(1)9) ///
		name(fig1, replace) ///
		  graphregion(color(white)) bgcolor(white)  
		   
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_05.eps", replace 
graph export "C:\Dropbox\Firm Survey\AER-final\figures\Figure_05.pdf", replace 


