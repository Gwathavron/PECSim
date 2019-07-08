function[figverf] = ...
    Verification(...
    l1_d, z_X, N_Space, tau, tau_eq, tau_rec, timesteps, tau_selected, beta_1, beta_2,...
    k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV, M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,l_tot, t_tot, d_E, Temp, E_hold,...
    Verf_str,...
    Time)

%% Simulation of the Cottrell experiment

 % Time and Space

 [all_timesteps, N_all_timesteps, light_on_minus, light_on_plus, light_off_minus, light_off_plus,...
 Nodes_Domain1, Nodes_Domain2, X_Nodes, N_X_Nodes, h, N_Nodes_Domain1, N_Nodes_Domain2]...
 = TimeandSpace(l1_d, z_X, N_Space, tau, tau_eq, timesteps, tau_selected, beta_1, beta_2);

    if mod(N_X_Nodes,2) == 0
        errordlg(['Number of Nodes is not uneven!' newline...
                  'Change the values of \beta'],'Error in the Space Domain');
        return
    else
    end
    
    X_Interface = X_Nodes((N_X_Nodes+1)/2);
    all_Simtimesteps = all_timesteps.*t_tot;
    
 % Dimensionless Groups

 [omega_M, omega_S1, omega_S2, sqrt_omega_M, sqrt_omega_SP1, sqrt_omega_SP2, kappa_cat_M, kappa_cat_S1, kappa_SC1_M, kappa_SC1_S1, kappa_SP12_S1, kappa_SP12_S2, kappa_ET_M,...
 sqrt_kappa_cat_M, sqrt_kappa_cat_S1, sqrt_kappa_SC1_M, sqrt_kappa_SC1_S1, sqrt_kappa_SP12_S1, sqrt_kappa_SP12_S2, sqrt_kappa_ET_M, mu, theta, theta_bi, R, F, A_E,eta_M, eta_S1,...
 ypsilon0_M, ypsilon0_S1, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1,kappa_main, kappa_SC2, factor_main, factor_SC2, kappa_SC12, kappa_SV_M, kappa_SV_S1]...
 = DimensionlessGroups(k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV, M_tot, S1_tot, S2_tot, E_tot,E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,l_tot, l1_d,t_tot, tau,d_E, Temp, E_hold);

 % Pre-allocation the inital concentration array: 1 is M, 2 is S1, 3 is S2

 C = zeros(N_X_Nodes*3,1);
    
    C(1) = M_0;                                               %(1 + exp(eta_M))^(-1);
    C(N_X_Nodes+1) =S1_0;                                    %exp((z_S1*F*E0_S1)/(R*Temp)) + (1-S1_0);
    C((N_X_Nodes*2)+1) =S2_0;
    
    for i = 2:(((N_X_Nodes-1)/2)+1)
        C(i) = M_0;
    end
    for i = (((N_X_Nodes-1)/2)+2):N_X_Nodes
        C(i) = 0;
    end
    for i = 2:N_X_Nodes
        C(i+N_X_Nodes) = S1_0;
        C(i+(N_X_Nodes*2)) = S2_0;
    end
     
    tau_tot = (1+tau_eq+tau_rec);



    Cycle_Number = 1;
        
    t_start = tic;
    
% Set everything to zero except electrode reaction (Cortrell experiment)

    kappa_cat_M = 0;
    kappa_cat_S1 = 0;
    kappa_SC1_M = 0;
    kappa_SC1_S1 = 0;
    kappa_SP12_S1 = 0;
    kappa_SP12_S2 = 0;
    kappa_SV_M = 0;
    kappa_SV_S1 = 0;
    
    % Which species should be investigated?
    if strcmp(Verf_str,'SC2 Current')
        sigmab_M = 0;
        sigmaf_M = 0;
    elseif strcmp(Verf_str,'Mediator Current')
        sigmab_S1 = 0;
        sigmaf_S1 = 0;
    end
    
    
    odeoptions = odeset('RelTol',10^(-6),'AbsTol',10^(-8),'NormControl','on','NonNegative',1:(N_X_Nodes*3));%,'OutputFcn',@odewbar);
        
        [t_Sol_SC1, C_Sol_SC1] = ode15s(@(t,x) odefunctionSimulation(t, x,...
            omega_M, omega_S1, omega_S2,...
            kappa_cat_M, kappa_cat_S1, kappa_SC1_M, kappa_SC1_S1, kappa_SP12_S1, kappa_SP12_S2,...
            mu, theta, theta_bi, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1, kappa_SV_M, kappa_SV_S1, z_S1,z_M,...
            light_on_minus, light_on_plus, light_off_minus, light_off_plus, h, z_X, N_X_Nodes, X_Nodes, tau_tot, all_timesteps,Cycle_Number),...
            all_timesteps, C, odeoptions);
        
        t_ode1 = toc(t_start);
        
        t_Sol = t_Sol_SC1;
        C_Sol = C_Sol_SC1;
        
        Time = t_Sol*t_tot;
 % Currents

 [i_main_SC1, i_main, i_SC2_SC1, i_SC2, i_SC1, i_tot] = Currents(h, X_Nodes, N_X_Nodes, t_Sol, t_Sol_SC1, N_all_timesteps, C_Sol_SC1, C_Sol, factor_main, factor_SC2);
 
 
%% SC2 Verification and Mediator

    F = F*10^6;
    
if strcmp(Verf_str,'SC2 Current')

    % Compare with quasi-reversible analytical solution
    kf = k_SC2*exp(-alpha_SC2*eta_S1);    
    kb = k_SC2*exp((1-alpha_SC2)*eta_S1);
    H_s = (kf+kb)/sqrt(D_SP1);

    if E0_S1 > E_hold
        S1_0 = S1_0;
        % Compare electrode reaction with Cortrell behavior
        I_Cottrell = -(z_S1 * F * A_E * S1_0 * S1_tot * sqrt(D_SP1)) ./ (sqrt(pi*Time));
        I_irrev = -z_S1*F*A_E*kf*S1_0*S1_tot*exp((kf^2)*Time/D_SP1).*erfc(kf*sqrt(Time)./sqrt(D_SP1));
    elseif E0_S1 < E_hold
        S1_0 = 1-S1_0;
        I_Cottrell = (z_S1 * F * A_E * S1_0 * S1_tot * sqrt(D_SP1)) ./ (sqrt(pi*Time));
        I_irrev = z_S1*F*A_E*kb*S1_0*S1_tot*exp((kb^2)*Time/D_SP1).*erfc(kb*sqrt(Time)./sqrt(D_SP1));
    end

        I_quasirev = z_S1*F*A_E*(kb*S1_0*S1_tot - kf*S1_0*S1_tot)*exp((H_s^2)*Time).*erfc(H_s*sqrt(Time));
        
        % Kinetic regime     t_tot = t_eq+t_rec+t_exp
        lambda = 2*k_SC2*sqrt(t_tot)/sqrt(D_SP1);
    
elseif strcmp(Verf_str,'Mediator Current')
    
    % Compare with quasi-reversible analytical solution
    kf = k_M*exp(-alpha_M*eta_M);
    kb = k_M*exp((1-alpha_M)*eta_M);
    H_s = (kf+kb)/sqrt(D_M);
        
    if E0_M > E_hold
        M_0 = 1-M_0;
        % Compare electrode reaction with Cortrell behavior
        I_Cottrell = -(z_M * F * A_E * M_0 * M_tot * sqrt(D_M)) ./ (sqrt(pi*Time));
        I_irrev = -z_M*F*A_E*kf*M_0*M_tot*exp((kf^2)*Time/D_M).*erfc(kf*sqrt(Time)./sqrt(D_M));
    elseif E0_M < E_hold
        M_0 = M_0;
        % Compare electrode reaction with Cortrell behavior
        I_Cottrell = (z_M * F * A_E * M_0 * M_tot * sqrt(D_M)) ./ (sqrt(pi*Time));
        I_irrev = z_M*F*A_E*kb*M_0*M_tot*exp((kb^2)*Time/D_M).*erfc(kb*sqrt(Time)./sqrt(D_M));
    end

    I_quasirev = z_M*F*A_E*(kb*M_0*M_tot - kf*M_0*M_tot)*exp((H_s^2)*Time).*erfc(H_s*sqrt(Time));
    
    % Kinetic regime     t_tot = t_eq+t_rec+t_exp
    lambda = 2*k_M*sqrt(t_tot)/sqrt(D_M);
end

if lambda >= 2.0
    Sys_str = 'Reversible System';
elseif lambda <= 0.1
    Sys_str = 'Irreversible System';
else
    Sys_str = 'Quasi-Reversible System';
end

I_Cottrell(isinf(I_Cottrell)) = I_Cottrell(2);


% Plotting the current-time curve
    if strcmp(Verf_str,'SC2 Current')
        figverf = figure('Name','SC2 Verification','Visible','on','NumberTitle','off');
    elseif strcmp(Verf_str,'Mediator Current')
        figverf = figure('Name','Mediator Verification','Visible','on','NumberTitle','off');
    end

        figverfax = axes(figverf,'Units','normalized','Position',[.1 .1 .8 .8],'TickDir','in','fontsize',12,'XColor','black','YColor','black','Box','on');
        plot(figverfax,Time,i_tot,'-','color',rgb('MidnightBlue'),'LineWidth',4) % Oxidative current from short circuit process
        hold on
        plot(figverfax,Time,I_Cottrell,'--','color',rgb('Gray'),'LineWidth',2)
        plot(figverfax,Time,I_quasirev,'-','color',rgb('Yellow'),'LineWidth',2)
        plot(figverfax,Time,I_irrev,'--','color',rgb('DarkRed'),'LineWidth',2)        
        grid on
        grid minor    
        xlabel( sprintf('Time/s'),'fontsize',14)
        ylabel( sprintf('Total Current/uA'),'fontsize',14)
        legend('MOL Sim','CA-Rev','CA-Quasi','CA-Irrev','Location','bestoutside')
        
        ann = annotation(figverf,'textbox','Position',[.75 .6 .225 .1],'String', sprintf('%s = %.2f \n%s', char(955), lambda, Sys_str));%[.725 .6 .1 .1],'Units','normalized'
        hold off
        
      
if sum(isnan(I_quasirev)) > 0 || sum(isnan(I_irrev)) > 0
    a = sum(isnan(I_quasirev));
    b = sum(isnan(I_irrev));
    warndlg(sprintf('Some values are not a number: Inf*0\n Quasirev. (%d), Irrrev. (%d)',a,b))
end



end

