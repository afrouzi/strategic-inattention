% Afrouzi (2023): Strategic Inattention, Inflation Dynamics, and the Non-Neutrality of Money

% This function generates the identification of omega figure (Fig. A3) reported in the paper.
% "s" is the structure of the solved model, "glob" is the global variables, and "name" is the name of the
% generated figure that is saved in the "out" folder.

function figure_identification(s, s_grid, glob, name)

	fig = figure;
	hold on;
	box on; grid on;
	
	% RE-NORMALIZATION: now that we have clibrated omega, we rescale it to the normalization in the paper: in the paper we need to solve B_j*s_u^2*var+omega_paper*Info_cost, but here we solve var+omega_j*Info_cost where omega_j = Omega_Coeff_j*omega_code. So omega_paper/B_j*s_u^2=Omega_Coeff_j*omega_code, where Omega_Coeff_j=B_inf/B_j so omega_paper = B_inf*s_u^2*omega_code. 
	omega_r = s_grid.p.omega * s_grid.p.eta * (1 + s_grid.p.gamma * s_grid.p.eta) / (1 + s_grid.p.gamma) * glob.moments.sigma_shock ^ 2;
	
	% save omega_star as the renormalized value of calibrated omega 
	omega_star = s.p.omega * s.p.eta * (1 + s.p.gamma * s.p.eta) / (1 + s.p.gamma) * glob.moments.sigma_shock ^ 2;
	
	% set the end index for the plot as the index of the value of omega_r that is closest to 2*omega_star
	try
		[~, end_ind] = min(abs(omega_r - 2*omega_star));
	catch
		end_ind = length(omega_r);
	end

	% set the x axis grid as the values of renormalized omega from 1 to end index
	omega_r_plot = omega_r(1:end_ind);
	
	% get the standard errors of the coefficeints from the model generated data
	b_int_low  = squeeze(s_grid.calib.forecast_std_errs(2,1,1:end_ind));
	b_int_high = squeeze(s_grid.calib.forecast_std_errs(2,2,1:end_ind));

	% plot the estimated value coefficeints with standard errors from model generated data
	plot(omega_r_plot,s_grid.calib.forecast_estimates(2,1:end_ind),'-k','LineWidth',4);
	plot(omega_r_plot,b_int_low,'--r','LineWidth',2);
	plot(omega_r_plot,b_int_high,'--r','LineWidth',2);

	% plot the estimated value coefficeints with standard errors from the data
	errorbar(omega_star,glob.moments.pi12_epi12,0.008,'-ob','LineWidth',4);
	plot(omega_r_plot,glob.moments.pi12_epi12*ones(length(omega_r_plot),1),'-.b','LineWidth',2);
	
	% plot options
	xlabel('Cost of Attention ($\omega$)','Interpreter','Latex','FontSize',12);
	ylabel('Coefficient on the Prior ($\delta$)','Interpreter','Latex','FontSize',12);
	axis tight
	
	fig.PaperUnits='inches';
	fig.PaperPosition=[0 0 3.25 2.5];
	
	% save the figure
	print(fullfile(glob.outdir, append(name, '.eps')),'-depsc','-tiff')
end