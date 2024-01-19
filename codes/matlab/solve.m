% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This model solves the model given parameters in "param", global variables in "glob", and "options."
% It can be called to either solved the model with ARIMA approximation or Integrated MA approximation.
% ARIMA option requires z-Tran toolbox (See README.md for details on how to include it in this package)

function out = solve(param, glob, options)

	fprintf('Model: %s \n\n', param.model);

    if options.approx == "arima"
        out = solve_models_arima(param, glob, options);
    elseif options.approx == "int_ma"
        out = solve_models_int_ma(param, glob, options);
    else
        error('Invalid approximation method')
    end

end
