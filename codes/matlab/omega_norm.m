% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function calculates the effective cost of attention multipliers given deep parameters (B_inf/B_K in Eqns J.57-9)
% We call omega_norm_K = B_inf/B_K. The code is written to calculate omega_norm_K for two models:
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