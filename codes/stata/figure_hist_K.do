/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Figure A.1 - Distribution of the Number of Competitors
*****************************************************************************************************/

* Graph specs
grstyle init
grstyle set plain
graph set eps fontface "Palatino"

* Import data and rename variables
use "$workingdir/master_file_processed.dta", clear

*Fugure A.1
* for the figure drop comeptitors more than 30 (top 1 percent) just for the figure
label var w6_competitors "Number of Competitors"
replace w6_competitors = . if w6_competitors > 30

histogram w6_competitors, width(1) start(0) percent fcolor(edkblue%85) lcolor(edkblue) ///
	lwidth(thin) lalign(inside) addlabel addlabopts(mlabcolor(maroon) yvarformat(%4.1f))  ///
	binrescale xsize(6) ysize(2.5) xlabel(0(2)30) xmtick(0(1)30) ///
	xtitle(Number of Competitors, size(large)) ///
	ytitle(Percent, size(large))

graph export "$outdir/Figure_A1.pdf", as(pdf) replace 
graph export "$outdir/Figure_A1.eps", as(eps) replace 

