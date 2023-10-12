%% Example: price setting without feedback
% This example solves for a price setting problem without feedback. The
% setup for this example is outlined in 
% https://afrouzi.com/DRIPs.jl/dev/examples/ex1_pricing_nofeedback/ex1_pricing_pe_nofeedback/

clear;
addpath('../src');
%% parameters 
% state space parameters
rho     = 0.6;
sigma_u = 1;

% DRIP parameters
omega   = 100;
beta    = 0.96^0.25;
A       = [1 rho; 0 rho];
Q       = sigma_u*[1; 1];
H       = [1; 0];

% other
L       = 20; % length of irfs

%% Solve 

% solve for steady state 
ex1       = Drip(omega,beta,A,Q,H);

% solve for transition dynamics
ex1.tr    = Trip(ex1,0.01*ex1.ss.Sigma_1,'T',40);

% get irfs under the steady state information structure 
ex1.irfs.ss = irfs(ex1,'length',L);

% get irfs under the transition path information structure 
ex1.irfs.tr = irfs(ex1,'length',L,'trip',ex1.tr);

%% Plot irfs of fundamental and price 
figure;
subplot(2,2,[1,2]);
hold on;
box on;
grid on;
xlim([1,ex1.irfs.ss.T]);
title('IRFs to 1 Std. Dev. Expansionary Shock','interpreter','latex', ...
    'fontsize',12);
plot(1:ex1.irfs.ss.T,reshape(ex1.irfs.ss.x(1,1,:),[ex1.irfs.ss.T,1]), ...
    'LineWidth',3,'Color','k')
plot(1:ex1.irfs.ss.T,reshape(ex1.irfs.ss.a(1,1,:),[ex1.irfs.ss.T,1]), ...
    'LineWidth',3,'Color','b')
plot(1:ex1.irfs.tr.T,reshape(ex1.irfs.tr.a(1,1,:),[ex1.irfs.tr.T,1]), ...
    'LineWidth',3,'Color','r')
legend({'Nominal Agg. Demand ($q$)','Price IRF in Steady State ($p$)', ...
    'Price IRF in Transition Path ($p$)'}, ...
    'interpreter','latex','fontsize',10,'location','southeast')

%% Plot irfs of output 
% define output as the difference between nominal GDP and price 
y_ss = reshape(ex1.irfs.ss.x(1,1,:)-ex1.irfs.ss.a(1,1,:),[ex1.irfs.ss.T,1]);
y_tr = reshape(ex1.irfs.tr.x(1,1,:)-ex1.irfs.tr.a(1,1,:),[ex1.irfs.tr.T,1]);

subplot(2,2,3);
hold on;
box on;
grid on;

xlim([1,ex1.irfs.ss.T]);
title('Output','interpreter','latex', ...
    'fontsize',14);
plot(1:ex1.irfs.ss.T,y_ss, ...
    'LineWidth',3,'Color','b')
plot(1:ex1.irfs.ss.T,y_tr, ...
    'LineWidth',3,'Color','r')
legend({'Steady State','Transition Path'}, ...
    'interpreter','latex','fontsize',10,'location','northeast')

%% Plot irfs of inflation 
% define inflation as the growth in price
pi_ss = reshape(ex1.irfs.ss.a(1,1,2:end)-ex1.irfs.ss.a(1,1,1:end-1),[ex1.irfs.ss.T-1,1]);
pi_tr = reshape(ex1.irfs.tr.a(1,1,2:end)-ex1.irfs.tr.a(1,1,1:end-1),[ex1.irfs.tr.T-1,1]);
pi_ss = [ex1.irfs.ss.a(1,1,1);pi_ss];
pi_tr = [ex1.irfs.tr.a(1,1,1);pi_tr];

subplot(2,2,4);
hold on;
box on;
grid on;
xlim([1,ex1.irfs.ss.T]);
title('Inflation','interpreter','latex', ...
    'fontsize',14);
plot(1:ex1.irfs.ss.T,pi_ss, ...
    'LineWidth',3,'Color','b')
plot(1:ex1.irfs.ss.T,pi_tr, ...
    'LineWidth',3,'Color','r')
legend({'Steady State','Transition Path'}, ...
    'interpreter','latex','fontsize',10,'location','northeast')
