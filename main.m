% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This is the main MATLAB file replicating the analysis for "Strategic Inattention, Inflation Dynamics, and the Non-neutrality of Money" and serves as the entry point for running the code in this project.

clc; clear; close all;

%% Set replication options
% This section of the code defines the "replicate" structure, which contains
% several fields that determine the behavior of the program. Each field can
% be set to either 'Y' or 'N'. All models are already solved and their results
% are saved in the "workingdir" folder, so these options are set to 'N' by default.
% But you can switch any to 'Y', to resolve/recalibrate the corresponding
% model.
%
% To replicate figures and tables without solving the models, you only need
% to set the "replicate.Figures_Tables" option to 'Y'.
comp_time = tic;

replicate.Calibrate_Benchmark = 'N'; % solve and calibrate benchmark model ('Y' or 'N') ~15 minutes with 32 cores
replicate.Benchmark_Grid      = 'N'; % solve benchmark model for grid of omega values ('Y' or 'N') ~15 minutes with 32 cores
replicate.AtkesonBurstein_L   = 'N'; % solve and calibrate model with Atkeson Burstein preferences (low elasticities) ('Y' or 'N')
replicate.AtkesonBurstein_H   = 'N'; % solve and calibrate model with Atkeson Burstein preferences (high elasticities) ('Y' or 'N')
replicate.Idiosyncratic_shock = 'N'; % solve and calibrate model with idiosyncratic shocks ('Y' or 'N')
replicate.Robustness_Rho      = 'N'; % solve and calibrate model with alternative value of rho ('Y' or 'N')
replicate.Robustness_Beta     = 'N'; % solve and calibrate model with alternative value of beta ('Y' or 'N')
replicate.Solve_with_ARMA     = 'N'; % solve benchmark model with ARMA approximation ('Y' or 'N')

% Replicate figures and tables (no need to resolve/recalibrate models)
replicate.Figures_Tables = 'Y'; % generate figures and tables as they appear in the paper ('Y' or 'N') -- - requires all models to be solved and calibrated

% Tests to verify accuracy of algorithm
replicate.MMW_2018        = 'Y'; % replicate price setting model from Mackowiak, Matejka, and Wiederholt (2018) ('Y' or 'N')

%% Add all codes to path
addpath(genpath('./codes/')); % add codes to path

%% Global variables
glob.root        = pwd; % Root directory (X/strategic-inattention/)
glob.input       = fullfile(glob.root, 'input'); % Input directory
glob.workingdir  = fullfile(glob.root, 'workingdir'); % Input/output directory
glob.outdir      = fullfile(glob.root, 'out'); % Output directory
glob.fontname    = 'Palatino'; % Fontname
glob.ncpu        = feature('numcores'); % Number of cores for parallelization
glob.parallelize = 'Y'; % Parallelize? ('Y' or 'N')
glob.plots.T     = 15; % Time horizon for plots

%% Calibration moments
glob.moments.pi12_epi12  = 0.052; % coefficient of inflation nowcast on 1 year ago inflation forecast from Table A.2
glob.moments.unceroK     = -0.115; % coefficient of log sub uncertaintly on log K from Table 1
glob.moments.alpha_bar   = 0.817; % average strategic complementarity from Table A.1
glob.moments.TableI1     = 0.089; % coefficient of average markup on 1/(1-K^-1) in the regresson in Table I.1
glob.moments.nomgdppers  = 0.25 ^ 0.25; % persistence of Delta_q from Footnotes 57
glob.moments.sigma_shock = 0.015 * sqrt(1 - glob.moments.nomgdppers ^ 2); % std dev of shock to nominal gdp growth frim Footnotes 58
glob.moments.Kdist       = table2array(readtable(fullfile(glob.workingdir, 'shares.csv'))); % distribution of number of competitors behind Figure A.1
glob.moments.TableL1Coef = 3.40; % coefficient of regressing 1/(mu - 1)  on 1-K^{-1} from Table L.1
glob.moments.TableL1Cons = 1.74; % constant of regressing 1/(mu - 1)  on 1-K^{-1} from Table L.1

%% Parameters
param.beta    = 0.96 ^ (0.25); % discount factor
param.deltas  = 1; % beta*deltas is the effective discount factor (delta = 1 for all exercises except for the recalibration in Appendix M for alternative discount factor)
param.sigma_u = 1; % std dev of fundamental shock (normalized to 1 in solution of benchmark model since all variances are proportional to sigma_u^2; all to be later rescaled to calibrated value of sigma_shock^2)
param.sigma_z = 0; % std dev of idiosyncratic shock (relative to sigma_u and is zero in benchmark model)

% External calibration of eta, rho, K and Kdist:
param.eta   = floor(1 + 1 / glob.moments.TableI1); % elasticity of substitution within oligopolies
param.rho   = glob.moments.nomgdppers; % persistence of the Delta_q
param.Kdist = [glob.moments.Kdist; 0]; % distribution of firms within oligopolies (last entry is for K=inf which has zero share in data)
param.K     = [2:1:length(param.Kdist), 10e12]; % grid for number of firms within oligopolies (last entry is for K=inf)

%% Replications
diary ./workingdir/matlab_log.txt;

switch replicate.Calibrate_Benchmark
    case 'Y'
        tic;
        % Set p as the parameter structure for the benchmark model
        p       = param;
        p.model = 'Benchmark';

        % Final gamma  parameters of benchmark models
        p.gamma      = find_gamma(p, glob.moments.alpha_bar); % curvature of production function
        p.alphas     = find_alpha(p, 'model', 'gamma'); % find strategic complementarities given gamma
        p.omega_norm = omega_norm(p, 'model', 'gamma'); % find cost of information coefficient (B_inf/B_K) per Eqns J.56-8 in Appendix J.3 

        p.omega = 4; % initial guess for omega_tilde (note that omega_hat is a normalized version of omega in the paper --- see Eqns J.56-8 in Appendix J.3)

        % Set solution method options
        options.solve.approx      = 'int_ma'; % method for solving the model
        options.solve.drip_method = 'spectral'; % method for solving DRIPs (default algorithm of Afrouzi and Yang, 2019, based on spectral decomposition)
        options.solve.drip_maxit  = 10; % maximum number of iterations in DRIPs for parallel convergence (see solve_model_int_ma.m for details)
        options.solve.drip_w      = 0.9;  % weight on the new guess in DRIPs
        options.solve.tol         = 1e-5; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)

        options.solve.Kinf = 'N'; % turn off counterfactual solutions in calibration stage

        % Set solution method parameters
        p.Tu   = 60;  % length of truncation for irf of pi
                      % This assumes that inflation/output has no response to monetary shocks after 60 quarters (15 years)
        p.Tv   = 30;  % length of truncation for irf of v
        p.Tz   = 0;   % length of truncation for irf of z (0 = no idio shocks)
        p.damp = 0.2; % damping parameter for iterations in fixed point algorithm of int_ma

        % Set simulation options
        options.simulate.seed = 0;
        options.simulate.Burn = 200;
        options.simulate.N    = 5e4;

        % Set calibration options
        options.calibrate.delta = 'N';    % beta * delta is the effective discount rate in the code, but do not calibrate beta until Appendix M

        options.calibrate.forecast_w = 1; % ONLY target coefficient of inflation nowcast on previous infaltion forecast
        options.calibrate.uncer_w    = 0; % DO NOT target relationship of uncertainty and K

        options.calibrate.omega_l = 2; % lower bound for omega
        options.calibrate.omega_u = 6;  % upper bound for omega

        % Calibrate
        bm = calibrate(p, glob, options);

        bm.comp_time = toc;
        bm.options   = options;

        save(fullfile(glob.workingdir, 'bm.mat'), 'bm')
        clear p options bm;
end

% solve on a grid for figure a3
switch replicate.Benchmark_Grid
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Benchmark (Grid of omegas)';

        p.omega = 0.5:.25:10; % cost of information when B*var(q) = 1
        p.Tu    = 40;
        p.Tv    = 20;

        % Adjust solution method options
        bm.options.solve.tol         = 1e-4; % lower tolerance because this model on the grid is solved only to confirm identification of omega

        bm_grid = solve(p, glob, bm.options.solve);
        bm_grid = simulate(bm_grid, glob, bm.options.simulate);
        bm_grid = calib_eval(bm_grid, glob.moments, bm.options.calibrate);

        bm_grid.options   = bm.options;
        bm_grid.comp_time = toc;

        save(fullfile(glob.workingdir, 'bm.mat'), 'bm_grid', '-append');
        clear p bm bm_grid;
end

switch replicate.AtkesonBurstein_L
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Atkeson and Burstein (2008) Preferences (Low Elasticities)';

        p.omega = 22;
        p.gamma = 0;
        p.sigma = glob.moments.TableL1Cons + 1;
        p.eta   = glob.moments.TableL1Coef + p.sigma;

        p.alphas     = find_alpha(p, 'model', 'atkeson-burstein');
        p.omega_norm = omega_norm(p, 'model', 'atkeson-burstein');

        p.Tu    = 40; % A-B model has small strategic complementarity so inflation process is not very persistent
        p.Tv    = 20; % A-B model has small strategic complementarity so inflation process is not very persistent

        options = bm.options;

        % Adjust solution method options
        options.solve.tol         = 1e-4; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)

		% Adjust calibration options
        options.calibrate.omega_l = 20; % lower bound for omega
        options.calibrate.omega_u = 24; % upper bound for omega

        % Calibrate
        ab_low = calibrate(p, glob, options);

        ab_low.comp_time = toc;
        ab_low.options   = options;

        save(fullfile(glob.workingdir, 'atkeson_burstein.mat'), 'ab_low')
        clear p options ab_low bm;
end

switch replicate.AtkesonBurstein_H
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Atkeson and Burstein (2008) Preferences (High Elasticities)';

        p.omega = 22;
        p.gamma = 0;
        p.sigma = 6;

        p.alphas     = find_alpha(p, 'model', 'atkeson-burstein');
        p.omega_norm = omega_norm(p, 'model', 'atkeson-burstein');

        p.Tu    = 40; % A-B model has small strategic complementarity so inflation process is not very persistent
        p.Tv    = 20; % A-B model has small strategic complementarity so inflation process is not very persistent

        options = bm.options;

        % Adjust solution method options
        options.solve.tol         = 1e-4; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)

		% Adjust calibration options
        options.calibrate.omega_l = 20; % lower bound for omega
        options.calibrate.omega_u = 24; % upper bound for omega

        % Calibrate
        ab_high = calibrate(p, glob, options);

        ab_high.comp_time = toc;
        ab_high.options   = options;

        save(fullfile(glob.workingdir, 'atkeson_burstein.mat'), 'ab_high', '-append')
        clear p options ab_high bm;
end

switch replicate.Idiosyncratic_shock
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Robustness to Idiosyncratic Shocks';

        p.sigma_z = 2;
        p.Tz      = 20;
        p.omega   = 3.5;

        options = bm.options;

        % Adjust solution method options
        options.solve.tol         = 1e-4; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)
        
		% Adjust calibration options
		options.calibrate.omega_l = 2; % lower bound for omega
        options.calibrate.omega_u = 5; % upper bound for omega

        % Calibrate
        idiom = calibrate(p, glob, options);

        idiom.comp_time = toc;
        idiom.options   = options;

        save(fullfile(glob.workingdir, 'robust_idio.mat'), 'idiom')
        clear p options idiom bm;
end

switch replicate.Robustness_Rho
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Robustness to Rho';

        p.omega = 1.6;
        p.rho   = 0.23;
        p.Tu    = 40; % with rho small inflation process is not very persistent

        options = bm.options;

        % Adjust solution method options
        options.solve.tol         = 1e-4; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)

		% Adjust calibration options
        options.calibrate.omega_l = 1.2; % lower bound for omega
        options.calibrate.omega_u = 1.8; % upper bound for omega

        % Calibrate
        rr = calibrate(p, glob, options);

        rr.comp_time = toc;
        rr.options   = options;

        save(fullfile(glob.workingdir, 'robust_rho.mat'), 'rr')
        clear p options rr bm;
end

switch replicate.Robustness_Beta
    case 'Y'
        tic;

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Robustness to Beta';

        p.deltas = 0.6; % inital guess for delta
        p.omega = 2;

        % Set options
        options = bm.options;

        % Adjust solution method options
        options.solve.tol         = 1e-4; % tolerance for error in percentage deviation from previous iteration (1e-4 for robustness exercises)

        % Adjust solution method options
        options.solve.drip_maxit  = 100;
        options.solve.drip_method = 'signal_based';
        options.solve.drip_w      = 0.5;

        % Adjust simulation options
        options.simulate.N = 1e5;

        % Adjust calibration options
        options.calibrate.delta = 'Y';

        % target two moments for two parameters
        options.calibrate.forecast_w = 0.5; % target coefficient of inflation nowcast on previous infaltion forecast
        options.calibrate.uncer_w    = 0.5; % target relationship of uncertainty and K

        % Calibrate
        rb = calibrate(p, glob, options);

        rb.comp_time = toc;
        rb.options = options;

        save(fullfile(glob.workingdir, 'robust_beta.mat'), 'rb')
        clear p options rb;
end

switch replicate.Solve_with_ARMA
    case 'Y'

        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p = bm.p;
        p.model = 'Benchmark (ARMA approximation)';

        options = bm.options.solve;
        p.damp = 0.9;

        % Set solution method options
        options.approx      = 'arima'; % method for solving model
        options.drip_method = 'spectral'; % method for solving DRIPs
        options.drip_maxit  = 25; % maximum number of iterations in DRIPs for parallel convergence (see solve_model_arima.m for details)
        options.Kinf        = 'Y'; % turn on monopolistic competition solution

        % Set solution method parameters
        p.r  = 5;   % order of arma approximation for pi
        p.Tu = 100; % length of truncation for irfs

        % Solve, save, and clear workspace from temporary variables
        bm_arma = solve(p, glob, options); % solve benchmark model

        % save solution options
        bm_arma.options.solve = options;

        % interpolate irfs to replicate half-life results
        bm_arma.calib.o_ind = 1; % this just says that the index of calibrated value of omega is 1 (trivial because there is only one value in there: bm_arma.omega=bm.omega)
        bm_arma.calib.d_ind = 1; % this just says that the index of calibrated value of delta is 1 (trivial because there is only one value in there: bm.arma.deltas=bm.deltas)

        bm_arma = interpolate_irfs(bm_arma);
        save(fullfile(glob.workingdir, 'bm_arma.mat'), 'bm_arma')

        fprintf('Tolerance was 1e-5, but some models exited with larger error. Max convergence error was %f \n\n', max(bm_arma.errs(1, :)));

        % calculate difference in IRFs:

        irf_y_diff  = zeros(length(p.K), 1);
        irf_pi_diff = zeros(length(p.K), 1);

        for k = 1:length(p.K)
            irf_y_diff(k)  = max(abs(bm.irfs_y(:, k) - bm_arma.irfs_y(1:bm.p.Tu, k)));
            irf_pi_diff(k) = max(abs(bm.irfs_pi(:, k) - bm_arma.irfs_pi(1:bm.p.Tu, k)));
        end

        diff_y  = 100 * mean(irf_y_diff);
        diff_pi = 100 * mean(irf_pi_diff);

        diff_y_max  = 100 * max(irf_y_diff);
        diff_pi_max = 100 * max(irf_pi_diff);
        
        fprintf('Avg. max diff. in IRFs of output per K between ARMA and Int. MA approx. is %0.2f basis points\n', diff_y);
        fprintf('Avg. max diff. in IRFs of inflation per K between ARMA and Int. MA approx. is %0.2f basis points\n\n', diff_pi);

        fprintf('max max diff. in IRFs of output per K between ARMA and Int. MA approx. is %0.2f basis points\n', diff_y_max);
        fprintf('max max diff. in IRFs of inflation per K between ARMA and Int. MA approx. is %0.2f basis points\n\n', diff_pi_max);
        
        clear p bm bm_arma options;
end

switch replicate.Figures_Tables
    case 'Y'
        % Tables and Figures with benchmark model
        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm', 'bm_grid');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved/calibrated.')
        end

        figure_uncer_vs_K(bm, glob, 'Figure_1');
        figure_concentration_multipliers(bm, glob, 'Figure_2');
        figure_identification(bm, bm_grid, glob, 'Figure_A3');
        figure_capacities(bm, glob, 'Figure_A4');
        figure_irfs(bm, glob, 'Figure_A5');
        figure_str_comps(bm, glob, 'Figure_A6');
        figure_higher_order(bm, glob, 'Figure_A7');
        table_calibration(bm, glob, 'Table_3');
        table_output(bm, glob, 'Table_4');
        table_inflation(bm, glob, 'Table_5');
        table_decomposition(bm, glob, 'Table_6');

        % Tables and Figures with Atkeson and Burstein (2008) preferences with low elasticities
        try
            load(fullfile(glob.workingdir, 'atkeson_burstein.mat'), 'ab_low', 'ab_high');
        catch
            error('ERROR: Cannot find atkeson_burstein.mat because the model with AB preferences is not solved/calibrated.')
        end

        table_appendix(ab_low, glob, 'Table_L2');
        table_decomposition(ab_low, glob, 'Table_L3');
        figure_appendix_cap(ab_low, glob, 'Figure_L1')

        table_appendix(ab_high, glob, 'Table_L4');
        table_decomposition(ab_high, glob, 'Table_L5');
        figure_appendix_cap(ab_high, glob, 'Figure_L2')

        % Tables and Figures with idiosyncratic shocks
        try
            load(fullfile(glob.workingdir, 'robust_idio.mat'), 'idiom');
        catch
            error('ERROR: Cannot find robust_idio.mat because the model with idiosyncratic shocks is not solved/calibrated.')
        end

        table_appendix(idiom, glob, 'Table_M2');
        table_decomposition(idiom, glob, 'Table_M3');
        figure_appendix_cap(idiom, glob, 'Figure_M1')

        % Robustness to Rho Table
        try
            load(fullfile(glob.workingdir, 'robust_rho.mat'), 'rr');
        catch
            error('ERROR: Cannot find robust_rho.mat because the robustness to rho model is not solved/calibrated.')
        end

        table_appendix(rr, glob, 'Table_M1a');

        % Robustness to Beta Table
        try
            load(fullfile(glob.workingdir, 'robust_beta.mat'), 'rb');
        catch
            error('ERROR: Cannot find robust_beta.mat because the robustness to beta model is not solved/calibrated.')
        end

        table_appendix(rb, glob, 'Table_M1b');

        % Robustness to ARMA approximation Figure
        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
            load(fullfile(glob.workingdir, 'bm_arma.mat'), 'bm_arma');
        catch
            error('ERROR: Cannot find bm.mat or bm_arma.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark/Solve_with_ARMA to solve benchmark model first.')
        end
        figure_arma_comparison(bm, bm_arma, glob, 'Figure_J1');
        table_output(bm_arma, glob, 'Table_J1');
        table_inflation(bm_arma, glob, 'Table_J2');
        table_decomposition(bm_arma, glob, 'Table_J3');
end

switch replicate.MMW_2018
    case 'Y'
        % set parameters
        try
            load(fullfile(glob.workingdir, 'bm.mat'), 'bm');
        catch
            error('ERROR: Cannot find bm.mat because benchmark model is not solved. Turn on the switch replicate.Calibrate_Benchmark to solve benchmark model first.')
        end

        p       = bm.p;
        p.model = 'Mackowiak, Matejka, and Wiederholt (2018)';

        p.K          = 1e12; % number of firms = inf (monopolistic competition)
        p.Kdist      = 1;
        p.omega_norm = 1;

        p.rho   = 0.9;
        p.omega = 8; % value of omega corresponding to the problem in MMW when sigma_u = 1;
        p.beta  = 1;

        glob.parallelize = 'N';

        comp_time_tests = tic;
        p.alphas        = 0; % xi = 1; (alpha = 1 - xi)
        mmw_no_str      = solve(p, glob, bm.options.solve);

        p.alphas  = 0.85; % xi = 0.15 (alpha = 1 - xi)
        mmw_w_str = solve(p, glob, bm.options.solve);
        toc(comp_time_tests)

        % Plot Figure 6 in MMW 2018
        fig = figure;
        box on;

        subplot(2, 1, 1)
        plot(0:12, [0; mmw_no_str.irfs_y(1:12)] * 0.1, '*-', 'LineWidth', 0.5, ...
            'MarkerSize', 5, 'Color', [0, 0, 0]);
        xlim([0 12]);
        ylim([-0.005, 0.055]);
        xticks(1:12);
        yticks(0:0.01:0.05);
        legend('Figure 6 --- Case of $\xi = 1$', 'Interpreter', 'Latex')

        subplot(2, 1, 2)
        plot(0:12, [0; mmw_w_str.irfs_y(1:12)] * 0.1, '*-', 'LineWidth', 0.5, ...
            'MarkerSize', 5, 'Color', [0, 0, 0]);
        legend('Figure 6 --- Case of $\xi = 0.15$', 'Interpreter', 'Latex')
        xlim([0 12]);
        ylim([-0.005 0.105]);
        xticks(1:12);
        yticks(0:0.02:0.1);

        % save
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 6.5 4];

        print(fullfile(glob.outdir, 'Test_MMW_replication.eps'), '-depsc', '-tiff');
end

total_comp_time = toc(comp_time);
fprintf('Total computation time: %0.2f minutes\n', total_comp_time / 60);

diary off;