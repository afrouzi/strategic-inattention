% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the capacity figures in the appendix reported for robustness exercises.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the
% generated figure that is saved in the "out" folder.

function [] = figure_arima_comparison(s, s_arima, glob, name)
    fig = figure;

    subplot(2, 2, 1)
    hold on; box on;
    K_inds = [1, 3, 31];

    for ind = 1:3
        irf = s.irfs_y(:, K_inds(ind));
        plot(1:glob.plots.T, irf(1:glob.plots.T), 'LineWidth', 1, 'Color', 1 - [1 1 1] / (1 + 0.6 * sqrt((ind - 1) ^ 4)));
        axis tight;
        legendinfo{ind} = sprintf('$K=%d$', s.p.K(K_inds(ind)));
    end

    legend(legendinfo, 'interpreter', 'latex', 'FontSize', 8);
    title('Output with Int. MA Truncation', 'interpreter', 'latex');

    subplot(2, 2, 2)
    hold on; box on;
    K_inds = [1, 3, 31];

    for ind = 1:3
        irf = s_arima.irfs_y(:, K_inds(ind));
        plot(1:glob.plots.T, irf(1:glob.plots.T), 'LineWidth', 1, 'Color', 1 - [1 1 1] / (1 + 0.6 * sqrt((ind - 1) ^ 4)));
        axis tight;
        legendinfo{ind} = sprintf('$K=%d$', s.p.K(K_inds(ind)));
    end

    legend(legendinfo, 'interpreter', 'latex', 'FontSize', 8);
    title('Output with ARMA Approximation', 'interpreter', 'latex');

    subplot(2, 2, 3)
    hold on; box on;
    K_inds = [1, 3, 31];

    for ind = 1:3
        irf = s.irfs_pi(:, K_inds(ind));
        plot(1:glob.plots.T, irf(1:glob.plots.T), 'LineWidth', 1, 'Color', 1 - [1 1 1] / (1 + 0.6 * sqrt((ind - 1) ^ 4)));
        axis tight;
        legendinfo{ind} = sprintf('$K=%d$', s.p.K(K_inds(ind)));
    end

    legend(legendinfo, 'interpreter', 'latex', 'FontSize', 8);
    title('Inflation with Int. MA Truncation', 'interpreter', 'latex');

    subplot(2, 2, 4)
    hold on; box on;
    K_inds = [1, 3, 31];

    for ind = 1:3
        irf = s_arima.irfs_pi(:, K_inds(ind));
        plot(1:glob.plots.T, irf(1:glob.plots.T), 'LineWidth', 1, 'Color', 1 - [1 1 1] / (1 + 0.6 * sqrt((ind - 1) ^ 4)));
        axis tight;
        legendinfo{ind} = sprintf('$K=%d$', s.p.K(K_inds(ind)));
    end

    legend(legendinfo, 'interpreter', 'latex', 'FontSize', 8);
    title('Inflation with ARMA Approximation', 'interpreter', 'latex');

    % save
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6.5 3];

    print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end
