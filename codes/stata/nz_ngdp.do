/****************************************************************************************************
* Afrouzi (2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Footnotes 57 and 58. Calibration of rho and sigma_u
* Last Modified on 09/27/2023 by Hassan Afrouzi
*****************************************************************************************************/

* Note: The file “hm5.xlsx” was downloaded from 
* https://www.rbnz.govt.nz/statistics/series/economic-indicators/gross-domestic-product
* On Nov 27, 2022

import excel "$input/hm5.xlsx", sheet("Data") cellrange(A5:BU146) firstrow case(lower) clear

rename gdeqeyna q

* Obtaining sigma_u 
gen qdate = qofd(seriesid)
gen year = year(seriesid)
gen quarter = quarter(seriesid)
format qdate %tq

tsset qdate
gen dq = ln(q)-ln(L.q)

* seasonal adjustment
reg dq i.quarter

* predicted standard deviations of seasonally adjusted NGDP growth exlcluding pre 1992 (monetary policy changed to inflation targeting in early 1990s). Also exclude post 2020 for COVID effects.
predict dq_ad if year>1991 & year<2020, residuals
sum dq_ad dq if year>1991 & year<2020
* gives a standard deviation of 0.0152 for std. dev. of dq_ad

* Obtaining rho 
collapse (mean) q, by(year)

tsset year

gen dq = ln(q)-ln(L.q)
reg dq L.dq if year>1991 & year<2020, robust
* gives a coefficient of 0.255
