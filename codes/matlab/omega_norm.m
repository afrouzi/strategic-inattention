% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function calculates the effective cost of attention multipliers given deep parameters. 
% The model objective in the paper is to minimize "B_K*(p - p*)^2 + omega_paper * I" where "B_j" is the
% curvature value for sectors with K competitors. In the code we solve (p/sigma_u - p^*/sigma_u)^2 + ...
% omega_code_K*I, where sigma_u is the standard deviation of monetary shock. The two are equivalent if 
% omega_paper/(B_K * sigma_u^2) = omega_code_K. In particular, omega_paper = B_inf * omega_code_inf * sigma_u^2.
% In the code we let omega denote omega_code_inf. So omega_code_K = omega_code_inf * B_inf / B_K. 
% We call omega_norm_K = B_inf/B_K. To code is written to calculate omega_norm_K for two models:
%   1. gamma: the benchmark model in the paper
%   2. atkeson-burstein: the model with Atkeson and Burstein (2010) preferences where sigma is elasticity of
%      substitution between across sectors.   

function out = omega_norm(param, varargin)
    args = inputParser;
    addOptional(args, 'model', 'gamma');
    parse(args, varargin{:});

    % calcualte elasticities in different models
    if args.Results.model == "gamma"
        e = param.eta - (param.eta - 1) ./ param.K;
    elseif args.Results.model == "atkeson-burstein"
        e = param.eta - (param.eta - param.sigma) ./ param.K;
    end

    B_inf = e(end) ./ (1 - param.alphas(end));
    B_K   = e ./ (1 - param.alphas);

    out   = B_inf ./ B_K;
end