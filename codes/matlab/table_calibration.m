% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the calibration table reported in the paper (Table 3).
% "s" is the structure of the solved model, "glob" is the global variables, and "name" is the name of the
% generated figure that is saved in the "out" folder.

function [] = table_calibration(s, glob, name)

    % save omega as the un-normalized value of calibrated omega (see Eqns J.56-8 in Appendix J.3)
	omega = s.p.omega * s.p.eta * (1 + s.p.gamma * s.p.eta) / (1 + s.p.gamma) * glob.moments.sigma_shock ^ 2;

    tab = fopen(fullfile(glob.outdir, strcat(name, '.tex')), 'w+');
    fprintf(tab, '\\begin{tabular}{llll}\n');
    fprintf(tab, '\\hline\\hline\n');
    fprintf(tab, '\\emph{Parameter} & \\emph{Description} & \\emph{Value} & \\emph{Moment Matched}\\\\\n');
    fprintf(tab, '\\hline \n');
    fprintf(tab, '{$\\mathcal{K}$} & {Distribution of $K$} & {$\\sim \\hat{\\mathcal{K}}$} & {Empirical distribution (Fig. \\ref{Figure:competitors})}\\\\\n');
    fprintf(tab, '{$\\omega$} & {Cost of attention} & {%.3f} & {Weight on prior in inflation forecasts}\\\\\n', omega);
    fprintf(tab, '{$\\eta$} & {Elasticity of substitution} & {%d} & {Elasticity of markups to ${1/(1-K_j^{-1})}$}\\\\\n', s.p.eta);
    fprintf(tab, '{$1/(1+\\gamma)$} & {Curvature of production} & {%.3f} & {Average strategic complementarity}\\\\\n', 1 / (1 + s.p.gamma));
    fprintf(tab, '{$\\rho$} & {Persistence of $\\Delta q$} & {%.3f} & {Persistence of NGDP growth in NZ}\\\\ \n', s.p.rho);
    fprintf(tab, '{$\\sigma_u$} & {Std. Dev. of shock to $\\Delta q$} & {%.3f} & {Std. Dev. of NGDP growth in NZ}\\\\\n', glob.moments.sigma_shock);
    fprintf(tab, '\\hline \n');
    fprintf(tab, '\\end{tabular}\n');
    fclose(tab);

end
