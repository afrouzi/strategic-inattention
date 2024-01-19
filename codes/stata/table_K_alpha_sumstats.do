 /****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Purpose: Table A.2- Calibration of Cost of Attention (ω)
*****************************************************************************************************/

use "$workingdir/K_and_alpha.dta", clear

* Create latex table 
encode industry_2, gen(industry_n)

levelsof industry_n, local(industry_values)
forvalues i=1/25 {
	local label : label (industry_n) `i'
	local industry_`i' = "`label'"
	summ competitors if industry_n == `i'

	local aux_mean: di %4.3fc `r(mean)'
	local aux_sd:   di %4.3fc `r(sd)'

	local industry_`i' = "`industry_`i'' & `r(N)' & & `aux_mean' & `aux_sd' &"

	summ alpha if industry_n == `i'

	local aux_mean: di %4.3fc `r(mean)'
	local aux_sd:   di %4.3fc `r(sd)'

	local industry_`i' = "`industry_`i'' & `aux_mean' & `aux_sd'"
	di "`industry_`i''"
} 

local industry_t = "Total"

qui sum competitors

local aux_mean: di %4.3fc `r(mean)'
local aux_sd:   di %4.3fc `r(sd)'

local industry_t = "`industry_t' & `r(N)' & & `aux_mean' & `aux_sd' &"

qui sum alpha

local aux_mean: di %4.3fc `r(mean)'
local aux_sd:   di %4.3fc `r(sd)'

local industry_t = "`industry_t' & `aux_mean' & `aux_sd'"
di "`industry_t'"


* ---------------------------------------------------------------------------- *
* Table A1: Summary Statistics of the Number of Competitors and Strategic Complementarity
	texdoc i "$outdir/Table_A1.tex", replace force 
	tex \begin{tabular}{lccccccc} \toprule
	tex  & \emph{Observations} & & \multicolumn{2}{c}{\emph{Number of Competitors}} & & \multicolumn{2}{c}{\emph{Strategic Complementarity}} \\ \cline{2-2} \cline{4-5} \cline{7-8}
	tex  & & & \emph{Mean} & \emph{Std. Dev.} & & \emph{Mean} & \emph{Std. Dev.} \\ 
	tex \emph{Industry} & \emph{(1)} & & \emph{(2)} & \emph{(3)} & & \emph{(4)} & \emph{(5)} \\ \midrule
	forvalues i=1/25 {
	tex `industry_`i'' \\
	} 
	tex \midrule 
	tex `industry_t' \\ \bottomrule
	tex \end{tabular}
	texdoc close 
* ---------------------------------------------------------------------------- *
