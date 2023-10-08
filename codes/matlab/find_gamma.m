% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function externally calibrated the parameter gamma (degree of decreasing return to scale)
% to match the average degree of strategic complementarity in the model to the data in "glob.moments".

function gamma = find_gamma(p,alpha_bar)
	err     = @(gamma) (alpha_bar - find_alpha_hat(p, gamma)) ^ 2;
	options = optimset('Display', 'off');
	gamma   = fminsearch(err, 0, options);
end

% this internal function calculates average alpha in the model across firms given 
% the distribution of number of competitors
function alpha_hat = find_alpha_hat(p, gamma)
	% find alpha_hat given parameters in "p" and "gamma"
	p.gamma   = gamma;
	alphas    = find_alpha(p, 'model', 'gamma');
	alpha_hat = dot(alphas, p.Kdist);
end