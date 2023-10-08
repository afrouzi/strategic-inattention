% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function solves the RI problem of the paper for grid of parameters 
% in "p" using an MA (integrated MA) approximation of the inflation (price) response 
% to monetary block. See documentation for details.

function out = solve_models_int_ma(p, glob, options)

    p.LD  = length(p.deltas);   % number of delta values
    p.LO  = length(p.omega);    % number of omega values
    p.LK  = length(p.K);        % number of K values (first column of identity matrix)
    p.Hdq = (p.rho .^ (0:1:p.Tu - 1))'; % Wold decomposition of the Delta_q
    
    out.p   = p;                % save params in output
    max_ind = p.LD * p.LO * p.LK; % total number of models to be solved

    % set number of cores to use 
    if glob.parallelize == 'Y'

        if isempty(gcp('nocreate'))
            parpool('local', glob.ncpu);
        end

        num_cores = glob.ncpu;
    elseif glob.parallelize == 'N'
        num_cores = 0;
    end

    parfor (ind = 1:max_ind, num_cores)
        [k, o, d]        = ind2sub([p.LK, p.LO, p.LD], ind);
        param            = p;
        param.K          = p.K(k);
        param.alpha      = p.alphas(k);
        param.omega_norm = p.omega_norm(k);
        param.omega      = p.omega(o) * param.omega_norm;
        param.delta      = p.deltas(d);
        param.beta       = p.beta * p.deltas(d);
        sols(ind)        = solve_model_int_ma(param, options);

        if param.K == p.K(end)
            switch options.Kinf
                case 'Y'
                    param_Kinf       = param;
                    param_Kinf.Kdist = 1; % assume one sector with monopolistic comp.
                    param_Kinf.alpha = dot(p.alphas, p.Kdist);
                    sols_Kinf(ind)   = solve_model_int_ma(param_Kinf, options);
                case 'N'
                    % do nothing
                otherwise
                    error('options.Kinf for solve must be either Y or N')
            end
        end

    end

    % save results
    out.irfs_y  = reshape([sols.irf_y], [p.Tu, p.LK, p.LO, p.LD]);
    out.irfs_pi = reshape([sols.irf_pi], [p.Tu, p.LK, p.LO, p.LD]);

    out.irfs_y_agg  = zeros(p.Tu, p.LO, p.LD);
    out.irfs_pi_agg = zeros(p.Tu, p.LO, p.LD);

    for ind = 1:p.LO * p.LD
        [o, d] = ind2sub([p.LO, p.LD], ind);

        out.irfs_y_agg(:, o, d)  = out.irfs_y(:, :, o, d) * p.Kdist;
        out.irfs_pi_agg(:, o, d) = out.irfs_pi(:, :, o, d) * p.Kdist;
    end

    out.Sigmas_prior = reshape([sols.Sigma_prior], [p.Tu + p.Tv + p.Tz, p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.Sigmas_post  = reshape([sols.Sigma_post], [p.Tu + p.Tv + p.Tz, p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.As           = reshape([sols.A], [p.Tu + p.Tv + p.Tz, p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.Hs           = reshape([sols.H], [p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.Qs           = reshape([sols.Q], [p.Tu + p.Tv + p.Tz, 3, p.LK, p.LO, p.LD]);
    out.Ys           = reshape([sols.Y], [p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.KGs          = reshape([sols.KG], [p.Tu + p.Tv + p.Tz, p.LK, p.LO, p.LD]);
    out.Sigma_zs     = reshape([sols.Sigma_z], [p.LK, p.LO, p.LD]);
    out.caps         = reshape([sols.cap], [p.LK, p.LO, p.LD]);
    out.errs         = reshape([sols.err], [6, p.LK, p.LO, p.LD]);
    % Kinf
    switch options.Kinf
        case 'Y'
            out.irfs_y_Kinf      = reshape([sols_Kinf.irf_y], [p.Tu, p.LO, p.LD]);
            out.irfs_pi_Kinf     = reshape([sols_Kinf.irf_pi], [p.Tu, p.LO, p.LD]);
            out.caps_Kinf        = reshape([sols_Kinf.cap], [p.LO, p.LD]);
            out.errs_Kinf        = reshape([sols_Kinf.err], [6, p.LO, p.LD]);
            out.irfs_y_Kinf_agg  = out.irfs_y_Kinf;
            out.irfs_pi_Kinf_agg = out.irfs_pi_Kinf;
		case 'N'
			% do nothing
		otherwise
			error('options.Kinf for solve must be either Y or N')
    end
end
