% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function optimizes the internally calibrated parameters of the model to match the 
% moments specificed in "glob.moments." The only internally calibrated parameter in the 
% benchmark model is "omega" (cost of attention) to match only one moment; the regression
% coefficient of inflation nowcast on previous inflation forecast across firms. However,
% the code is written to allow for more moments to be matched to calibrate the model in the 
% robustness to discount factor exercise in Appendix M, where "omega" and "delta" are joinly
% calibrated while matching the additional moment on the slope of uncertainty vs. number of 
% competitors according to weights in "options".

function s = calibrate(param, glob, options)
	
	% if user wants to internally calibrate delta, optimize on two params. If not, just optimize on omega.
	% this part uses the Nelder-Mead algorithm to find the optimal value of omega and delta to minimize the 
	% error function specified at the end of this file (See below).
	switch options.calibrate.delta
		case 'Y'
			x = neldmead_bounds(@(x) objective(x, param, glob, options), [param.omega; param.deltas], [0.5; 0], [6; 1]);
			param.omega 	     = x(1);
			param.deltas         = x(2);
		case 'N'
			omega = neldmead_bounds(@(x) objective([x, param.deltas], param, glob, options), param.omega, options.calibrate.omega_l, options.calibrate.omega_u);
			param.omega 	     = omega;
	end

	% once the model is calibrated, also solve the counterfactual economy 
	% where all oligopolies have infinite competitors but the same degree of 
	% strategic complementarity as in the benchmark model
	options.solve.Kinf = 'Y';

	% solve, simulate, evaluate fit, and interpolate the irfs of the calibrated model
	s = solve(param, glob, options.solve);
	s = simulate(s, glob, options.simulate);
	s = calib_eval(s, glob.moments, options.calibrate);
	s = interpolate_irfs(s);
end 

% This function returns the mean squared error value between the model moments and the data moments
function err = objective(x, param, glob, options)
	% This function computes the err between the model moments and the
	% data moments
	param.omega 	     = x(1);
	param.deltas         = x(2);

	% solve, simulate, and evaluate the fit of the model
	s = solve(param, glob, options.solve);
	s = simulate(s, glob, options.simulate);
	s = calib_eval(s, glob.moments, options.calibrate);
	err = s.calib.loss_value;
end