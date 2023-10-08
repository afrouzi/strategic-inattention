
clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear


*====================================================================
*		importance for business decisions vs follow/don't follow
*====================================================================

tabulate w4_track_pi w4_track_pif [aw=w4_wgtE_43], cell nofreq				   
tabulate w4_track_ue w4_track_uef [aw=w4_wgtE_43], cell nofreq				   
tabulate w4_track_gdp w4_track_gdpf [aw=w4_wgtE_43], cell nofreq				   

tabstat w4_pay_pi [aw=w4_wgtE_43], by(w4_track_pi)
tabstat w4_pay_ue [aw=w4_wgtE_43], by(w4_track_ue)
tabstat w4_pay_gdp [aw=w4_wgtE_43], by(w4_track_gdp)



*====================================================================
*		importance for business decisions vs performance
*====================================================================

					  
 
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into inflation 
egen _rm=rownonmiss(w4_epi_12m_*)

foreach var in 	w4_epi_12m_25plus w4_epi_12m_15_25 w4_epi_12m_10_15 ///
				w4_epi_12m_8_10 w4_epi_12m_6_8 w4_epi_12m_4_6 ///
				w4_epi_12m_2_4 w4_epi_12m_0_2 w4_epi_12m_0_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_epi_12m = 	w4_epi_12m_25plus*30 + w4_epi_12m_15_25*20 + ///
					w4_epi_12m_10_15*12.5 + w4_epi_12m_8_10*9 + ///
					w4_epi_12m_6_8*7 + w4_epi_12m_4_6*5 + ///
					w4_epi_12m_2_4*3 + w4_epi_12m_0_2*1 + ///
					w4_epi_12m_0_minus*(-1)

replace w4_epi_12m=w4_epi_12m/100
	
				
				
gen w4_epi_12m_var = ///
					w4_epi_12m_25plus*(30-w4_epi_12m)^2 + ///
					w4_epi_12m_15_25*(20-w4_epi_12m)^2 + ///
					w4_epi_12m_10_15*(12.5-w4_epi_12m)^2 + ///
					w4_epi_12m_8_10*(9-w4_epi_12m)^2 + ///
					w4_epi_12m_6_8*(7-w4_epi_12m)^2 + ///
					w4_epi_12m_4_6*(5-w4_epi_12m)^2 + ///
					w4_epi_12m_2_4*(3-w4_epi_12m)^2 + ///
					w4_epi_12m_0_2*(1-w4_epi_12m)^2 + ///
					w4_epi_12m_0_minus*(-1-w4_epi_12m)^2

replace w4_epi_12m_var=w4_epi_12m_var/100					

gen w4_epi_12m_std=w4_epi_12m_var^0.5


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into gdp 
egen _rm=rownonmiss(w4_egdp_12m_*)

foreach var in 	w4_egdp_12m_5plus w4_egdp_12m_4_5 w4_egdp_12m_3_4 ///
				w4_egdp_12m_2_3 w4_egdp_12m_1_2 w4_egdp_12m_0_1 ///
				w4_egdp_12m_0_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_egdp_12m = 	w4_egdp_12m_5plus*6 + w4_egdp_12m_4_5*4.5 + ///
					w4_egdp_12m_3_4*3.5 + w4_egdp_12m_2_3*2.5 + ///
					w4_egdp_12m_1_2*1.5 + w4_egdp_12m_0_1*0.5 + ///
					w4_egdp_12m_0_minus*(-0.5)

replace w4_egdp_12m=w4_egdp_12m/100

gen w4_egdp_12m_var = ///
					w4_egdp_12m_5plus*(6-w4_egdp_12m)^2 + ///
					w4_egdp_12m_4_5*(4.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_3_4*(3.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_2_3*(2.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_1_2*(1.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_0_1*(0.5-w4_egdp_12m)^2 + ///
					w4_egdp_12m_0_minus*(-0.5-w4_egdp_12m)^2

replace	w4_egdp_12m_var=w4_egdp_12m_var/100
gen w4_egdp_12m_std=w4_egdp_12m_var^0.5				
	

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** convert probability distribution into UE 
egen _rm=rownonmiss(w4_eue_12m_*)

foreach var in 	w4_eue_12m_8plus w4_eue_12m_7_8 w4_eue_12m_6_7 ///
				w4_eue_12m_5_6 w4_eue_12m_4_5 w4_eue_12m_4_minus ///
				{
				
				replace `var'=0 if `var'==. & _rm>0 & _rm~=.
				}
				
capture drop _rm
				
gen w4_eue_12m = 	w4_eue_12m_8plus*9 + w4_eue_12m_7_8*7.5 + ///
					w4_eue_12m_6_7*6.5 + w4_eue_12m_5_6*5.5 + ///
					w4_eue_12m_4_5*4.5 + w4_eue_12m_4_minus*3 

replace w4_eue_12m=w4_eue_12m/100


gen w4_eue_12m_var = ///
					w4_eue_12m_8plus*(9 - w4_eue_12m)^2 + ///
					w4_eue_12m_7_8*(7.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_6_7*(6.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_5_6*(5.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_4_5*(4.5  - w4_eue_12m)^2 + ///
					w4_eue_12m_4_minus*(3 - w4_eue_12m)^2
					
replace w4_eue_12m_var=w4_eue_12m_var/100
gen 	w4_eue_12m_std=w4_eue_12m_var^0.5
	


 *============================================================================
 * 				calculate nowcast and backcast errors
 *============================================================================
 
 

 * inflation (wave 4)
  gen w4_pi_12m_be = 0.8 - w4_pi_12
  gen w4_pi_12m_be_abs=abs(w4_pi_12m_be)

 * gdp growth rate (the growth rate of GDP is for 2014Q3; UPDATE WHEN MORE DATA COME IN)
 gen w4_gdp_12_be= 2.5 - w4_gdp_12
 gen w4_gdp_12_be_abs=abs(w4_gdp_12_be)


* unemployment (wave 4)
 gen w4_ue_be = 5.7 - w4_ue
 gen w4_ue_be_abs=abs(w4_ue_be)

 
  
*============================================================================
*				backcast errors
*============================================================================

tabstat w4_pi_12m_be_abs [aw=w4_wgtE_43], by(w4_track_pif)
tabstat w4_ue_be_abs [aw=w4_wgtE_43], by(w4_track_uef)
tabstat w4_gdp_12_be_abs [aw=w4_wgtE_43], by(w4_track_gdpf)


*============================================================================
*				forecast
*============================================================================

tabstat w4_epi_12m [aw=w4_wgtE_43], by(w4_track_pif)
tabstat w4_eue_12m [aw=w4_wgtE_43], by(w4_track_uef)
tabstat w4_egdp_12m [aw=w4_wgtE_43], by(w4_track_gdpf)

*============================================================================
*				forecast uncertainty
*============================================================================

tabstat w4_epi_12m_std [aw=w4_wgtE_43], by(w4_track_pif)
tabstat w4_eue_12m_std [aw=w4_wgtE_43], by(w4_track_uef)
tabstat w4_egdp_12m_std [aw=w4_wgtE_43], by(w4_track_gdpf)

