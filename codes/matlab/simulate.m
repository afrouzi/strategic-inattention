% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function simulates firms' beliefs given the solution to the model in "s" and calculates
% firms' forecasts, nowcasts and subjective uncertainty about inflation given the options 
% specified in "options"

function s = simulate(s, glob, options)
    % s is a structure that is the output of solve.m
    rng(options.seed);

    % Unpack parameters
    Time         = options.Burn;
    N            = options.N;
    LK           = s.p.LK;
    LO           = s.p.LO;
    LD           = s.p.LD;
    KGs          = s.KGs;
    Ys           = s.Ys;
    As           = s.As;
    Tu           = s.p.Tu;
    Tv           = s.p.Tv;
    Tz           = s.p.Tz;
    Sigma_zs     = s.Sigma_zs;
    irfs_pi_agg  = s.irfs_pi_agg;
    sigma_shock  = glob.moments.sigma_shock;

    % backout sample size of each K
    Nums    = floor(N * s.p.Kdist); % sample size of each K
    SN      = sum(Nums); % total sample size

    % Aux vars 
    Mu   = [zeros(1, Tu); eye(Tu - 1), zeros(Tu - 1, 1)];
    Mv   = [zeros(1, Tv); eye(Tv - 1), zeros(Tv - 1, 1)];
    Mz   = [zeros(1, Tz); eye(Tz - 1), zeros(Tz - 1, 1)];

    I  = eye(Tu + Tv + Tz);
    Ap = [Mu, zeros(Tu, Tv + Tz); ...
                zeros(Tz, Tu), Mz, zeros(Tz, Tv); ...
                zeros(Tv, Tu + Tz), Mv];

    % Initialize 
    sigma_shock = glob.moments.sigma_shock;
    U_shocks    = normrnd(0, 1, [Time, 1]);
    Other_s     = normrnd(0, 1, [N, Time, 3]);

    s.pi_nowcast_12m  = zeros(SN, LO, LD);
    s.pi_forecast_12m = zeros(SN, LO, LD);
    s.K               = zeros(SN, LO, LD);
    
    % Parallelize if glob.parallelize == 'Y'
    if glob.parallelize == 'Y';

        if isempty(gcp('nocreate'))
            parpool('local', glob.ncpu);
        end

        num_cores = glob.ncpu;
    elseif glob.parallelize == 'N'
        num_cores = 0;
    end

    parfor (ind = 1:LK * LO * LD, num_cores)
        
        [k, o, d] = ind2sub([LK, LO, LD], ind);
        Delta     = (I - KGs(:, k, o, d) * Ys(:, k, o, d)') * As(:, :, k, o, d);
        U         = zeros(Tu + Tz + Tv, Time, N);   % U is the state vector of a firm
        E_U       = zeros(Tu + Tz + Tv, Time, N);   % E_U is the expected value of U
        S         = zeros(Time, N);            % S is the signal of the firm

        % auxiliary variables
        A           = s.As(:, :, k, o, d);
        Q           = s.Qs(:, :, k, o, d);
        Hpi         = [irfs_pi_agg(:, o, d); zeros(Tz, 1); zeros(Tv, 1)];
        Sigmas_post = s.Sigmas_post(:, :, k, o, d);

        % initialize forecast variables
        tpi_nowcast_12m  = zeros(Nums(k), 1);
        tpi_forecast_12m = zeros(Nums(k), 1);

        if k == 1
            firm_id = 0;
        else
            firm_id = sum(Nums(1:k-1));
        end

        for n = 1:Nums(k)
            firm_id = firm_id + 1;

            for t = 1:Time

                if t == 1
                    U(:, t, n) = A * U(:, t, n) + Q * sigma_shock * ...
                        [U_shocks(t); s.p.sigma_z * Other_s(firm_id, t, 1); Other_s(firm_id, t, 2)];
                else
                    U(:, t, n) = A * U(:, t - 1, n) + Q * sigma_shock * ...
                        [U_shocks(t); s.p.sigma_z * Other_s(firm_id, t, 1); Other_s(firm_id, t, 2)]
                end

                S(t, n) = Ys(:, k, o, d)' * U(:, t, n) + sqrt(Sigma_zs(k, o, d)) * sigma_shock * Other_s(firm_id, t, 3);

                if t > 1
                    E_U(:, t, n) = Delta * E_U(:, t - 1, n) + KGs(:,k,o,d) * S(t, n);
                end

            end

            tpi_nowcast_12m(n)  = Hpi' * (I - Ap' ^ 4) * E_U(:, Time, n);
            tpi_forecast_12m(n) = Hpi' * (As(:, :, ind) ^ 4 - I) * E_U(:, Time - 4, n);
        end

        expectations(ind).pi_nowcast_12m  = sigma_shock * tpi_nowcast_12m;
        expectations(ind).pi_forecast_12m = sigma_shock * tpi_forecast_12m;
        expectations(ind).K               = s.p.K(k) * ones(Nums(k), 1);
        expectations(ind).pi_uncertainty  = sigma_shock ^ 2 * ...
            sqrt(Hpi' * (A ^ 4 - I) * Sigmas_post * (A ^ 4 - I)' * Hpi) * ones(Nums(k), 1);
    end
    expectations = reshape(expectations,LK,LO,LD);
    for i = 1:LO*LD
        s.pi_nowcast_12m(:,i)  = vertcat(expectations(:,i).pi_nowcast_12m);
        s.pi_forecast_12m(:,i) = vertcat(expectations(:,i).pi_forecast_12m);
        s.K(:,i)               = vertcat(expectations(:,i).K);
        s.pi_uncertainty(:,i)  = vertcat(expectations(:,i).pi_uncertainty);
    end
end