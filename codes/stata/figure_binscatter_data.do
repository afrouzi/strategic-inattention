/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Figure 1.- Data for the binscatter plot of subjective unc vs. 1/K
* Last Modified on 09/27/2023 by Hassan Afrouzi
*****************************************************************************************************/
use "$workingdir/master_file_processed.dta", clear

gen log_epi_sd   = log(w6_epi_12m_sd)
egen log_epi_sd_m = mean(log_epi_sd)
replace log_epi_sd = log_epi_sd - log_epi_sd_m
gen log_K = log(w6_competitors + 1)

**** bin scatter
binscatter2 log_epi_sd log_K, n(20) /// 
	absorb(industry_1) controls(w6_employment_main w6_firm_age) ///
	savedata("$workingdir/binscatter_subjective_uncertainty") replace