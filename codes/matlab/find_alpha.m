% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function calculates the degree of strategic complementarity as a function of number of 
% firms and other parameters of the model for two models:
%   1. "gamma" model: this is the benchmark model in the paper with gamma as the parameter for 
%      the degree of decreasing returns to scale 
%   2. "atkeson-burstein" model: this is the model with Atkeson and Burstein (2008) preference
%       with sigma as the elasticity of subsitution across industries which is 1 in the benchmark

function alpha = find_alpha(param, varargin)

    args = inputParser;
    addOptional(args, 'model', 'gamma');

    parse(args, varargin{:});

    if args.Results.model == "gamma"
        mub   = param.eta / (param.eta - 1);
        ms    = 1 ./ param.K;
        alpha = ms ./ mub + (1 - ms ./ mub) .* ... 
            (1 - (1 + param.gamma) ./ (1 + param.gamma .* param.eta .* (1 - ms ./ mub) .^ 2));
    elseif args.Results.model == "atkeson-burstein"
		e     = param.eta - (param.eta - param.sigma) ./ param.K;
		ee    = (param.eta - param.sigma) .* (param.eta - 1) .* (1 - 1 ./ param.K) .* (1 ./ param.K) ./ (e);
		alpha = ee ./ (e - 1 + ee);
    end

end