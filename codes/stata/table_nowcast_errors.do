/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Table 2.- Size of Firms’ Nowcast Errors
*****************************************************************************************************/

use "$workingdir/master_file_processed.dta", clear

* This part repeats Coibion, Gorodnichenko, and Kumar (2018) to merge with PPI data and define backcast errors
* See "step204---Figure-04.do" for construction of these variables:
joinby sic2 using "$CGK_2018/PPIdata.dta", unmatched(both)
tab sic2 _merge
drop _merge

joinby sic2 using  "$CGK_2018/PPIdata_2014Q4", unmatched(master)
tab sic2 _merge
drop _merge

gen w4_pii_12m_be = abs(actual_pi_yoy_2014q4 - w4_pii_12m)
gen w4_pi_12m_be  = abs(0.8 - w4_pi_12m)

gen w4_pii_rel_be   = w4_pii_12m_be-w4_pi_12m_be
gen log_pii_be      = log(w4_pii_12m_be)
gen log_pi_be       = log(w4_pi_12m_be)
gen log_rel_be      = log(w4_pii_rel_be)
gen log_competitors = log(w1_competitors)

**** Generate table
bysort agg1: sum w4_pii_12m_be w4_pi_12m_be if w4_pii_12m_be~=. & w4_pi_12m_be~=.
sum w4_pii_12m_be w4_pi_12m_be if w4_pii_12m_be~=. & w4_pi_12m_be~=.

* Create latex table 
encode agg1, gen(agg1_n)
forvalues i = 1/5 {
	local agg1_`i' = ""
	qui summ w4_pii_12m_be if agg1_n == `i' & w4_pii_12m_be~=. & w4_pi_12m_be~=.

	local aux_mean: di %4.2fc `r(mean)'
	local aux_sd:   di %4.2fc `r(sd)'

	local agg1_`i' = "`agg1_`i'' `r(N)' & & `aux_mean' & `aux_sd' &"

	qui summ w4_pi_12m_be if agg1_n == `i' & w4_pii_12m_be~=. & w4_pi_12m_be~=.

	local aux_mean: di %4.2fc `r(mean)'
	local aux_sd:   di %4.2fc `r(sd)'

	local agg1_`i' = "`agg1_`i'' & `aux_mean' & `aux_sd'"

	di "`agg1_`i''"
} 

local agg_t = ""

qui sum w4_pii_12m_be if w4_pii_12m_be~=. & w4_pi_12m_be~=.

local aux_mean: di %4.2fc `r(mean)'
local aux_sd:   di %4.2fc `r(sd)'

local agg1_t = "`agg1_t' `r(N)' & & `aux_mean' & `aux_sd' &"

qui sum w4_pi_12m_be if w4_pii_12m_be~=. & w4_pi_12m_be~=.

local aux_mean: di %4.2fc `r(mean)'
local aux_sd:   di %4.2fc `r(sd)'

local agg1_t = "`agg1_t' & `aux_mean' & `aux_sd'"
di "`agg1_t'"


* ---------------------------------------------------------------------------- *
* Table 2: Size of Firms’ Nowcast Errors
	texdoc i "$outdir/Table_2.tex", replace force 
	tex \begin{tabular}{lccccccc} \hline\hline
	tex  & \emph{Observations} &  & \multicolumn{2}{c}{\emph{Industry inflation}} &  & \multicolumn{2}{c}{\emph{Aggregate inflation}}\tabularnewline \cline{2-2}\cline{4-5} \cline{7-8} 
	tex &  &  & \emph{mean} & \emph{std} &  & \emph{mean} & \emph{std}\\
	tex Industry & (1) & & (2) & (3) & & (4) & (5) \\ \hline
	tex Construction       & `agg1_1' \\
	tex Manufacturing      & `agg1_2' \\
	tex Financial Services & `agg1_3' \\
	tex Trade              & `agg1_4' \\ \hline
	tex Total              & `agg1_t' \\ \hline\hline
	tex \end{tabular}
	texdoc close 
* ---------------------------------------------------------------------------- *