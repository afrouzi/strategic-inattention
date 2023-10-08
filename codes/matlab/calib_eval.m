% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money
% For given values of parameters, this function evaluates mean squared error of 
% the model implied moments from the moments specified in "glob.moments" according to 
% weights assigned to each moment in "options". 

% NOTE: In the benchmark model the only internally calibrated parameter is "omega" and 
% the only targeted moment is the regression coefficient of inflation nowcast on past 
% inflation forecasts. However, the code is written more generally to target up to two 
% moments to possibly target the coefficient of uncertainty on log of competitors to 
% calibrate "delta" (discount factor modifier) to allow for the robustness exercise in 
% Appendix M.

function s = calib_eval(s, moments, options)
    % Unpack parameters
    LO = s.p.LO;
    LD = s.p.LD;
    SN = length(s.pi_nowcast_12m(:, 1));

    % initialize the coefficients for regressions and losses
    s.calib.forecast_estimates = zeros(2, LO, LD);
    s.calib.forecast_std_errs  = zeros(2, 2, LO, LD);
    s.calib.uncer_estimates    = zeros(2, LO, LD);
    s.calib.uncer_std_errs     = zeros(2, 2, LO, LD);
    s.calib.losses             = zeros(LO, LD);

    % Regress for different values of omega (cost of attention) and delta (discounting)
    for ind = 1:LO * LD
        [o, d] = ind2sub([LO, LD], ind);

		% regress posterior on prior 
        [s.calib.forecast_estimates(:, ind), s.calib.forecast_std_errs(:, :, ind)] = regress(s.pi_nowcast_12m(:, ind), [ones(SN, 1), s.pi_forecast_12m(:, ind)]);

		% regress log of uncertainty on log of K
        [s.calib.uncer_estimates(:, ind), s.calib.uncer_std_errs(:, :, ind)] = regress(log(s.pi_uncertainty(:, ind)), [ones(SN, 1), log(s.K(:, ind))]);

		if options.uncer_w == 0
			fprintf('ῶ = %.4f, β = %.4f: Persistence: %.3f\n\n', ...
				s.p.omega(o), s.p.deltas(d) * s.p.beta, s.calib.forecast_estimates(2, ind));
		else 
			fprintf('ῶ = %.4f, β = %.4f: Persistence reg: %.3f, Uncertainty reg: %.3f \n\n', ...
				s.p.omega(o), s.p.deltas(d) * s.p.beta, s.calib.forecast_estimates(2, ind), ...
				s.calib.uncer_estimates(2, ind));
		end 

		% caclulate the loss
        s.calib.losses(ind) = options.forecast_w * (s.calib.forecast_estimates(2, ind) - moments.pi12_epi12) ^ 2 + options.uncer_w * (s.calib.uncer_estimates(2, ind) - moments.unceroK) ^ 2;
    end

	% Find the minimum loss and return indices for optimal values
    [s.calib.loss_value, ind] = min(s.calib.losses(:));
    [s.calib.o_ind, s.calib.d_ind] = ind2sub([LO, LD], ind);
end