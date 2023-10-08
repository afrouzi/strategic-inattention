% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the concentration multipliers figure (Fig. A2) reported in the paper.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function y_share = figure_concentration_multipliers(s, glob, name)

    % unpack
    K  = s.p.K(1:end - 1);
    LK = s.p.LK;
    dt = s.interp.t(2) - s.interp.t(1);

    % initialize
    y_share = zeros(LK, 1);

    % calculate concentration multiplier for each K as CIR(Y|K) / CIR(Y)
    for k = 1:LK
        y_share(k) = sum(s.interp.irfs_y(:, k) * dt) / ...
            (sum(s.interp.irfs_y_agg * dt));
    end

    % Plot
    fig = figure;

    hold on;
    box on; grid on;

    plot(K, y_share(1:end - 1), '-k', 'LineWidth', 4);
    plot(K, ones(LK - 1, 1), '-.b', 'LineWidth', 2);

    % plot options
    xlabel('Number of competitors', 'Interpreter', 'Latex', 'FontSize', 12);
    ylabel('Concentration Multiplier', 'Interpreter', 'Latex', 'FontSize', 12);
    set(gca, 'xscale', 'log', 'xtick', 2 .^ (0:5));
    xlim([2 K(end - 1)]);

    % save figure
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6.5 3];

    print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end