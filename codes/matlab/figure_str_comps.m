% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the strategic complementarities figure (Fig. A6) reported in the paper.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function [] = figure_str_comps(s, glob, name)
	
	fig = figure;
	hold on;
	box on; grid on;

	K_plot = s.p.K(1:end - 1);
	alphas = s.p.alphas;
	alpha_bar = s.p.alphas * s.p.Kdist;

	plot(K_plot, alphas(1:end - 1), '-k', 'LineWidth', 4);
	hold on
	plot(K_plot, alpha_bar * ones(s.p.LK - 1, 1), '-.b', 'LineWidth', 2);
	xlabel('Number of competitors', 'Interpreter', 'Latex', 'FontSize', 12);
	ylabel('Strategic Complementarity', 'Interpreter', 'Latex', 'FontSize', 12);
	legend({'Given K', 'Average'}, ...
		'Interpreter', 'latex', 'Location', 'Southeast');
	axis tight;
	xlim([2 s.p.K(end - 1)]);
	set(gca, 'xscale', 'log', 'xtick', 2 .^ (0:5));

	fig.PaperUnits = 'inches';
	fig.PaperPosition = [0 0 6.5 2.5];

	print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end