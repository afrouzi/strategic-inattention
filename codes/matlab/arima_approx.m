% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function fits an ARIMA(r,1,r+1) state-space to a variable x, 
% where x_t-x_{t-1} has stationary IRF (irf input). See documentation for details.
% Requires the zTran toolbox (See README.md for details on how to include it in this package)

function [A, Q, H] = arima_approx(irf, r)
    
    % Use zTran to fit an arma process to irf 
    % Note that irf needs to be stationary; in our case this is the irf of 
    % inflation and not price level (because price level has a unit root)
    irf    = num2cell(irf);
    z      = -0.99:0.05:0.99;
    fz     = eval(z, varma({}, irf));
    approx = varma.fit(z, fz, r, r, 0);

    % Set GammaD as the AR coefficients of the x_t-x_{t-1} process
    GammaD   = [approx.AR{:}];   
    
    % Gamma is the (Integrated) AR coefficients of the x_t process: set values according to documentation
    Gamma    = zeros(r + 1, 1);  
    Gamma(1) = 1 + GammaD(1);    

    for i = 2:r
        Gamma(i) = GammaD(i) - GammaD(i - 1);
    end

    Gamma(end) = -GammaD(end);

    % Construct and return the state space representation of x_t
    H = [approx.MA{:}]';
    A = [Gamma';
         eye(r), zeros(r, 1)];
    Q = [1; zeros(r, 1)];
end