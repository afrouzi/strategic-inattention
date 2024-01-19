% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the impulse response functions figure (Fig. A5) reported in the paper.
% "s" is the structure of the solved model, "glob" is the global variables, and "name" is the name of the
% generated figure that is saved in the "out" folder.

function [] = figure_irfs(s, glob, name)

    fig = figure;

    subplot(1, 2, 1);
    hold on;
    box on; grid on;

    % x axis bounds and grid 
    T   = glob.plots.T;
    dt  = s.interp.t(2) - s.interp.t(1);
    ind = min(find(abs(s.interp.t - T) < 0.5 * dt, 1));
    tG  = s.interp.t(1:ind);

    % plot IRFs for inflation for K=2 (ind = 1), aggregate , and mon. comp.
    plot(tG, s.interp.irfs_pi(1:ind, 1), '-.k', 'LineWidth', 2);
    plot(tG, s.interp.irfs_pi_agg(1:ind), '-k', 'LineWidth', 2);
    plot(tG, s.interp.irfs_pi_Kinf_agg(1:ind), '--k', 'LineWidth', 2);

    % plot options for inflatino irfs
    lenendinfo = {'$K=2$', '$K\sim \hat{\mathcal{K}}$', 'Mon. Comp.'};
    legend(lenendinfo, 'Interpreter', 'Latex');
    xlabel('Quarters', 'Interpreter', 'Latex');
    ylabel('Inflation (ppt)', 'Interpreter', 'Latex');
    axis tight;

    subplot(1, 2, 2);
    hold on;
    box on; grid on;

    % plot IRFs for output for K=2 (ind = 1), aggregate , and mon. comp.
    plot(tG, s.interp.irfs_y(1:ind, 1), '-.k', 'LineWidth', 2);
    plot(tG, s.interp.irfs_y_agg(1:ind), '-k', 'LineWidth', 2);
    plot(tG, s.interp.irfs_y_Kinf_agg(1:ind), '--k', 'LineWidth', 2);

    % plot options for output irfs
    xlabel('Quarters', 'Interpreter', 'Latex');
    ylabel('Output (ppt)', 'Interpreter', 'Latex');
    axis tight;

    % save figure
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6.5 2.5];

    print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end