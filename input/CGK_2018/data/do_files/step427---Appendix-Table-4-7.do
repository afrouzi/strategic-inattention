clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

gen w7_anzsic_code3=floor(w7_anzsic_cod/10)
gen w7_anzsic_code2=floor(w7_anzsic_cod/100)
gen w7_anzsic_code1=floor(w7_anzsic_cod/1000)

 *=======================================================================
 *						controls
 *=======================================================================
 *** capacity utilization
 gen logCU=log(w6_actual_output_all/w6_pot_output_all)
 winsor logCU, gen(logCU_w) p(0.01)
 
 *** employment
 gen lnL=log(w6_employment)
 winsor lnL, gen(lnL_w) p(0.01)
 
 *** slope of the profit function
 gen abs_slope=abs(w6_dy_dp_now / w6_dp_now)
 winsor abs_slope, gen(abs_slope_w) p(0.01)

 *** age of the firm
 gen log_age=log(w6_firm_age)
 
 *** labor cost share
 gen sL=w6_labor_cost_share
 
*** outliers
replace w7_dn_6m=w7_dn_6m-6 if firmid==1589
replace w7_dn_6m=w7_dn_6m+10 if firmid==1992
replace w7_dn_6m=w7_dn_6m+12 if firmid==10552
replace w7_dn_6m=w7_dn_6m-10 if firmid==2172
replace w7_dn_6m=w7_dn_6m+10 if firmid==1723

replace w7_dk_6m=w7_dk_6m-5 if firmid==1589
replace w7_dk_6m=w7_dk_6m+5 if firmid==1723
replace w7_dk_6m=w7_dk_6m-5 if firmid==418

	
	
*=========================================================================
*			estimate treatment effects on "actual realization"
*			the last two waves
*=========================================================================

 gen hasinfo=-1
 replace hasinfo=0 if w6_exp_info=="No"
 replace hasinfo=1 if w6_exp_info=="Yes"
  
 
 
 capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
tempname 1
postfile `1' str20 varx ///
	str25 rho str20 coef str20 coef_se ///
	using Appendix_Table_4_7, replace every(1)
		
quiet foreach var in ///
			w7_dsales_6m w7_dw_6m w7_dmc_6m w7_dk_6m w7_dn_6m w7_dp_main_6m ///
			{

corr `var' w6_epi_12m if hasinfo==0
local rho=strofreal(r(rho),"%4.3f") 

**** differences in levels
reg `var' w6_epi_12m
	
capture drop flag
gen flag=1
capture drop bb
predict bb, dfbeta(w6_epi_12m)
replace flag=0 if abs(bb)>0.5
	
reg `var' w6_epi_12m [aw=w7_wgtE_43] if hasinfo==0, robust cluster(w7_anzsic_code3)

local c4=strofreal(_b[w6_epi_12m],"%4.3f") 
local se4=strofreal(_se[w6_epi_12m],"%4.3f") 
local tval=_b[w6_epi_12m]/_se[w6_epi_12m]
if abs(`tval')<=1.660 local pval4=" "
if abs(`tval')>1.660 local pval4="*"
if abs(`tval')>1.984 local pval4="**"
if abs(`tval')>2.626 local pval4="***"
di "`pval4'"
local c6str="`c4'"+"`pval4'"
local se6str="("+"`se4'"+")"


post `1' ("`var'")  ("`rho'") ("`c6str'") ("`se6str'")

}
	   

*=========================================================================
*			estimate treatment effects on "actual realization"
*			the first two waves
*=========================================================================
* gen w2_dy_main=log(w2_actual_output_main/w1_actual_output_main)*100

gen w2_dy=log(w2_actual_output_all/w1_actual_output_all)*100
gen w2_dp=log(w2_price/w1_price)*100

gen flag2_w2_dy=1 if w1_epi_12m<15 & abs(w2_dy)<35
gen flag2_w2_dp=1 if w1_epi_12m<15 & abs(w2_dy)<35
	
foreach var in ///
			w2_dy w2_dp ///
			{

corr `var' w1_epi_12m [aw=w2_wgtE_43] if w1_epi_12m<15 & abs(`var')<35
local rho=strofreal(r(rho),"%4.3f") 

reg `var' w1_epi_12m [aw=w2_wgtE_43] if w1_epi_12m<15 & abs(`var')<35
* reg `var' w1_epi_12m [aw=w2_wgtE_43] if flag2_`var'==1

* reg w2_dy w1_epi_12m [aw=w2_wgtE_43] if w1_epi_12m<15 & abs(w2_dy)<35

local c4=strofreal(_b[w1_epi_12m],"%4.3f") 
local se4=strofreal(_se[w1_epi_12m],"%4.3f") 
local tval=_b[w1_epi_12m]/_se[w1_epi_12m]
if abs(`tval')<=1.660 local pval4=" "
if abs(`tval')>1.660 local pval4="*"
if abs(`tval')>1.984 local pval4="**"
if abs(`tval')>2.626 local pval4="***"
di "`pval4'"
local c6str="`c4'"+"`pval4'"
local se6str="("+"`se4'"+")"


post `1' ("`var'")  ("`rho'") ("`c6str'") ("`se6str'")

}

postclose `1'

