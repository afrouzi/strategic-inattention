/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Generate Table D.1 and Figure D.1 in Appendix D
* Last Modified on: 09/27/2023
*****************************************************************************************************/

use "$workingdir/K_and_alpha.dta", clear

label define industry_values 0 "Manufacturing" 1 "Construction" 2 "Trade" ///
	3 "Financial Services"

gen industry = .
replace industry=0 if anzsiccode<2600  & anzsiccode>1099
replace industry=1 if anzsiccode<3300 & anzsiccode>2999
replace industry=2 if anzsiccode<4400 & anzsiccode>3299
replace industry=3 if anzsiccode>4399

label values industry industry_values

label var K "Number of Competitors"
label var alpha "Strategic Comp."

gen log_K=log(K+1)
label var log_K "log(\#competitors)"

gen K_inv = 1/K 
label var K_inv "Inverse number of competitors"

* Number of obs by K
bys K: egen N_K = count(K)
gen K_count = 1 if !missing(alpha, K)

gquantiles K_q = K, nquantiles(4) xtile
gquantiles K_d = K, nquantiles(10) xtile

gquantiles K_inv_q = K_inv, nquantiles(4) xtile
gquantiles K_inv_d = K_inv, nquantiles(10) xtile

if $figureD1 {

	local color1      = "0 111 185"
	local color2      = "212 81 24"
	local colors      = `" "`color1'" "`color2'" "'

	local second_axis = `"ylabel(none,axis(2)) xlabel(none,axis(2)) xtitle("",axis(2)) ytitle("",axis(2))"'
	local label_size  = "xlabel(, labsize(large)) ylabel(, labsize(large)) ytitle(, size(large)) xtitle(, size(large)) legend(size(large))"


	foreach i in 4 10 {

		grstyle init
		grstyle set plain
		graph set eps fontface "Palatino"

		if `i' == 4 local pan_let = "A"
		else local pan_let = "B"

		binscatter2 alpha K_inv, n(`i') linetype(connect) stdevs(1) control(i.industry) ///
			mcolor("`color1'") lcolor("`color1'") ylabel(0(0.25)1.5, format(%3.1fc)) xlabel(, format(%3.1fc)) ///
			ytitle("Strategic Complementarity ({&alpha})") ///
			xtitle("Inv. Number of Competitors (1/K)") ///
			title("`pan_let' - `i' Bins", size(huge) color(black)) ///
			`label_size' name("n`i'_c_inv", replace)
		gr export "$outdir/Figure_D1_q`i'.pdf", as(pdf) replace
		gr export "$outdir/Figure_D1_q`i'.eps", as(eps) replace
	}
}

if $tableD1 {

	local obs    = "Observations"

	forval r = 1/2 {
		if `r' == 1 local rhs = "c.X##ib4.K_inv_q"
		else local rhs = "c.X##ib4.K_inv_q i.industry"

		qui reg Y `rhs', r 

		matrix vc = e(V)

		local obs_aux:    di %9.0fc e(N)				
		local adj_r2_aux: di %4.2fc e(r2_a)

		local obs    = "`obs'    &   `obs_aux' &"

		qui test _b[X] = 0
		local p: di %12.3fc r(p)
		global star_aux = cond(`p'<.01,"***",cond(`p'<.05,"**",cond(`p'<.1,"*","")))

		local b_aux:  di %5.3fc _b[X]
		local se_aux: di %5.3fc sqrt(vc[1,1])
		local b_x = "`b_x' & `b_aux'$star_aux & (`se_aux')" 

		forval i = 1/3 {

			local ind = `i' + 5

			qui test _b[`i'.K_inv_q#c.X] = 0
			local p: di %12.3fc r(p)
			global star_aux = cond(`p'<.01,"***",cond(`p'<.05,"**",cond(`p'<.1,"*","")))

			local b_aux:  di %5.3fc _b[`i'.K_inv_q#c.X]
			local se_aux: di %5.3fc sqrt(vc[`ind', `ind'])
			
			local be_int`i' = "`be_int`i'' & `b_aux'$star_aux & (`se_aux')"
		}
	}

	macro drop b_int1 b_int2 b_int3 

	* Regress alpha on K_q
	local obs    = "Observations"

	forval r = 1/2 {
		if `r' == 1 local rhs = "ib4.K_inv_q"
		else local rhs = "ib4.K_inv_q i.industry"

		qui reg alpha `rhs', r 

		matrix vc = e(V)

		local obs_aux:    di %9.0fc e(N)				

		local obs    = "`obs'    &   `obs_aux' &"

		qui test _b[_cons] = 0
		local p: di %12.3fc r(p)
		global star_aux = cond(`p'<.01,"***",cond(`p'<.05,"**",cond(`p'<.1,"*","")))

		local b_aux:  di %5.3fc _b[_cons]
		if `r' == 1 local se_aux: di %5.3fc sqrt(vc[5,5])
		else local se_aux: di %5.3fc sqrt(vc[9,9])
		local b_cons = "`b_cons' & `b_aux'$star_aux & (`se_aux')" 

		forval i = 1/3 {

			qui test _b[`i'.K_inv_q] = 0
			local p: di %12.3fc r(p)
			global star_aux = cond(`p'<.01,"***",cond(`p'<.05,"**",cond(`p'<.1,"*","")))

			local b_aux:  di %5.3fc _b[`i'.K_inv_q]
			local se_aux: di %5.3fc sqrt(vc[`i', `i'])
			
			local b_int`i' = "`b_int`i'' & `b_aux'$star_aux & (`se_aux')"
		}
	}


	texdoc i "$outdir\Table_D1.tex", replace force
		tex \begin{tabular*}{0.85\hsize}{@{\hskip\tabcolsep\extracolsep\fill}l*{4}{c}} \toprule
		tex & \multicolumn{4}{c}{Dep. Variable: Strategic Complementarity \$ \alpha \$ } \\ \cline{2-5}
		tex  & \multicolumn{2}{c}{(1)} & \multicolumn{2}{c}{(2)}\\ \midrule
		tex  Constant              `b_cons'            \\
		tex  First Quartile \$1/K\$  `be_int1'           \\ 
		tex  Second Quartile \$1/K\$ `be_int2'           \\ 
		tex  Third Quartile \$1/K\$  `be_int3'           \\ 
		tex  Fourth Quartile \$1/K\$ & - & - & - & -     \\ \midrule 
		tex                        `obs'               \\
		tex Industry dummies      & No & & Yes \\ \bottomrule
		tex \end{tabular*} 
	texdoc close
}
