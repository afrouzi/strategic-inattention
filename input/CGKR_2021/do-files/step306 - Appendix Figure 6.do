clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"



gen MNFG=0
replace MNFG=1 if industry=="Manufacturing"

gen CONSTRUCTION=0
replace CONSTRUCTION=1 if industry=="Construction" | industry=="Construction and Transportation"

gen SERVICES=1 - MNFG - CONSTRUCTION


gen flag1=1 /* full sample */
gen flag2=(MNFG==1) /* Manufacturing sample */
gen flag3=(SERVICES==1) /* Services sample */
gen flag4=(CONSTRUCTION==1) /* Construction sample */

gen flag5=(w8_empl<=10) if w8_empl~=.
gen flag6=(w8_empl>10 & w8_empl<=49) if w8_empl~=.
gen flag7=(w8_empl>=50) if w8_empl~=.

gen flag8=(w8_manager_educ==1 | w8_manager_educ==2 | w8_manager_educ==3) /*some college or less*/
gen flag9=(w8_manager_educ==4) /*College Diploma*/
gen flag10=(w8_manager_educ==5) /*Graduate Studies (Masters or PhD)*/

gen flag11=(w8_manager_gender==0) /*males*/ 
gen flag12=(w8_manager_gender==1) /*females*/ 

gen flag13=(w8_age<=10) /*firm age*/ 
gen flag14=(w8_age>10 & w8_age<=25) 
gen flag15=(w8_age>25) 

gen flag16=(w8_manager_tenure_industry<=15) /*tenure (experience) in the industry*/ 
gen flag17=(w8_manager_tenure_industry>15 & w8_manager_tenure_industry<=29) 
gen flag18=(w8_manager_tenure_industry>29) 

gen flag19=(w8_competitors<=2) /*tenure (experience) in the industry*/ 
gen flag20=(w8_competitors>2 & w8_competitors<=10) 
gen flag21=(w8_competitors>10) 



tempname 2
postfile `2'  str10 sample ///
	str20 bin ///
	binN ///
    str10 FO ///
	str10 HO ///
	str10 FO_minus_HO ///
	using "FO_HO_descriptive_stats.dta", replace every(1)
	
							
						
forvalues smpl0=1(1)21 {	
	local cc=16
quiet foreach i in  25plus  15_25 10_15  8_10 6_8  4_6  2_4  0_2 /// /* loop over survey questions */
			  0_neg2  neg2_neg4 neg4_neg6  neg6_neg8 neg8_neg10  neg10_neg15 neg15_neg25  moreneg25 /// 
			{

				 capture drop diff_`i'
				 gen diff_`i'=w8_epi_12m_`i' - w8_epi_ho_12m_`i'
				 
				 *** First order beliefs
				 sum w8_epi_12m_`i' if flag`smpl0'==1
				 local FO_mean=string(r(mean),"%3.1f")
				 local FO_sd="(" + string(r(sd),"%3.1f") + ")"
				 
				 *** Higher order beliefs
				 sum w8_epi_ho_12m_`i' if flag`smpl0'==1
				 local HO_mean=string(r(mean),"%3.1f")
				 local HO_sd="(" + string(r(sd),"%3.1f") + ")"	
				 
				 *** Difference
				 sum diff_`i' if flag`smpl0'==1
				 local diff_mean=string(r(mean),"%3.1f")
				 local diff_sd="(" + string(r(sd),"%3.1f") + ")"					 
				 
				 post `2' ("`smpl0'") ("`i'") (`cc') ("`FO_mean'") ("`HO_mean'") ("`diff_mean'") 
				 post `2' (" ") (" ")  (`cc')  ("`FO_sd'") ("`HO_sd'") ("`diff_sd'") 
				  
				local cc=`cc'-1
				 
			}
}			
postclose `2'	

use FO_HO_descriptive_stats, clear		

gen FOn=FO
destring FOn, force replace

gen HOn=HO
destring HOn, force replace

gen FO_minus_HOn=FO_minus_HO
destring FO_minus_HOn, force replace


drop if FOn==.

destring sample, force replace

*===============================================================================
*						results by industry
*===============================================================================
twoway   ///
		(line FO_minus_HOn binN if sample==2,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==3,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==4,   lcolor(green) lwidth(thin)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "Manufacturing") ///
				label(2 "Services") ///
				label(3 "Construction") ///
				label(4 "All") ///
				ring(0) position(7) rows(4) rowgap(0.1) size(small) lcolor(none) symysize(small)  ) ///
		title("Panel A: Difference by industry", size(small))	///	
		name(fig1Bx, replace)	
		
		
	
*===============================================================================
*						results by number of competitors
*===============================================================================	
twoway   ///
		(line FO_minus_HOn binN if sample==19,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==20,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==21,   lcolor(green) lwidth(thin)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "[1,2]") ///
				label(2 "[3,10]") ///
				label(3 "[11,100]") ///
				label(4 "All") ///
				ring(0) position(7) rows(8) rowgap(0.2) size(small) lcolor(none) symysize(small)  ) ///
		title("Panel B: Difference by the number of competitors", size(small))	///	
		name(fig2Bx, replace)	
		

*===============================================================================
*						results by firm size
*===============================================================================
twoway   ///
		(line FO_minus_HOn binN if sample==5,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==6,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==7,   lcolor(green) lwidth(thin)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "[6,10]") ///
				label(2 "[11,49]") ///
				label(3 "50 or more") ///
				label(4 "All") ///
				ring(0) position(7) rows(8) rowgap(0.2) size(small) lcolor(none) symysize(small)  ) ///
		title("Panel C: Difference by the number of employees", size(small))	///	
		name(fig3Bx, replace)		
		
		
	
*===============================================================================
*			Panels by managerial characteristics
*===============================================================================

*===============================================================================
*			Panels by manager education
*===============================================================================
	
twoway   ///
		(line FO_minus_HOn binN if sample==8,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==9,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==10,   lcolor(green) lwidth(thin)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "Some college or less") ///
				label(2 "College degree") ///
				label(3 "Graduate degree") ///
				label(4 "All") ///
				ring(0) position(7) rows(8) rowgap(0.2) size(small) lcolor(none) symysize(small) ) ///
		title("Panel D: Difference by manager education", size(small))	///	
		name(fig4Bx, replace)		

*===============================================================================
*			Panels by manager experience
*===============================================================================		
twoway   ///
		(line FO_minus_HOn binN if sample==16,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==17,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==18,   lcolor(green) lwidth(thin)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "[1,15]") ///
				label(2 "[16,29]") ///
				label(3 "[30,50]") ///
				label(4 "All") ///
				ring(0) position(7) rows(8) rowgap(0.2) size(small) lcolor(none) symysize(small)  ) ///
		title("Panel E: Difference by manager tenure", size(small))	///	
		name(fig5Bx, replace)		

*===============================================================================
*			Panels by manager geneder
*===============================================================================
						
twoway   ///
		(line FO_minus_HOn binN if sample==11,   lcolor(red) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==12,   lcolor(blue) lpattern(longdash)) ///
		(line FO_minus_HOn binN if sample==1,   lcolor(black) lwidth(thick)) ///
	   , ///
	   xlabel(1 "(-{&infin},-25)" 2 "[-25,-15)" 3 "[-15,-10)" 4 "[-10,-8)" 5 "[-8,-6)" 6 "[-6,-4)" 7 "[-4,-2)" 8 "[-2,0)" 9 "[0,2)" 10 "[2,4)" 11 "[4,6)" 12 "[6,8)" 13 "[8,10)" 14 "[10,15)" 15 "[15,25)" 16 "[25,+{&infin})", angle(30) labsize(small)) ///
	   graphregion(color(white)) bgcolor(white) ///
	   xtitle("") ///
	   ytitle("Average probability", size(small)) ///
	   legend(order(1 2 3 4  ) ///
				label(1 "Male") ///
				label(2 "Female") ///
				label(3 "All") ///
				ring(0) position(7) rows(8) rowgap(0.2) size(small) lcolor(none) symysize(small) ) ///
		title("Panel F: Difference by manager gender", size(small))	///	
		name(fig6Bx, replace)		
						
						
						
*===============================================================================
*			Combine graphs
*===============================================================================


	
graph combine fig1Bx fig4Bx fig2Bx fig5Bx fig3Bx   fig6Bx , ///
	rows(3)	imargin(tiny) ///
	ysize(23) xsize(30) ///
	graphregion(color(white)) ///
	name(fig_difference, replace)	
