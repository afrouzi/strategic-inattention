% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the higher order beliefs figure (Fig. A7) reported in the paper.
% "s" the structure of the solved model, "glob" the global variables, and "name" the name of the 
% generated figure that is saved in the "out" folder.

function [] = figure_higher_order(s, glob, name)

    % unpack
    T = glob.plots.T;
    dt = s.interp.t(2) - s.interp.t(1);
    ind = min(find(abs(s.interp.t - T) < 0.5 * dt, 1));
    tG = s.interp.t(1:ind);
    K = s.p.K;

    % define aux. variables
    Mu = [zeros(1, s.p.Tu); eye(s.p.Tu - 1), zeros(s.p.Tu - 1, 1)];
    Mv = [zeros(1, s.p.Tv); eye(s.p.Tv - 1), zeros(s.p.Tv - 1, 1)];
    Mz = [zeros(1, s.p.Tz); eye(s.p.Tz - 1), zeros(s.p.Tz - 1, 1)];
    I = eye(s.p.Tu + s.p.Tv + s.p.Tz);
    Ap = [Mu, zeros(s.p.Tu, s.p.Tv + s.p.Tz); ...
                zeros(s.p.Tz, s.p.Tu), Mz, zeros(s.p.Tz, s.p.Tv); ...
                zeros(s.p.Tv, s.p.Tu + s.p.Tz), Mv];
    NT = s.p.Tu + s.p.Tv + s.p.Tz;

    % choose K=2, 5, infinity
    k = [1 4 length(K)];

    % initialize figure
    fig = figure;
    xlabel('Number of Competitors', 'Interpreter', 'Latex', 'FontSize', 12);

    % loop over different Ks in [2,5,inf]
    for i = 1:3
        % Define and calculate X such that for summable w, w'E[U] = w'XU (X solves a Kalman-Yakubovich Matrix Equation)
        X = zeros(NT, NT, length(K));
        KYp = s.KGs(:, k(i), s.calib.o_ind, s.calib.d_ind) * s.Ys(:, k(i), s.calib.o_ind, s.calib.d_ind)';
        X(:, :, k(i)) = KY_conjugate((I - KYp) * s.As(:, :, k(i), s.calib.o_ind, s.calib.d_ind), Ap, KYp);

        subplot(1, 3, i);
        hold on; grid on; box on;
        ylim([0 0.7]);

        % Plot IRFs in each figure for different orders of belief (n=1,4,16,64)
        for l = 1:4;
            n = 4 .^ (l - 1);
            irf = (X(:, :, k(i))') ^ n * [s.p.Hdq; zeros(s.p.Tz, 1); zeros(s.p.Tv, 1)];
            irf = irf(1:T);
            irf_interp = interp1(1:T, irf(1:T), tG, 'spline');
            plot(tG, irf_interp, 'LineWidth', 2, 'Color', 1 - [1 1 1] / (1 + 0.6 * sqrt(n)));
            legendinfo{l} = sprintf('$n=%d$', 2 ^ (2 * (l - 1)));
        end

        % Plot options
        xlim([1 T]);
        xlabel('Time', 'Interpreter', 'Latex', 'FontSize', 12);

        if i < 3
            title(sprintf('$K=%d$', K(k(i))), 'interpreter', 'latex');

            if i == 1
                ylabel('Higher-Order Beliefs (ppt)', 'Interpreter', 'Latex', 'FontSize', 12);
            end

        else
            title('$K\to\infty$', 'interpreter', 'latex', 'FontSize', 12);
            legend(legendinfo, 'interpreter', 'latex', 'FontSize', 8);
        end

    end

    % Save figure
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 6.5 2.5];

	print(fullfile(glob.outdir, append(name, '.eps')), '-depsc', '-tiff');
end