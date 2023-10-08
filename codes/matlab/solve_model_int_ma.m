% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function solves the RI problem of the paper for one oligopoly given the parameters 
% in "p" using an ma (integrated ma) approximation of the inflation (price) response 
% to monetary block. See documentation for details.

function sol = solve_model_int_ma(p, options)
    
    % initialize and specify tolerance for convergence
    err            = 1;     % initialize convergence error > tol
    iter           = 0;     % number of iterations to convergence in outer loop
    iter_inner_cum = 0;     % number of iterations to convergence in inner loop
    tol            = options.tol;  % tolerance for convergence (0.01 percent deviation from previous iteration)

    % matrices for the monetary shock (u) block 
    Iu   = eye(p.Tu);
    e1u  = eye(p.Tu, 1);
    Mu   = [zeros(1, p.Tu); eye(p.Tu - 1), zeros(p.Tu - 1, 1)];

    % matrices for the mistakes shock (v) block
    e1v  = eye(p.Tv, 1);
    Mv   = [zeros(1, p.Tv); eye(p.Tv - 1), zeros(p.Tv - 1, 1)];

    % matrices for the idiocyncratic shock (z) block
    e1z  = eye(p.Tz, 1);
    Mz   = [zeros(1, p.Tz); eye(p.Tz - 1), zeros(p.Tz - 1, 1)];

    % consolidated matrices for the system
    BigT = p.Tu + p.Tv + p.Tz;
    I    = eye(BigT);
    A    = [Mu + e1u * e1u', zeros(p.Tu, p.Tv + p.Tz); ...
            zeros(p.Tz,p.Tu), Mz, zeros(p.Tz,p.Tv); ...
            zeros(p.Tv,p.Tu + p.Tz), Mv];
    Q    = p.sigma_u * [e1u, zeros(p.Tu, 2); ...
                        zeros(p.Tz, 1), p.sigma_z * e1z, zeros(p.Tz, 1); ...
                        zeros(p.Tv, 2), e1v];

    % initial guess psi's as the rational exp. with full info solution
    dpsi_u = p.Hdq;             % initial guess for the inflation response to monetary shock
    psi_z  = e1z;               % initial guess for the price response in a sector to idiosyncratic shock (no such shocks in the benchmark model)
    psi_v  = zeros(p.Tv, 1);    % initial guess for the price response in a sector to mistakes shock (zero with full info because no one makes mistakes with full info)
    
    % vector form of initial guess for psi's:
    Psi    = [dpsi_u; psi_z; psi_v];
    
    % auxiliary vars
    ga   = 1 / (p.K - 1); 
    while err > tol && iter < 4000
        H = (1 - p.alpha) * [p.Hdq; e1z; zeros(p.Tv, 1)] ...
          + p.alpha * Psi;
        % solve the RI problem
        if iter == 0
            ri = Drip(p.omega, p.beta, A, Q, H, 'method', options.drip_method, 'w', options.drip_w);
            Y0 = ri.ss.Y;
            S0 = ri.ss.Sigma_z;
            err_outer = 1;
        else
            ri = Drip(p.omega, p.beta, A, Q, H, 'initOmega', ri.ss.Omega, 'initSigma', ri.ss.Sigma_1, 'method', options.drip_method, 'w', options.drip_w, 'maxit', options.drip_maxit, 'tol', options.tol); % limit iterations to 10 but add the DRIPs error to tolerance of the larger loop to parallelize the convergence of the two loops (see line 94)
            err_outer = max(abs(ri.ss.Y(:) - Y0(:))) / max(abs(Y0(:))) + max(abs(ri.ss.Sigma_z(:) - S0(:))) / max(abs(S0(:))) + ri.ss.err;
            Y0 = ri.ss.Y;
            S0 = ri.ss.Sigma_z;
        end
        err_inner = 1;
        BA = zeros(BigT, BigT, p.Tu);
        As = zeros(BigT, BigT, p.Tu);

        BA(:, :, 1) = I;
        As(:, :, 1) = I;

        for h = 2:p.Tu
            BA(:, :, h) = BA(:, :, h - 1) * (I - ri.ss.K * ri.ss.Y') * A;
            As(:, :, h) = As(:, :, h - 1) * A;
        end

        iter_inner = 0;
        while err_inner > tol && iter_inner < 4000
            we    = zeros(1, p.Tu);
            C     = zeros(3, p.Tu);
            for h = 1:p.Tu
                we(h)    = (H' * BA(:, :, h) * ri.ss.K)';
                C(:, h)  = (H' * (As(:, :, h) - BA(:, :, h) * (I - ri.ss.K * ri.ss.Y')) * Q)';
            end
            dpsi_u = (Iu - Mu) * C(1, 1:p.Tu)'; % irf of inflation = (1-L)*(irf of price) where L is lag operator
            psi_z  = C(2, 1:p.Tz)'/(p.sigma_z * p.sigma_u);
            psi_v  = zeros(p.Tv, 1);

            for i = 1:p.Tv
                psi_v(i) = 0.5 * ((1 - ga) * C(3, i) + sqrt((1 + ga) ^ 2 * C(3, i) ^ 2 + 4 * ga * we(i) ^ 2 * (ri.ss.Sigma_z / p.sigma_u ^ 2)));
            end

            Psi_new   = [dpsi_u; psi_z; psi_v];
            err_inner = max(abs(Psi_new(:) - Psi(:))) / max(abs(Psi(:))); % normalize absolute error by the norm of Psi(:) in case Psi(:) is small
            Psi       = (1 - p.damp) * Psi_new + p.damp * Psi;

            iter_inner = iter_inner + 1;
        end 
        iter_inner_cum = iter_inner_cum + iter_inner;
        iter           = iter + 1;
        err            = err_inner + err_outer;

        if mod(iter, 200) == 0
            fprintf("iter %d & err = %f in model w/ K = %d, ῶ * B_∞ / B_K = %.4f, α = %.4f, β = %.4f\n", iter, err, p.K, p.omega, p.alpha, p.delta * p.beta)
        end

    end
    % generate output 
    dq              = p.sigma_u * p.Hdq;
    sol.irf_pi      = p.sigma_u * dpsi_u;
    sol.irf_y       = (Iu - Mu) \ (dq - sol.irf_pi);
    sol.irf_v       = p.sigma_u * psi_v;
    sol.irf_z       = p.sigma_z * p.sigma_u * psi_z;
    sol.Sigma_prior = ri.ss.Sigma_1;
    sol.Sigma_post  = ri.ss.Sigma_p;
    sol.Y           = ri.ss.Y;
    sol.KG          = ri.ss.K;
    sol.Sigma_z     = ri.ss.Sigma_z;
    sol.cap         = 1 - ri.omega / max(ri.ss.D);
    sol.A           = A;
    sol.Q           = Q;
    sol.H           = H;
    sol.err         = [err; err_inner; ri.ss.err; iter; iter_inner_cum; iter_inner_cum/iter];

    if iter < 4000 && iter_inner < 4000
        fprintf("Model w/ K = %d, ῶ * B_∞ / B_K = %.4f, α = %.4f, β = %.4f solved w/ err = %.6f.\n", p.K, p.omega, p.alpha, p.delta * p.beta, err)
    else
        fprintf("Model w/ K = %d, ῶ * B_∞ / B_K = %.4f, α = %.4f, β = %.4f exited w/ maxit=4000 & err = %.6f.\n", p.K, p.omega, p.alpha, p.delta * p.beta, err)
    end
end