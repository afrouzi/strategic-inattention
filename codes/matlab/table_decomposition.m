% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the tables in the appendix reported for robustness exercises.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function [] = table_decomposition(s, glob, name)

    try
        load(fullfile(glob.workingdir, append('cf_', name, '.mat')), 'cf');
    catch
        % specify the counterfactual economy:
        cf.p            = s.p;
		
		% keep one K and set it to K=inf
        cf.p.K          = s.p.K(end);
		cf.p.omega_norm = s.p.omega_norm(end); 
        cf.p.Kdist      = 1; % in this counterfactual, the distribution is not relevant but the code requires this field to run
        
		% keep one alpha and set it to alpha(K=2)
		cf.p.alphas     = s.p.alphas(1); 

		% set omega to the calibrated value in the model within s
        cf.p.omega      = s.p.omega(s.calib.o_ind);
        options         = s.options.solve;
        options.Kinf    = 'Y';

        cf = solve(cf.p, glob, options);
        clear options;

        cf.calib.o_ind = 1; cf.calib.d_ind = 1; % in this counterfactual, there are 1 value for omega and delta, but the interpolate function below requires these indices to run
        cf = interpolate_irfs(cf);
        clear options;

        save(fullfile(glob.workingdir, append('cf_', name, '.mat')), 'cf');
    end

    total_y_ben = 100 * log(var(s.irfs_y(:, 1)) / var(s.irfs_y(:, end)));
    inatt_y_ben = 100 * log(var(s.irfs_y(:, 1)) / var(cf.irfs_y));
    realr_y_ben = 100 * log(var(cf.irfs_y) / var(s.irfs_y(:, end)));

    total_pi_ben = 100 * log(var(s.irfs_pi(:, 1)) / var(s.irfs_pi(:, end)));
    inatt_pi_ben = 100 * log(var(s.irfs_pi(:, 1)) / var(cf.irfs_pi));
    realr_pi_ben = 100 * log(var(cf.irfs_pi) / var(s.irfs_pi(:, end)));

    %%%%% Write table
    tab = fopen(fullfile(glob.outdir, append(name, '.tex')), 'w+');
		fprintf(tab, '\\begin{tabular}{lccc}\n');
		fprintf(tab, '\t & \\multicolumn{3}{c}{\\emph{\\shortstack[c]{Percentage change\\\\in variance of}}}\\\\ \n');
		fprintf(tab, '\t \\cline{2-4} \n');
		fprintf(tab, '\t & \\multicolumn{1}{c}{\\emph{output}} && \\multicolumn{1}{c}{\\emph{inflation}}\\\\ \n ');
		fprintf(tab, '\t & \\multicolumn{1}{c}{\\emph{(1)}} && \\multicolumn{1}{c}{\\emph{(2)}}\\\\ \n ');
		fprintf(tab, '\t \\hline \n');
		fprintf(tab, '\t Total Change (percent)& %0.1f && %0.1f \\\\ \n', total_y_ben, total_pi_ben);
		fprintf(tab, '\t Due to Str. Inattention (ppt)& %0.1f && %0.1f \\\\ \n', inatt_y_ben, inatt_pi_ben);
		fprintf(tab, '\t Due to Real Rigidities (ppt)& %0.1f && %0.1f \\\\ \n', realr_y_ben, realr_pi_ben);
		fprintf(tab, '\t \\hline \\\\ \n');
		fprintf(tab, '\\end{tabular}');

    fclose(tab);
end
