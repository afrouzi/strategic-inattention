clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

*** inflation expectations
quiet foreach ww in w8 { /* loop over waves */
		foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
					   0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
				   {

				 gen `ww'_epi_diff_`i'=`ww'_epi_12m_`i' - `ww'_epi_ho_12m_`i'
	}
}


tempname 2
postfile `2'  str10 wave ///
	str20 bin ///
    p_m100_m80 p_m80_m60 p_m60_m40 p_m40_m20 p_m20_m0 p_0 ///
	p_0_20 p_20_40 p_40_60 p_60_80 p_80_100 mm ///
	using "FO_minus_HO.dta", replace every(1)
	
gen WGT=1

quiet foreach ww in w8 { /* loop over waves */
		foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
					   0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
				   {

				   
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<-80 & `ww'_epi_diff_`i'>=-100 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_m100_m80=r(N)
		
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<-60 & `ww'_epi_diff_`i'>=-80 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_m80_m60=r(N)		
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<-40 & `ww'_epi_diff_`i'>=-60 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_m60_m40=r(N)	
				 
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<-20 & `ww'_epi_diff_`i'>=-40 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_m40_m20=r(N)	
		
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<0 & `ww'_epi_diff_`i'>=-20 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_m20_m0=r(N)	
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'==0 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_0=r(N)	
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<=20 & `ww'_epi_diff_`i'>0 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_0_20=r(N)					 
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<=40 & `ww'_epi_diff_`i'>20 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_20_40=r(N)					 
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<=60 & `ww'_epi_diff_`i'>40 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_40_60=r(N)		
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<=80 & `ww'_epi_diff_`i'>60 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_60_80=r(N)		
				 
				 sum `ww'_epi_diff_`i' if `ww'_epi_diff_`i'<=100 & `ww'_epi_diff_`i'>80 & `ww'_epi_ho_12m_`i'~=. , d
				 local p_80_100=r(N)	
					 
				 
				 sum `ww'_epi_diff_`i' , d
				local mm=r(mean)
				 
				 post `2' ("`ww'") ("`i'") (`p_m100_m80') (`p_m80_m60') (`p_m60_m40') (`p_m40_m20') (`p_m20_m0') ///
						(`p_0') ///
						(`p_0_20') (`p_20_40') (`p_40_60') (`p_60_80') (`p_80_100') (`mm')
				 
	}
}	

postclose `2'


   
*===============================================================================
**  Plot distribution for each type of expectations
*===============================================================================
use FO_minus_HO, clear
gen t=_n
gen t1=17-t

gen cp_80_100=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 + p_0_20 + p_20_40 + p_40_60 + p_60_80 + p_80_100
gen cp_60_80=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 + p_0_20 + p_20_40 + p_40_60 + p_60_80
gen cp_40_60=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 + p_0_20 + p_20_40 + p_40_60 
gen cp_20_40=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 + p_0_20 + p_20_40
gen cp_0_20=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 + p_0_20 
gen cp_0=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 + p_0 
gen cp_m20_m0=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 + p_m20_m0 
gen cp_m40_m20=p_m100_m80 + p_m80_m60 + p_m60_m40 + p_m40_m20 
gen cp_m60_m40=p_m100_m80 + p_m80_m60 + p_m60_m40 
gen cp_m80_m60=p_m100_m80 + p_m80_m60 
gen cp_m100_m80=p_m100_m80 



foreach var in p_m100_m80 p_m80_m60 p_m60_m40 p_m40_m20 p_m20_m0 p_0 ///
	p_0_20 p_20_40 p_40_60 p_60_80 p_80_100 {
	replace c`var'=c`var'/1032*100
}

	
	
twoway (bar cp_80_100 t1, fcolor(gs3) lcolor(none) ) ///
	   (bar cp_60_80 t1, fcolor(gs4) lcolor(none)  ) ///
	   (bar cp_40_60 t1, fcolor(gs5) lcolor(none)  ) ///
	   (bar cp_20_40 t1, fcolor(gs6) lcolor(none)  ) ///
	   (bar cp_0_20 t1, fcolor(gs7) lcolor(none)  ) ///
	   (bar cp_0 t1, fcolor(gs15) lcolor(none)  ) ///
	   (bar cp_m20_m0 t1, fcolor(gs9) lcolor(none)  ) ///
	   (bar cp_m40_m20 t1, fcolor(gs10) lcolor(none)  ) ///
	   (bar cp_m60_m40 t1, fcolor(gs11) lcolor(none)  ) ///
	   (bar cp_m80_m60 t1, fcolor(gs12) lcolor(none)  ) ///
	   (bar cp_m100_m80 t1, fcolor(gs13) lcolor(none)  ) ///
	   (scatter mm t1, msymbol(o) mfcolor(red) mlcolor(red) yaxis(2) connect(direct) lcolor(red)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(40)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Probability distribution" " ") ///
	   ylabel(0(20)100) ///
	   ytitle("Mean difference between HO and FO probability", axis(2) color(red)) ///
	   ylabel(-20(10)20, axis(2) labcolor(red)) ///
	   legend(order(12 1 2 3 4 5 6 7 8 9 10 11 ) ///
				label(12 "Mean") ///
				label(1 "[-100,-80)") ///
				label(2 "[-80,-60)") ///
				label(3 "[-60,-40)") ///
				label(4 "[-40,-20)") ///
				label(5 "[-20,0)") ///
				label(6 "0") ///
				label(7 "(0,20]") ///
				label(8 "(20,40]") ///
				label(9 "(40,60]") ///
				label(10 "(60,80]") ///
				label(11 "(80,100]") ///
				rows(2) rowgap(0.2) size(vsmall)) 
				
