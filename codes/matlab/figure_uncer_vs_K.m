% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the uncertainty vs number of competitors figure  (Fig. 1) in the paper.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the
% generated figure that is saved in the "out" folder.

function [] = figure_uncer_vs_K(s, glob, name)

    % initialize and unpack
    sub_var_benc = zeros(s.p.LK - 1, 1);

    Hpi = [s.irfs_pi_agg(:, s.calib.o_ind, s.calib.d_ind); zeros(s.p.Tz, 1); zeros(s.p.Tv, 1)];
    A   = s.As(:, :, 1, s.calib.o_ind, s.calib.d_ind);
    I   = eye(s.p.Tu + s.p.Tz + s.p.Tv);

    % Calculate subjective uncertainty for each K as the variance of the firms'
    % subjective beliefs about the rational expectation forecast of inflation
    for k = 1:s.p.LK - 1
        sub_var_benc(k) = glob.moments.sigma_shock ^ 2 * ...
            Hpi' * (A ^ 4 - I) * s.Sigmas_post(:, :, k, s.calib.o_ind, s.calib.d_ind) * (A ^ 4 - I)' * Hpi;
    end

    % Define the subjective uncertainty measure
    sub_uncer_benc = sqrt(sub_var_benc);

    % De-mean the subjective uncertainty measure given the distribution of K in the data
    log_sub_avg = log(dot(sub_uncer_benc, s.p.Kdist(1:end-1)));

    % Compute the model series of subjective uncertainty
    model_series = log(sub_uncer_benc) - log_sub_avg;

    % Plot the model series of subjective uncertainty in the model as a functin of 1/number of firms
    fig = figure;
    hold on; grid on;
    box on;

    K_model = s.p.K(1:end-1);
    plot(K_model, model_series, '-k', 'LineWidth', 3);
    ylabelstr = {'Subjective Uncertainty'; '(de-meaned log)'};
    ylabel(ylabelstr, 'Interpreter', 'Latex', 'FontSize', 12);
    xlabel('Number of Competitors', 'Interpreter', 'Latex', 'FontSize', 12);
    set(gca, 'xscale', 'log', 'xtick', 2 .^ (0:5));
    axis tight;

    fig.PaperUnits    = 'inches';
    fig.PaperPosition = [0 0 6.5 2.5];

    % Read the data for the binscatter plot
    % (generated by codes/stata/figure_1_data.do---see readme for replicating stata results)
    data = readtable(fullfile(glob.workingdir, 'binscatter_subjective_uncertainty.csv'));

    % Plot the data series of subjective uncertainty as a function of 1/number of firms in the data
    scatter(exp(data.log_K), data.log_epi_sd, 150, [.45 .45 .45], 'filled');
    legend({'Model', 'Data (Binned Scatter Plot)'}, 'Interpreter', 'latex', 'location', 'northeast');

    % Save the figure
    print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff')
end
