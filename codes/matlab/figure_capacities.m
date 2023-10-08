% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the capacity and Kalman gain figure (Fig. A4) reported in the paper.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function [] = figure_capacities(s, glob, name)

    fig = figure;

    K_plot = s.p.K(1:end - 1);
    lambdas = squeeze(s.caps(:, s.calib.o_ind, s.calib.d_ind));

    subplot(1, 2, 2);
    hold on;
    box on; grid on;

    plot(K_plot, lambdas(1:end - 1), '-k', 'LineWidth', 4);

    lambda_bar = lambdas(1:end)' * s.p.Kdist;
    plot(K_plot, lambda_bar * ones(s.p.LK - 1, 1), '-.b', 'LineWidth', 2);

    xlabel('Number of competitors', 'Interpreter', 'Latex', 'FontSize', 12);
    ylabel('Kalman gain', 'Interpreter', 'Latex', 'FontSize', 12);
    legend({'Given K', 'Average'}, ...
        'Interpreter', 'latex', 'Location', 'Southeast');
    set(gca, 'xscale', 'log', 'xtick', 2 .^ (0:5));
    axis tight;
    xlim([2 s.p.K(end - 1)]);

    subplot(1, 2, 1);
    hold on;
    box on; grid on;

    plot(K_plot, -log(1 - lambdas(1:end - 1)) / (2), '-k', 'LineWidth', 4);

    xlabel('Number of competitors', 'Interpreter', 'Latex', 'FontSize', 12);
    ylabel('Capacity', 'Interpreter', 'Latex', 'FontSize', 12);
    set(gca, 'xscale', 'log', 'xtick', 2 .^ (0:5));
    xlim([2 s.p.K(end - 1)]);

    Vsq    = zeros(s.p.LK, 1);
    Vs     = zeros(s.p.LK, 1);
    Corrsq = zeros(s.p.LK, 1);
    Zs     = zeros(s.p.Tu, 1);
    wqe    = [s.p.Hdq; zeros(s.p.Tz, 1); zeros(s.p.Tv, 1)];

    for i = 1:s.p.LK
        y_m_u = [Zs; s.Ys(s.p.Tu + 1:end, i, s.calib.o_ind, s.calib.d_ind)];
        y_a = s.Ys(:, i, s.calib.o_ind, s.calib.d_ind);
        Vsq(i) = y_m_u' * s.Sigmas_prior(:, :, i, s.calib.o_ind, s.calib.d_ind) * y_m_u;
        Vs(i) = y_a' * s.Sigmas_prior(:, :, i, s.calib.o_ind, s.calib.d_ind) * y_a;
        Corrsq(i) = (y_a' * s.Sigmas_prior(:, :, i, s.calib.o_ind, s.calib.d_ind) * wqe) ^ 2 / ...
            (Vs(i) * (wqe' * s.Sigmas_prior(:, :, i, s.calib.o_ind, s.calib.d_ind) * wqe));
    end

    kappa_u = -log(1 - s.caps(:, s.calib.o_ind, s.calib.d_ind) .* (1 - Vsq ./ Vs)) / 2;
    plot(K_plot, kappa_u(1:end - 1), '-.b', 'LineWidth', 4);
    legend({'Total', 'Allocated to Aggregates'}, ...
        'Interpreter', 'latex', 'Location', 'Southeast');

	fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6.5 2.5];

    print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end