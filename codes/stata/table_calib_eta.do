 /****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Tables I.1 and L.1.- Calibration of η and σ
*****************************************************************************************************/

use "$workingdir/master_file_processed", clear

gen mu_a = 1+w1_margin_average/100

label var mu_a "Average Markup"

gen KKinv = (1+w1_competitors)/(w1_competitors)

label var KKinv "$1/(1-K^{-1})$"

encode agg1, gen(agg1_n)
label define agg1l 1 "Construction" 2 "Manufacturing" 3 "Professional and Financial Services" 4 "Trade" 5 "Other"

label values agg1_n agg1l
label var w1_age "Firm age"

if $tableI1 {
	eststo clear

	eststo: reg mu_a KKinv, robust 
	eststo: xi: reg mu_a KKinv w1_age i.agg1, robust
	esttab using "$outdir/Table_I1.tex", wide b(3) se label nostar nonote replace
}

* generate 1/(mu - 1):
gen mu_hat = 1/(mu_a-1) 
label var mu_hat "$1/(\mu-1)$"

* generate 1-1/K:
gen Kinv_hat = 1-1/(1+w1_competitors)
label var Kinv_hat "$1-K^{-1}$"

* note that mu_hat = sigma - 1 + (eta-sigma)*(1-1/K)
if $tableL1 {
	eststo clear
	eststo: reg mu_hat Kinv_hat, robust 
	eststo: xi: reg mu_hat Kinv_hat i.agg1, robust
	esttab using "$outdir/Table_L1.tex", wide b(3) se label nostar replace
}
