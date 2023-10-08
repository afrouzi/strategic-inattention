
clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

*** Classify level-k types for those who do 30+ seconds of thinking on firt level-k question
gen k=.
replace k=0 if w8_kguess_timetrack<20
replace k=0 if w8_kguess>=50 & w8_kguess_timetrack>=20 
* replace k1=0 if w8_kguess_timetrack<20 & abs(w8_kguess-50)<=3 /* k' */

replace k=1 if w8_kguess==33 & w8_kguess_timetrack>=20
replace k=2 if (w8_kguess==22|w8_kguess==26) & w8_kguess_timetrack>=20
replace k=3 if (w8_kguess==15|w8_kguess==14|w8_kguess==12) & w8_kguess_timetrack>=20
replace k=4 if w8_kguess==10 & w8_kguess_timetrack>=20
replace k=5 if w8_kguess<10 & w8_kguess_timetrack>=20


encode w8_exper_group, gen(w8_exper_groupN)

***** Moments by k

sort k

*** Means
by k: egen w8_epi_12m_impliedm=mean(w8_epi_12m_implied)
by k: egen w8_epi_ho_12m_impliedm=mean(w8_epi_ho_12m_implied)

by k: egen w8_epi_12m_experm=mean(w8_epi_12m_exper)
by k: egen w8_epi_ho_12m_experm=mean(w8_epi_ho_12m_exper)

by k: egen w9_epi_12m_impliedm=mean(w9_epi_12m_implied)
by k: egen w9_epi_ho_12m_impliedm=mean(w9_epi_ho_12m_implied)


*** Standard Dev
by k: egen w8_epi_12m_impliedsd=sd(w8_epi_12m_implied)
by k: egen w8_epi_ho_12m_impliedsd=sd(w8_epi_ho_12m_implied)

by k: egen w8_epi_12m_expersd=sd(w8_epi_12m_exper)
by k: egen w8_epi_ho_12m_expersd=sd(w8_epi_ho_12m_exper)

by k: egen w9_epi_12m_impliedsd=sd(w9_epi_12m_implied)
by k: egen w9_epi_ho_12m_impliedsd=sd(w9_epi_ho_12m_implied)


***Uncertainty
by k: egen w8_epi_12m_implied_stdm=mean(w8_epi_12m_implied_std)
by k: egen w8_epi_ho_12m_implied_stdm=mean(w8_epi_ho_12m_implied_std)

by k: egen w9_epi_12m_implied_stdm=mean(w9_epi_12m_implied_std)
by k: egen w9_epi_ho_12m_implied_stdm=mean(w9_epi_ho_12m_implied_std)

*** correlation between low- and high-order expectations
by k: corr w8_epi_12m_implied w8_epi_ho_12m_implied



*** measure 1
gen Y=w8_response_dp_own - w8_response_dp_own_fixed
gen X=w8_response_dp_competitor


gen flag=1
quiet forvalues i=0(1)5 {
	reg Y X if k==`i'
	predict bb`i', dfbeta(X)
	replace flag=0 if abs(bb`i')>2/sqrt(e(N)) & e(sample)
}
	
reg Y i.k##c.X, robust 				/* full sample */
reg Y i.k##c.X if flag==1, robust 	/* exclude outliers */

gen alpha=.
replace alpha=_b[X] if k==0
gen alpha_se=.
replace alpha_se=_se[X] if k==0
forvalues i=1(1)5 {
	lincom X + `i'.k#c.X 
	replace alpha=r(estimate) if k==`i'
	replace alpha_se=r(se) if k==`i'
	
}
	
	
*** slope in the regression
rreg w8_epi_ho_12m_implied i.k##c.w8_epi_12m_implied, nolog 				/* full sample */

reg w8_epi_ho_12m_implied i.k##c.w8_epi_12m_implied, robust 				/* full sample */
gen slopeB=.
replace slopeB=_b[w8_epi_12m_implied] if k==0
gen slopeB_se=.
replace slopeB_se=_se[w8_epi_12m_implied] if k==0
forvalues i=1(1)5 {
	lincom w8_epi_12m_implied + `i'.k#c.w8_epi_12m_implied 
	replace slopeB=r(estimate) if k==`i'
	replace slopeB_se=r(se) if k==`i'
	
}


tabstat w8_epi_12m_impliedm w8_epi_ho_12m_impliedm ///
		w8_epi_12m_impliedsd w8_epi_ho_12m_impliedsd ///
		w8_epi_12m_implied_stdm w8_epi_ho_12m_implied_stdm ///
		alpha alpha_se ///
		slopeB slopeB_se, ///
		by(k) format("%3.2f")
		

*===============================================================================
*				compute moments for k'
*===============================================================================


clear all 
set more off

use workfile_QJE, clear

*** Classify level-k types for those who do 30+ seconds of thinking on firt level-k question
gen k=.
* replace k=0 if w8_kguess_timetrack<20
replace k=0 if w8_kguess>=50 & w8_kguess_timetrack>=20 
replace k=0 if w8_kguess_timetrack<20 & abs(w8_kguess-50)<=3 /* k' */

replace k=1 if w8_kguess==33 & w8_kguess_timetrack>=20
replace k=2 if (w8_kguess==22|w8_kguess==26) & w8_kguess_timetrack>=20
replace k=3 if (w8_kguess==15|w8_kguess==14|w8_kguess==12) & w8_kguess_timetrack>=20
replace k=4 if w8_kguess==10 & w8_kguess_timetrack>=20
replace k=5 if w8_kguess<10 & w8_kguess_timetrack>=20


encode w8_exper_group, gen(w8_exper_groupN)

***** Moments by k

sort k

keep if k==0

*** Means
by k: egen w8_epi_12m_impliedm=mean(w8_epi_12m_implied)
by k: egen w8_epi_ho_12m_impliedm=mean(w8_epi_ho_12m_implied)

by k: egen w8_epi_12m_experm=mean(w8_epi_12m_exper)
by k: egen w8_epi_ho_12m_experm=mean(w8_epi_ho_12m_exper)

by k: egen w9_epi_12m_impliedm=mean(w9_epi_12m_implied)
by k: egen w9_epi_ho_12m_impliedm=mean(w9_epi_ho_12m_implied)


*** Standard Dev
by k: egen w8_epi_12m_impliedsd=sd(w8_epi_12m_implied)
by k: egen w8_epi_ho_12m_impliedsd=sd(w8_epi_ho_12m_implied)

by k: egen w8_epi_12m_expersd=sd(w8_epi_12m_exper)
by k: egen w8_epi_ho_12m_expersd=sd(w8_epi_ho_12m_exper)

by k: egen w9_epi_12m_impliedsd=sd(w9_epi_12m_implied)
by k: egen w9_epi_ho_12m_impliedsd=sd(w9_epi_ho_12m_implied)


***Uncertainty
by k: egen w8_epi_12m_implied_stdm=mean(w8_epi_12m_implied_std)
by k: egen w8_epi_ho_12m_implied_stdm=mean(w8_epi_ho_12m_implied_std)

by k: egen w9_epi_12m_implied_stdm=mean(w9_epi_12m_implied_std)
by k: egen w9_epi_ho_12m_implied_stdm=mean(w9_epi_ho_12m_implied_std)

*** correlation between low- and high-order expectations
by k: corr w8_epi_12m_implied w8_epi_ho_12m_implied

	

*** measure 1
gen Y=w8_response_dp_own - w8_response_dp_own_fixed
gen X=w8_response_dp_competitor


gen flag=1
quiet forvalues i=0(1)0 {
	reg Y X if k==`i'
	predict bb`i', dfbeta(X)
	replace flag=0 if abs(bb`i')>2/sqrt(e(N)) & e(sample)
}
	
reg Y i.k##c.X, robust 				/* full sample */
reg Y i.k##c.X if flag==1, robust 	/* exclude outliers */

gen alpha=.
replace alpha=_b[X] if k==0
gen alpha_se=.
replace alpha_se=_se[X] if k==0

	
*** slope in the regression
rreg w8_epi_ho_12m_implied i.k##c.w8_epi_12m_implied, nolog 				/* full sample */

reg w8_epi_ho_12m_implied i.k##c.w8_epi_12m_implied, robust 				/* full sample */
gen slopeB=.
replace slopeB=_b[w8_epi_12m_implied] if k==0
gen slopeB_se=.
replace slopeB_se=_se[w8_epi_12m_implied] if k==0
	
	
tabstat w8_epi_12m_impliedm w8_epi_ho_12m_impliedm ///
		w8_epi_12m_impliedsd w8_epi_ho_12m_impliedsd ///
		w8_epi_12m_implied_stdm w8_epi_ho_12m_implied_stdm ///
		alpha alpha_se ///
		slopeB slopeB_se, ///
		by(k) format("%3.2f")
		
	