clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

encode w8_exper_group, gen(w8_exper_groupN)

*=============================================================================
*				Compute delta from disagreement
*=============================================================================
program myratio_1, rclass
	version 13
	args y x y1 x1
	confirm var `y'
	confirm var `x'
	confirm var `y1'
	confirm var `x1'	
	tempname ymean yn
	summarize `y'
	scalar `ymean' = r(sd)
	return scalar n_`y' = r(N)
	
	summarize `x'
	scalar delta0=`ymean'/r(sd)
	return scalar delta = `ymean'/r(sd)
	
	*** compute alpha
	reg `y1' `x1'
	capture drop bb
	predict bb, dfbeta(X)
	reg `y1' `x1' if abs(bb)<2/sqrt(e(N)), robust
	tempname alphaN
	scalar `alphaN' = _b[`x1']

	return scalar alpha = `alphaN'

	*** compute phi_x
	scalar phix0 = (1-`alphaN')*delta0/((1-`alphaN')*delta0+1-delta0)
	return scalar phix = (1-`alphaN')*delta0/((1-`alphaN')*delta0+1-delta0) 
	
	
	*** compute kappa_x
	sum `x'
	scalar M1=r(sd)
	scalar kappax0 = ( M1^2/(phix0*delta0)^2 )^(-1)
	return scalar kappax = ( M1^2/(phix0*delta0)^2 )^(-1)

	*** compute kappa_y
	return scalar kappay = kappax0*(1-delta0)/delta0
end

*** Use Afrouzi (JMP), p. 20, top equation

*** measure 1
gen Y=w8_response_dp_own - w8_response_dp_own_fixed
gen X=w8_response_dp_competitor

bootstrap delta=r(delta) alpha=r(alpha) phix=r(phix) kappax=r(kappax) kappay=r(kappay), ///
	reps(1000) nowarn nodots: ///
	myratio_1  ///
		w8_epi_ho_12m_implied w8_epi_12m_implied /// parameters for delta
		Y X




	
	
*=============================================================================
*				Compute delta from uncertainty
*=============================================================================
program myratio_2, rclass
	version 13
	args y x y1 x1
	confirm var `y'
	confirm var `x'
	confirm var `y1'
	confirm var `x1'	
	tempname ymean yn
	summarize `y'
	scalar `ymean' = r(mean)
	return scalar n_`y' = r(N)
	
	summarize `x'
	scalar delta0=`ymean'/r(mean)
	return scalar delta = `ymean'/r(mean)
	
	*** compute alpha
	reg `y1' `x1'
	capture drop bb
	predict bb, dfbeta(X)
	reg `y1' `x1' if abs(bb)<2/sqrt(e(N)), robust
	tempname alphaN
	scalar `alphaN' = _b[`x1']

	return scalar alpha = `alphaN'

	*** compute phi_x
	scalar phix0 = (1-`alphaN')*delta0/((1-`alphaN')*delta0+1-delta0)
	return scalar phix = (1-`alphaN')*delta0/((1-`alphaN')*delta0+1-delta0) 
	
	
	*** compute kappa_x
	sum `x'
	scalar M1=r(mean)
	scalar kappax0 = ( M1^2/(phix0*delta0)^2 )^(-1)
	return scalar kappax = ( M1^2/(phix0*delta0)^2 )^(-1)

	*** compute kappa_y
	return scalar kappay = kappax0*(1-delta0)/delta0
end

bootstrap delta=r(delta) alpha=r(alpha) phix=r(phix) kappax=r(kappax) kappay=r(kappay), ///
	reps(1000) nowarn nodots: ///
	myratio_2  ///
		 w8_epi_ho_12m_implied_std w8_epi_12m_implied_std  /// parameters for delta
		Y X

		

