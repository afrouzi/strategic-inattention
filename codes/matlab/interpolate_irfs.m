% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function interpolates the IRFs of the calibrated model over a finer time grid.

function s = interpolate_irfs(s)
	% see if dt is given as an option, if not set dt = 0.01
    dt = 0.01;
	% define finer time grid
    T_max      = length(s.irfs_y_agg(:, s.calib.o_ind, s.calib.d_ind));
    t          = 1:dt:T_max;
    s.interp.t = t;

	% initialize interpolated IRF vectors
    s.interp.irfs_y       = zeros(length(t), s.p.LK);
    s.interp.irfs_pi      = zeros(length(t), s.p.LK);

	% interpolate IRFs
    for i = 1:s.p.LK
        s.interp.irfs_y(:, i)       = interp1(1:T_max, s.irfs_y(:, i, s.calib.o_ind, s.calib.d_ind), t, 'spline');
        s.interp.irfs_pi(:, i)      = interp1(1:T_max, s.irfs_pi(:, i, s.calib.o_ind, s.calib.d_ind), t, 'spline');
    end

	% interpolate aggregate IRFs
    s.interp.irfs_y_agg       = interp1(1:T_max, s.irfs_y_agg(:, s.calib.o_ind, s.calib.d_ind), t, 'spline');
    s.interp.irfs_pi_agg      = interp1(1:T_max, s.irfs_pi_agg(:, s.calib.o_ind, s.calib.d_ind), t, 'spline');
    s.interp.irfs_y_Kinf_agg  = interp1(1:T_max, s.irfs_y_Kinf_agg(:, s.calib.o_ind, s.calib.d_ind), t, 'spline');
    s.interp.irfs_pi_Kinf_agg = interp1(1:T_max, s.irfs_pi_Kinf_agg(:, s.calib.o_ind, s.calib.d_ind), t, 'spline');
end