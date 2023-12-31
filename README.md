This repository contains the replication files for [Afrouzi (2023)](https://afrouzi.com/strategic_inattention.pdf) titled "Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money."

## Replication instructions
The file `main.m` is the primary file for replication of results generated by Matlab. The code is automated and can be customized to replicate any desired result using the switches on lines 19 to 32. To re-solve and/or re-calibrate any specific model or to replicate figures and tables, simply assign the value of `'Y'` to its corresponding switch and run the `main.m` file. 

Similarly, the file `main.do` is the primary file for replication of results generated by Stata. To get started, open this file and replace the global variables `project_dir` with the path to the folder containing these replication files in line 31. The rest of the code is automated and can be customized to replicate any desired result using the switches on lines 43 to 63. To replicate a specific table or figure, simply assign the value of 1 to its corresponding switch and run the `main.do` file. Note that the code requires several packages. If you face any errors regarding missing packages, you can install them by uncommenting lines 20 to 24 of the `main.do` file and running this file once.  

The `main.do` and `main.m` files are sufficient for all replications. They call the following files from the repository that are stored in the structure presented at the bottom of this README file. I have also included a short description of what each file is used for. For more information, see preamble of files or please reach out to me at [ha2475@columbia.edu](mailto:ha2475@columbia.edu).

## Data sources
The folder `input` contains all the data used in this project. These are all publicly available and were obtained from the following sources:
* [Coibion, Gorodnichenko and Kumar, 2018](https://www.aeaweb.org/articles?id=10.1257/aer.20151299) (CGK_2018): https://doi.org/10.1257/aer.20151299
* [Coibion, Gorodnichenko, Kumar and Ryngaert, 2021](https://doi.org/10.1093/qje/qjab005) (CGKR_2021): https://doi.org/10.7910/DVN/IAEJDU
* New Zealand Gross Domestic Product: https://www.rbnz.govt.nz/statistics/series/economic-indicators/gross-domestic-product (downloaded on Nov 27, 2022)
* ANZSIC codes (used for classification of industries in processing the data): https://en.wikipedia.org/wiki/Australian_and_New_Zealand_Standard_Industrial_Classification

## Code sources
The folder `codes/matlab/Library` contains the following software packages and codes that were not written by me as a part of this project. The source links and references for these codes are:
* [DRIPs.m @ commit 2c87541](https://github.com/choongryulyang/DRIPs.m/tree/2c87541c3fcbdc1265f02fb29698f707c5825773): for solving dynamic rational inattention problems by [Afrouzi and Yang (2019)](https://afrouzi.com/dynamic_inattention/draft_2021_04.pdf)
* [ztran @ commit ad3ff19](https://github.com/econdojo/ztran/tree/ad3ff19a0cc4f7005cdc5fe8b27c7b2f57a1c6d1): for solving imperfect informtion models used here for ARMA approximation method by 


	Tan, Fei and Wu, Jieran, z-Tran: MATLAB Software for Solving Dynamic Incomplete Information Models (August 22, 2023)
* `neldmead_bounds.m`: Nelder-Mead optimization with bounds for parameters, originally by H.P. Gavin (see preamble of the file for reference).

```
┣ 📜main.m
┣ 📜main.do
┣ 📜README.md
┣ 📜LICENSE.md
┣ 📂codes
┃ ┣ 📂matlab (all matlab codes used by main.m)
┃ ┃ ┣ 📂Library (code not written by me as a part of this project)
┃ ┃ ┃ ┣ 📂DRIPs.m (for solving dynamic rational inattention problems by Afrouzi and Yang, 2019 --- see below for source link)
┃ ┃ ┃ ┣ 📂ztran (for solving imperfect information models Tan and Wu, 2023, used here for ARMA approximation solution method --- see below for source link)
┃ ┃ ┃ ┗ 📜neldmead_bounds.m (for Nelder-Mead optimization with bounds on parameters --- see preamble for source)
┃ ┃ ┣ 📜arima_approx.m (for arima approximation of a process with a unit root)
┃ ┃ ┣ 📜calib_eval.m (evaluates the GMM loss)
┃ ┃ ┣ 📜calibrate.m (optimizes loss function to find parameters that match moments)
┃ ┃ ┣ 📜figure_appendix_cap.m (generates appendix figures for capacity of information processing across counterfactuals)
┃ ┃ ┣ 📜figure_arma_comparison.m (generates figure J.1)
┃ ┃ ┣ 📜figure_capacities.m (generates Figure A.4)
┃ ┃ ┣ 📜figure_concentration_multipliers.m (generates Figure 2)
┃ ┃ ┣ 📜figure_higher_order.m (generates Figure A.7)
┃ ┃ ┣ 📜figure_identification.m (generates Figure A.3)
┃ ┃ ┣ 📜figure_irfs.m (generates Figure A.5)
┃ ┃ ┣ 📜figure_str_comps.m (generates Figure A.6)
┃ ┃ ┣ 📜figure_uncer_vs_K.m (generates Figure 1)
┃ ┃ ┣ 📜find_alpha.m (returns array of strategic complementarities as a function of K in different models)
┃ ┃ ┣ 📜find_gamma.m (externally calibrates curvature of profit function to targets average strategic complementarity moment)
┃ ┃ ┣ 📜interpolate_irfs.m (interpolates irfs on a finer time grid)
┃ ┃ ┣ 📜KY_conjugate.m (solves Kalman-Yakubovich equation as a fast method to generate Figure A.7)
┃ ┃ ┣ 📜omega_norm.m (finds appropriate normalization of cost of attention to standardize attention problem)
┃ ┃ ┣ 📜simulate.m (returns simulated panel data for firms' expectations given a model solution)
┃ ┃ ┣ 📜solve_model_arima.m (solves the model for one set of parameters given arima approximation method)
┃ ┃ ┣ 📜solve_model_int_ma.m (solves the model for one set of parameters given integrated MA trunction)
┃ ┃ ┣ 📜solve_models_arima.m (solves the model for an array of parameters using solve_model_arima.m)
┃ ┃ ┣ 📜solve_models_int_ma.m (solves the model for an array of parameters using solve_model_int_ma.m)
┃ ┃ ┣ 📜solve.m (wrapping function for all solvers that solves the model given a method and solution options)
┃ ┃ ┣ 📜table_appendix.m (generates appendix tables for output and inflation acrosss models)
┃ ┃ ┣ 📜table_calibration.m (generates Table 3)
┃ ┃ ┣ 📜table_decomposition.m (generates Table 6)
┃ ┃ ┣ 📜table_inflation.m (generates Table 5)
┃ ┃ ┣ 📜table_output.m (generates Table 4)
┃ ┃ ┗ 📜var.m (a tiny function to calculate inner product of vector with itself)
┃ ┣ 📂stata
┃ ┃ ┣ 📜appendix_D.do (replicates Figure D.1 and Table D.1)
┃ ┃ ┣ 📜figure_binscatter_data.do (replicates binscatter plot data in Figure 1)
┃ ┃ ┣ 📜figure_hist_K.do (replicates Figure A.1)
┃ ┃ ┣ 📜figure_nowcast_errors.do (replicates Figure A.2)
┃ ┃ ┣ 📜gen_Kdist.do (generates calibration of distribution of K in shares.csv used in solving the model)
┃ ┃ ┣ 📜nz_ngdp.do (replicates moments for new zealand nominal GDP)
┃ ┃ ┣ 📜process_data.do (processes publicly available data to be used in replication of stata results)
┃ ┃ ┣ 📜table_calib_eta.do (replicates Tables I.1 and L.1)
┃ ┃ ┣ 📜table_calib_omega.do (replicates Table A.2)
┃ ┃ ┣ 📜table_K_alpha_sumstats.do (replicates Table A.1)
┃ ┃ ┣ 📜table_nowcast_errors.do (replicates Table 2)
┃ ┃ ┗ 📜table_uncertainty_reg.do (replicates Table 1)
┣ 📂workingdir (contains interim stored results generated by the code)
┃ ┣ 📜atkeson_burstein.mat (stored calibrated solutions of models with Atkeson Burstein preferences)
┃ ┣ 📜binscatter_subjective_uncertainty.csv (generated by figure_binscatter_data.do above)
┃ ┣ 📜binscatter_subjective_uncertainty.csv.do (generated by figure_binscatter_data.do above)
┃ ┣ 📜bm_arma.mat (stored solution of calibrated benchmark model using ARMA approximation method)
┃ ┣ 📜bm.mat (stored calibrated solution of the benchmark model using integrated MA trunction method)
┃ ┣ 📜cf_Table_6.mat (solution of counterfactual used in decomposition in Table 6)
┃ ┣ 📜cf_Table_L3.mat (solution of counterfactual used in decomposition in Table L.3)
┃ ┣ 📜cf_Table_L5.mat (solution of counterfactual used in decomposition in Table L.5)
┃ ┣ 📜cf_Table_M3.mat (solution of counterfactual used in decomposition in Table M.3)
┃ ┣ 📜K_and_alpha.dta (processed data for stata results)
┃ ┣ 📜master_file_processed.dta (processed data for stata results)
┃ ┣ 📜matlab_log.txt (MATLAB log file for calibration of all models)
┃ ┣ 📜robust_beta.mat (stored calibrated solution of the model in Table M1b)
┃ ┣ 📜robust_idio.mat (stored calibrated solution of the model in Table M.2)
┃ ┣ 📜robust_rho.mat (stored calibrated solution of the model in table M1a)
┃ ┗ 📜shares.csv (generated by gen_Kdist.do)
┣ 📂input (contains data from public sources and other publshed work --- see below for source links)
┃ ┣ 📂CGK_2018 (replication files from Cobion, Gorodnichenko, and Kumar, 2018)
┃ ┣ 📂CGKR_2021 (replication files from Coibion, Gorodnichenko, Kumar, and Ryngaert, 2021)
┃ ┣ 📜hm5.xlsx (public data for New Zealand nominal GDP)
┣ 📂out (contains automatically generated results)
┃ ┣ 📜Figure_1.eps
┃ ┣ 📜Figure_2.eps
┃ ┣ 📜Figure_A1.eps
┃ ┣ 📜Figure_A2.eps
┃ ┣ 📜Figure_A3.eps
┃ ┣ 📜Figure_A4.eps
┃ ┣ 📜Figure_A5.eps
┃ ┣ 📜Figure_A6.eps
┃ ┣ 📜Figure_A7.eps
┃ ┣ 📜Figure_D1_q10.eps
┃ ┣ 📜Figure_D1_q4.eps
┃ ┣ 📜Figure_J1.eps
┃ ┣ 📜Figure_L1.eps
┃ ┣ 📜Figure_L2.eps
┃ ┣ 📜Figure_M1.eps
┃ ┣ 📜Table_1.tex
┃ ┣ 📜Table_2.tex
┃ ┣ 📜Table_4.tex
┃ ┣ 📜Table_5.tex
┃ ┣ 📜Table_6.tex
┃ ┣ 📜Table_A1.tex
┃ ┣ 📜Table_A2.tex
┃ ┣ 📜Table_D1.tex
┃ ┣ 📜Table_I1.tex
┃ ┣ 📜Table_J1.tex
┃ ┣ 📜Table_J2.tex
┃ ┣ 📜Table_J3.tex
┃ ┣ 📜Table_L1.tex
┃ ┣ 📜Table_L2.tex
┃ ┣ 📜Table_L3.tex
┃ ┣ 📜Table_L4.tex
┃ ┣ 📜Table_L5.tex
┃ ┣ 📜Table_M1a.tex
┃ ┣ 📜Table_M1b.tex
┃ ┣ 📜Table_M2.tex
┃ ┣ 📜Table_M3.tex
┗ ┗ 📜Test_MMW_replication.eps (replication of Figure 6 in Matejka, Mackowiak, and Wiederholt, 2018)
```
