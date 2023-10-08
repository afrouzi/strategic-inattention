insheet using /Users/afrouzi/Dropbox/Work/Papers/Information_Oligopolies/THE_MARKET/Draft_2019/rep_pkg/workingdir/binscatter_subjective_uncertainty.csv.csv

twoway  (scatter log_epi_sd log_K, mcolor("navy") lcolor("maroon")) (function -.1448615422992647*x+.2856891096554787, range(.6599224209785461 3.188666582107544) lcolor("maroon")) , graphregion(fcolor(white))  xtitle(log_K) ytitle(log_epi_sd) legend(off order())
