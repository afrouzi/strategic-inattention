clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

*** inflation expectations
quiet foreach ww in w8 { /* loop over waves */
		foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
					   0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
				   {

				 gen `ww'_epi_diff_`i'=`ww'_epi_ho_12m_`i' - `ww'_epi_ho_12m_`i'
	}
}


tempname 2
postfile `2'  str10 wave ///
	str20 bin ///
    p0 p10 p20 p30 p40 p50 p60 p70 p80 p90 p100 mm ///
	using "HO.dta", replace every(1)
	

quiet foreach ww in w8 { /* loop over waves */
		foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
					   0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
				   {

				   
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'<=0 & `ww'_epi_ho_12m_`i'~=. , d
				 local p0=r(N)
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>0 & `ww'_epi_ho_12m_`i'<=10 & `ww'_epi_ho_12m_`i'~=. , d
				 local p10=r(N)
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>10 & `ww'_epi_ho_12m_`i'<=20 & `ww'_epi_ho_12m_`i'~=. , d
				 local p20=r(N)
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>20 & `ww'_epi_ho_12m_`i'<=30 & `ww'_epi_ho_12m_`i'~=. , d
				 local p30=r(N)
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>30 & `ww'_epi_ho_12m_`i'<=40 & `ww'_epi_ho_12m_`i'~=. , d
				 local p40=r(N)

				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>40 & `ww'_epi_ho_12m_`i'<=50 & `ww'_epi_ho_12m_`i'~=. , d
				 local p50=r(N)
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>50 & `ww'_epi_ho_12m_`i'<=60 & `ww'_epi_ho_12m_`i'~=. , d
				 local p60=r(N)				 
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>60 & `ww'_epi_ho_12m_`i'<=70 & `ww'_epi_ho_12m_`i'~=. , d
				 local p70=r(N)	
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>70 & `ww'_epi_ho_12m_`i'<=80 & `ww'_epi_ho_12m_`i'~=. , d
				 local p80=r(N)	
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>80 & `ww'_epi_ho_12m_`i'<=90 & `ww'_epi_ho_12m_`i'~=. , d
				 local p90=r(N)		
				 
				 sum `ww'_epi_ho_12m_`i' if `ww'_epi_ho_12m_`i'>90 & `ww'_epi_ho_12m_`i'<=100 & `ww'_epi_ho_12m_`i'~=. , d
				 local p100=r(N)					 
				 
				 sum `ww'_epi_ho_12m_`i' , d
				local mm=r(mean)
				 
				 post `2' ("`ww'") ("`i'") (`p0') (`p10') (`p20') (`p30') (`p40') (`p50') (`p60') (`p70') (`p80') (`p90') (`p100') (`mm')
				 
	}
}	

postclose `2'


   
*===============================================================================
**  Plot distribution for each type of expectations
*===============================================================================
use HO, clear
gen t=_n
gen t1=17-t

gen cp100=p0 + p10 + p20 + p30 + p40 + p50 + p60 + p70 + p80 + p90 + p100
gen cp90=p0 + p10 + p20 + p30 + p40 + p50 + p60 + p70 + p80 + p90  
gen cp80=p0 + p10 + p20 + p30 + p40 + p50 + p60 + p70 + p80  
gen cp70=p0 + p10 + p20 + p30 + p40 + p50 + p60 + p70  
gen cp60=p0 + p10 + p20 + p30 + p40 + p50 + p60  
gen cp50=p0 + p10 + p20 + p30 + p40 + p50  
gen cp40=p0 + p10 + p20 + p30 + p40  
gen cp30=p0 + p10 + p20 + p30  
gen cp20=p0 + p10 + p20
gen cp10=p0 + p10  
gen cp0=p0 

foreach var in cp0 cp10 cp20 cp30 cp40 cp50 cp60 cp70 cp80 cp90 cp100 {
	replace `var'=`var'/1031*100
}

	
	
twoway (bar cp100 t1, fcolor(gs3) lcolor(none) ) ///
	   (bar cp90 t1, fcolor(gs4) lcolor(none)  ) ///
	   (bar cp80 t1, fcolor(gs5) lcolor(none)  ) ///
	   (bar cp70 t1, fcolor(gs6) lcolor(none)  ) ///
	   (bar cp60 t1, fcolor(gs7) lcolor(none)  ) ///
	   (bar cp50 t1, fcolor(gs8) lcolor(none)  ) ///
	   (bar cp40 t1, fcolor(gs9) lcolor(none)  ) ///
	   (bar cp30 t1, fcolor(gs10) lcolor(none)  ) ///
	   (bar cp20 t1, fcolor(gs11) lcolor(none)  ) ///
	   (bar cp10 t1, fcolor(gs12) lcolor(none)  ) ///
	   (bar cp0 t1, fcolor(gs15) lcolor(none)  ) ///
	   (scatter mm t1, msymbol(o) mfcolor(red) mlcolor(red) yaxis(2)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(40)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Probability distribution" " ") ///
	   ylabel(0(20)100) ///
	   ytitle("Mean probability", axis(2) color(red)) ///
	   ylabel(0(20)100, axis(2) labcolor(red)) ///
	   legend(order(12 1 2 3 4 5 6 7 8 9 10 11 ) ///
				label(12 "Mean") ///
				label(1 "(90,100]") ///
				label(2 "(80,90]") ///
				label(3 "(70,80]") ///
				label(4 "(60,70]") ///
				label(5 "(50,60]") ///
				label(6 "(40,50]") ///
				label(7 "(30,40]") ///
				label(8 "(20,30]") ///
				label(9 "(10,20]") ///
				label(10 "(0,10]") ///
				label(11 "0") ///
				rows(2) rowgap(0.2) size(vsmall)) 
				
