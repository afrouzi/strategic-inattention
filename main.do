/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Master do file for STATA replication materials
* Note: Before running this file please maje sure the data for CGK (2018) and CGKR (2021) are included in the "input" folder (as described in the README.md file)
*****************************************************************************************************/

*****************************************************************************
*  HOUSEKEEPING
*****************************************************************************

clear all 
set more off

********************************************************************************
* UNCOMMENT TO INSTALL REQUIRED PACKAGES ON YOUR COMPUTER
********************************************************************************

/* ssc install grstyle
ssc install texdoc
ssc install estout
ssc install tabout
ssc install gtools
net install binscatter2, from("https://raw.githubusercontent.com/mdroste/stata-binscatter2/master/") */

********************************************************************************
* SET PATHS AND OTHER MACROS	
********************************************************************************

global project_dir "/path/to/strategic-inattention"

global codes      = "$project_dir/codes/stata"
global input      = "$project_dir/input"
global workingdir = "$project_dir/workingdir"
global outdir     = "$project_dir/out"
global CGK_2018   = "$input/CGK_2018/data/workfiles"
global CGKR_2021  = "$input/CGKR_2021/workfiles"

********************************************************************************
*  CODE MACROS
********************************************************************************
global process = 1 // Process data and generate aux variables for analysis

* TABLES
global table1  = 1 // Table 1:   Subjective Uncertainty of Firms and the Number of Competitors
global table2  = 1 // Table 2:   Size of Firms’ Nowcast Errors
global tableA1 = 1 // Table A.1: Summary Statistics for Number of Competitors and Strategic Complementarity by Industry
global tableA2 = 1 // Table A.2: Calibration of Cost of Attention (ω)
global tableD1 = 1 // Table D.1: Differential Strategic Complementarity by 1/K Quantiles
global tableI1 = 1 // Table I.1: Calibration of eta
global tableL1 = 1 // Table L.1: Calibration of eta and sigma for Atkeson-Burstein Preferences


* FIGURES
global figure1   = 1 // Figure 1: Binned Scatter Plot Data for Subjective Uncertainty vs. Number of Competitors
global figureA1  = 1 // Figure A.1: Distribution of the Number of Competitors
global figureA2  = 1 // Figure A.2: Distributions of the Size of Firms’ Nowcast Errors
global figureD1  = 1 // Figure D.1: Strategic Complementarity as a Function of 1/K

* OTHER
global nz_ngdp  = 1 // Footnotes 57/58: Calibration of rho and sigma_u
global Kdist    = 1 // Generate distribution of number of competitors for claibration

********************************************************************************
*  RUN CODES
********************************************************************************

* -----------------------------------------------------------------------------
* TABLES

if ${process}  do "$codes/process_data"
if ${table1}   do "$codes/table_uncertainty_reg"
if ${table2}   do "$codes/table_nowcast_errors"
if ${tableA1}  do "$codes/table_K_alpha_sumstats"
if ${tableA2}  do "$codes/table_calib_omega"
if ${tableD1}  do "$codes/appendix_D"
if ${tableI1}  do "$codes/table_calib_eta"
if ${tableL1}  do "$codes/table_calib_eta"
* -----------------------------------------------------------------------------


* -----------------------------------------------------------------------------
* FIGURES

if ${figure1}   do "$codes/figure_binscatter_data"
if ${figureA1}  do "$codes/figure_hist_K"
if ${figureA2}  do "$codes/figure_nowcast_errors"
if ${figureD1}  do "$codes/appendix_D"
* -----------------------------------------------------------------------------

* -----------------------------------------------------------------------------
* OTHER

if ${nz_ngdp}     do "$codes/nz_ngdp"
if ${Kdist}       do "$codes/gen_Kdist"
* -----------------------------------------------------------------------------
