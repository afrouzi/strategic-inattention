% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the "output across models" table reported in the paper (Table 5).
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function [] = table_output(s, glob, name)

	% initialize table variables 
	K				 = s.p.K;
	K_ind 			 = [1,3,7,15,31,43];
	Model 			 = sprintf('%d-Competitors,',K(K_ind(1:end-1)));
	Kstr 			 = sprintf('$K=%d$,',K(K_ind(1:end-1)));
	Model      		 = strsplit(Model,',');
	Kstr			 = strsplit(Kstr,',');
	Model{end}		 = '$\infty$-Competitors';
	Kstr{end}	     = '$K\to\infty$';
	Model 			 = ['Monopolistic Competition','Benchmark',Model];
	Kstr			 = ['$K\to\infty$','$K\sim \hat{\mathcal{K}}$',Kstr];

	% t grid
	t  = s.interp.t;
	dt = t(2)-t(1);

	% load variance of shock
	var_u           = glob.moments.sigma_shock^2;

	var_y    = zeros(length(K_ind),1);
	half_y   = zeros(length(K_ind),1);

	sum_y      = zeros(length(t), 1);
	sum_y_Kinf = zeros(length(t), 1);
	sum_y_agg  = zeros(length(t), 1);

	for k = 1:length(K_ind)
		var_y(k) = var_u * var(s.irfs_y(:, K_ind(k)));

		for l = 1:length(t)
			sum_y(l) = sum(s.interp.irfs_y(1:l, K_ind(k)) * dt);
		end

		half_y(k) = t(find(sum_y >= 0.5 * sum_y(end), 1));
	end

	for l = 1:length(t)
		sum_y_agg(l)  = sum(s.interp.irfs_y_agg(1:l) * dt);
		sum_y_Kinf(l) = sum(s.interp.irfs_y_Kinf_agg(1:l) * dt);
	end

	half_y_agg      = t(find(sum_y_agg >= 0.5 * sum_y_agg(end), 1));
	half_y_Kinf_agg = t(find(sum_y_Kinf >= 0.5 * sum_y_Kinf(end), 1));

	var_y_agg       = var_u * var(s.irfs_y_agg(:));
	var_y_Kinf_agg	= var_u * var(s.irfs_y_Kinf_agg(:));

	VarC  = [var_y_Kinf_agg; var_y_agg; var_y];
	HalfC = [half_y_Kinf_agg; half_y_agg; half_y];

	AmpFactor_Var  = VarC / var_y_Kinf_agg;
	AmpFactor_Half = HalfC / half_y_Kinf_agg;

	y_exp=floor(log10(max(VarC))); 

	%%%%% Write table

	tab = fopen(fullfile(glob.outdir, append(name, '.tex')), 'w+');
		fprintf(tab, '\\begin{tabular}{llccccc}\n');
		fprintf(tab, '\t && \\multicolumn{2}{c}{\\emph{Variance}} && \\multicolumn{2}{c}{\\emph{Persistence}}\\\\ \n ');
		fprintf(tab, '\t \\cline{3-4} \\cline{6-7} \n');
		fprintf(tab, '\t \\multicolumn{2}{c}{\\emph{Model}} & \\emph{var(Y) $^{\\times 10^{%d}}$} & \\emph{amp. factor} && \\emph{half-life} $^{qtrs}$ & \\emph{amp. factor} \\\\ \n', abs(y_exp));
		fprintf(tab, '\t && \\emph{(1)} & \\emph{(2)} && \\emph{(3)} & \\emph{(4)} \\\\ \n');
		fprintf(tab, '\t \\hline \n');

		for i = 1:length(K_ind) + 2

			if i >= 2
				fprintf(tab, '\t %s & \\multicolumn{1}{l|}{%s} & %0.2f & %0.2f && %0.2f & %0.2f \\\\ \n', ...
					Model{i}, Kstr{i}, VarC(i) / 10 ^ y_exp, AmpFactor_Var(i), HalfC(i), AmpFactor_Half(i));
			else
				fprintf(tab, '\t \\multicolumn{2}{l|}{%s} & %0.2f & %0.2f && %0.2f & %0.2f \\\\ \n', ...
					Model{i}, VarC(i) / 10 ^ y_exp, AmpFactor_Var(i), HalfC(i), AmpFactor_Half(i));
			end

			if i == 2
				fprintf(tab, '\t \\hline \n');
			end

		end

		fprintf(tab, '\t \\hline \n');
		fprintf(tab, '\\end{tabular}');

	fclose(tab);

end 