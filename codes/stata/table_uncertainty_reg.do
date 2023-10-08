/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Table 1.- Subjective Uncertainty of Firms and the Number of Competitors
* Last Modified on 09/27/2023 by Hassan Afrouzi
*****************************************************************************************************/

use "$workingdir/master_file_processed.dta", clear

* Generate logs
sum  w6_epi_12m_sd
gen log_epi_sd = log(w6_epi_12m_sd)
label var log_epi_sd "$\log({\sigma}^{\pi}$)"

gen log_competitors=log(w6_competitors)
label var log_competitors "$\log(K)$"

eststo clear
eststo: reg log_epi_sd log_competitors if industry_1 ~= ., robust
eststo: xi: reg log_epi_sd log_competitors w6_firm_age w6_employment_main i.industry_1, robust
esttab using "$outdir/Table_1.tex", keep(log_competitors) nostar b(3) ///
	order(_cons) se label replace nonote 
