 /****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Purpose: Table A.2- Calibration of Cost of Attention (ω)
* Last Modified on 09/27/2023 by Hassan Afrouzi
*****************************************************************************************************/

use "$workingdir/master_file_processed", clear

label var w4_pi_12m "nowcast"
label var w1_epi_12m "forecast"
label var w4_RBNZ_target "perceived target"

eststo clear
eststo: reg w4_pi_12m w1_epi_12m, robust
eststo: reg w4_pi_12m w1_epi_12m w4_RBNZ_target, robust
esttab using "$outdir/Table_A2.tex", b(3) se labe nostar nonote replace
