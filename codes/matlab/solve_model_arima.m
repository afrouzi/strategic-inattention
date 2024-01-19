% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function solves the RI problem of the paper for one oligopoly given the parameters 
% in "p" using an arma approximation of the inflation response to monetary block in Appendix J.
% Requires z-Tran toolbox (See README.md for details on how to include it in this package)

function sol = solve_model_arima(p, options)
    
    % initialize and specify tolerance for convergence
    err            = 1;    
    iter           = 0;
    tol            = options.tol; 
    min_err        = 10;

    % matrices/vectors for the monetary shock (u) block 
    Iu   = eye(p.Tu);
    Mu   = [zeros(1, p.Tu); eye(p.Tu - 1), zeros(p.Tu - 1, 1)];

    % matrices/vectors for the mistake shock (v) block
    Mv   = [zeros(1,p.Tv); eye(p.Tv-1), zeros(p.Tv-1,1)];
    ev   = eye(p.Tv, 1);

    % other aux vars 
    Ir   = eye(p.r + 1 + p.Tv);
    ga   = 1/(p.K - 1);

    % initial guess for psi's (full information rational expectations solution)
    dpsi_u = p.Hdq;
    psi_v  = zeros(p.Tv, 1);

    while err > tol && iter < 10000
        Hu = (1 - p.alpha) * p.Hdq + p.alpha * dpsi_u; % irf of Delta desired price on monetary shocks
        Hv = p.alpha * psi_v;                          % irf of desired price on mistake shocks
        % approximate the state space matrices for xi_u given the irf of the first difference of desired price projected on monetary shocks (Delta p^*)
        [Ax, Qx, Hx] = arima_approx(Hu, p.r);

        % build the larger state space matrices for the system of monetary and mistake shocks
        A = [Ax, zeros(p.r + 1, p.Tv); zeros(p.Tv, p.r + 1), Mv];
        Q = [Qx, zeros(p.r + 1, 1); zeros(p.Tv, 1), ev];
        H = [Hx; Hv];

        % solve the RI problem
        if iter == 0
            ri = Drip(p.omega, p.beta, A, Q, H, 'method', options.drip_method, 'w', options.drip_w);
        else
            ri = Drip(p.omega, p.beta, A, Q, H, 'initOmega', ri.ss.Omega, 'initSigma', ri.ss.Sigma_1, 'method', options.drip_method, 'w', options.drip_w, 'maxit', options.drip_maxit); % limit iterations to 10 but add the DRIPs error to total error (see line 80)
        end
        
        % calculate the irf of mistakes and the irf of inflation given DRIPs solution
        BA = zeros(p.r + 1 + p.Tv, p.r + 1 + p.Tv, p.Tu);
        As = zeros(p.r + 1 + p.Tv, p.r + 1 + p.Tv, p.Tu);

        BA(:, :, 1) = Ir;
        As(:, :, 1) = Ir;
 
        for h = 2:p.Tu
            BA(:, :, h) = BA(:, :, h - 1) * (Ir - ri.ss.K * ri.ss.Y') * A;
            As(:, :, h) = As(:, :, h - 1) * A;
        end

        we    = zeros(1, p.Tu);
        C     = zeros(2, p.Tu);

        for h = 1:p.Tu
            we(h)    = (H' * BA(:, :, h) * ri.ss.K)';
            C(:, h)  = (H' * (As(:, :, h) - BA(:, :, h) * (Ir - ri.ss.K * ri.ss.Y')) * Q)';
        end

        % calculate the irf of mistakes 
        psi_v_new = zeros(p.Tv, 1);

        for i = 1:p.Tv
            psi_v_new(i) = 0.5 * ((1 - ga) * C(2, i) + sqrt((1 + ga) ^ 2 * C(2, i) ^ 2 + 4 * ga * we(i) ^ 2 * (ri.ss.Sigma_z / p.sigma_u ^ 2)));
        end

        % calculate irf of inflation
        psi_u       = C(1, 1:p.Tu)';    % irf of price 
        dpsi_u_new  = (Iu - Mu) * psi_u; % convert to inflation by taking the first difference

        % calculate convergence error
        err = norm(dpsi_u_new - dpsi_u) / norm(dpsi_u_new) + norm(psi_v_new - psi_v) / norm(psi_v_new) + ri.ss.err;
        
        % update but dampen (algorithm is sensitive to dampening weight, not sure why --- I've found for the calibrated model 0.85 works best)
        dpsi_u = (1 - p.damp) * dpsi_u_new + p.damp * dpsi_u;
        psi_v  = (1 - p.damp) * psi_v_new + p.damp * psi_v;
        
        iter = iter + 1;

        if mod(iter, 500) == 0
            fprintf("iter %d with err = %f in Model w/ K=%d, ῶ = %.4f, α = %.4f, β = %.4f\n", iter, err, p.K, p.omega, p.alpha, p.delta * p.beta)
        end

        if err < min_err % convergence error is not monotonic, so we need to keep track of the minimum error and exit with min_err > tol if the algorithm reaches maxit
            % generate and return the solution structure 
            dq              = p.sigma_u * p.Hdq;
            sol.irf_pi      = p.sigma_u * dpsi_u;
            sol.irf_y       = (Iu - Mu) \ (dq - sol.irf_pi);
            sol.irf_v       = p.sigma_u * psi_v;
            sol.Sigma_prior = ri.ss.Sigma_1;
            sol.Sigma_post  = ri.ss.Sigma_p;
            sol.Y           = ri.ss.Y;
            sol.KG          = ri.ss.K;
            sol.Sigma_z     = ri.ss.Sigma_z;
            sol.cap         = 1 - ri.omega / max(ri.ss.D);
            sol.A           = A;
            sol.Q           = Q;
            sol.H           = H;
            sol.err         = [err; ri.ss.err; iter];
            min_err = err;
        end

        if isnan(err) % not sure why but with arma approximation, sometimes the algorithm diverges, but the min_err approach works well (largest convergence error;i.e.,worst case scenario, for when this happens is 2.8e-4 so still very accurate and gives the same solution as int ma method, but not sure why this is not as robust as int ma approximation)
            break;
        end
    end

    fprintf("Model w/ K = %d, ῶ * B_∞ / B_K = %.4f, α = %.4f, β = %.4f solved w/ err = %.6f.\n", p.K, p.omega, p.alpha, p.delta * p.beta, err)
end