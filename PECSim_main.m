function [DimGroups, Case_Currents, t_Sol_SC1, C_Sol_SC1, t_Sol, C_Sol, t_ode1, t_ode2,i_main_SC1, i_main, i_SC2_SC1, i_SC2, i_SC1, i_tot, X_Nodes, X_Interface,all_Simtimesteps]...
        = PECSim_main (SimMod, Save_Setting, abs_Tol, rel_Tol,... 
        k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1, k_SV, M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
        E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM, l_tot, l1_d, z_X, N_Space, t_tot, tau, tau_eq, tau_rec, timesteps, tau_selected,...
        d_E, Temp, E_hold, beta_1, beta_2, Fps, Exp_Time, Exp_Current,...
        Model_1, Model_2, Model_3, Model_4, No_SC1, No_SC2)
% (k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
%          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
%          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
%          l_tot, l1_d, z_X,...
%          t_tot, tau, tau_eq, tau_rec, timesteps, tau_selected,...
%          d_E, Temp, E_hold,...
%          SimMod, beta_1, beta_2,Fps,...
%          Parameter)
%        
%% Global

global t_start  % full_dCdt N_X_Nodes

%% Data Import

% [k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
%           M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
%           E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
%           l_tot, l1_d, z_X, N_Space,...
%           t_tot, tau, tau_eq, tau_rec, timesteps, tau_selected,...
%           d_E, Temp, E_hold,...
%           beta_1, beta_2,Fps,...
%           Parameter,...
%           Exp_Time, Exp_Current,...
%           User_Abort]...
%           = DataImport();

% if User_AbortImport == 1
%     errordlg('No Parameters selected','Import Error')
%           return
% elseif User_AbortImport == 2
%     warndlg('No Experimental Data selected')
%     pause(2)
% end

% if strcmp(Save_Setting,'Default')
%     Save_fun = 1;
% elseif strcmp(Save_Setting,'Personal Settings')
%     Save_fun = 2;
% else
%     warndlg(['Save settings are not specified' newline...
%               'Settings will be set to ''Default''']);
%     Save_fun = 1;
% end

try 
    
%% Time and Space

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
    
%% Dimensionless Groups

[omega_M, omega_S1, omega_S2, sqrt_omega_M, sqrt_omega_SP1, sqrt_omega_SP2, kappa_cat_M, kappa_cat_S1, kappa_SC1_M, kappa_SC1_S1, kappa_SP12_S1, kappa_SP12_S2, kappa_ET_M,...
 sqrt_kappa_cat_M, sqrt_kappa_cat_S1, sqrt_kappa_SC1_M, sqrt_kappa_SC1_S1, sqrt_kappa_SP12_S1, sqrt_kappa_SP12_S2, sqrt_kappa_ET_M, mu, theta,theta_bi, R, F, A_E, eta_M, eta_S1,...
 ypsilon0_M, ypsilon0_S1, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1,kappa_main, kappa_SC2, factor_main, factor_SC2, kappa_SC12, kappa_SV_M, kappa_SV_S1]...
 = DimensionlessGroups(k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV, M_tot, S1_tot, S2_tot, E_tot,E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,l_tot, l1_d,t_tot, tau,d_E, Temp, E_hold);

    DimGroups = [omega_M, omega_S1, omega_S2, sqrt_omega_M, sqrt_omega_SP1, sqrt_omega_SP2, kappa_cat_M, kappa_cat_S1, kappa_SC1_M, kappa_SC1_S1, kappa_SP12_S1, kappa_SP12_S2, kappa_ET_M,...
 sqrt_kappa_cat_M, sqrt_kappa_cat_S1, sqrt_kappa_SC1_M, sqrt_kappa_SC1_S1, sqrt_kappa_SP12_S1, sqrt_kappa_SP12_S2, sqrt_kappa_ET_M, mu, theta, R, F, A_E, eta_M, eta_S1,...
 ypsilon0_M, ypsilon0_S1, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1,kappa_main, kappa_SC2, factor_main, factor_SC2, kappa_SC12, kappa_SV_M, kappa_SV_S1,theta_bi];

    % Calculation of expected current based on region ID (for validation)

        I_Expected_Region_I_Validation = (-1).*z_M.*F.*A_E.*M_tot.*k_ET.*E_tot.*l_tot*l1_d ;

        I_Expected_Region_II_Validation = (-1).*z_M.*F.*A_E.*sqrt(D_M).*M_tot.*sqrt(k_ET).*sqrt(E_tot) ;
    
        I_Expected_Region_III_Validation = (-1).*((z_M.*F.*A_E)./(l_tot*l1_d)).*((D_M .* M_tot)+(D_SP1.*S1_tot)) ;
    
        I_Expected_Region_V_Validation = (-1).*(z_M.*F.*A_E.*(l_tot*l1_d).*E_tot.*k_cat.*S1_tot)./(KM+S1_tot) ;
    
        I_Expected_Region_VII_Validation = (-1).*z_M.*F.*A_E.* sqrt((2.*D_M*M_tot.*k_cat.*E_tot.*S1_tot)./(KM+S1_tot)) ;
        
    % Calculations of the Savient Cases
        
        I_Expected_Region_R_Validation = (-1).*z_M.*F.*A_E.*k_SV*10^(-3).*M_tot.*S1_tot.*(l_tot*l1_d) ;
    
%         I_Expected_Region_S_Validation_diss =
%         (-1).*z_M.*F.*A_E.*sqrt(D_SP1).*S1_tot./(l_tot*l1_d);
        I_Expected_Region_S_Validation = (-1).*z_M.*F.*A_E.*D_SP1.*S1_tot./(l_tot*l1_d);
    
        I_Expected_Region_E_Validation = (-1).*z_M.*F.*A_E.*M_tot.*D_M./(l_tot*l1_d) ;
    
        I_Expected_Region_S_Plus_E_Validation = (-1).*z_M.*F.*A_E.*( S1_tot.*D_SP1 + M_tot.*D_M )./(l_tot*l1_d) ;
    
    Case_Currents = [I_Expected_Region_I_Validation, I_Expected_Region_II_Validation, I_Expected_Region_III_Validation, I_Expected_Region_V_Validation, I_Expected_Region_VII_Validation,...
                     I_Expected_Region_R_Validation, I_Expected_Region_S_Validation, I_Expected_Region_E_Validation, I_Expected_Region_S_Plus_E_Validation];
                 
    Case_Currents(Case_Currents == Inf | Case_Currents == -Inf | isnan(Case_Currents)) = 0;

%% Pre-allocation the inital concentration array: 1 is M, 2 is S1, 3 is S2

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
%% odefunctionSimulation

 % Set Tol from app
    abs_Tol = round(abs_Tol);
    rel_Tol = round(rel_Tol);
    Rel_Tol = 10^(-rel_Tol);
    Abs_Tol = 10^(-abs_Tol);
    
    % Save old Values
        kappa_SV_M_old = kappa_SV_M;
        kappa_SV_S1_old = kappa_SV_S1;
        kappa_SP12_S1_old = kappa_SP12_S1;
        kappa_SP12_S2_old = kappa_SP12_S2;
        
        kappa_cat_M_old = kappa_cat_M;
        kappa_cat_S1_old = kappa_cat_S1;
        
        sigmaf_S1_old = sigmaf_S1;
        sigmab_S1_old = sigmab_S1;
    % Set Model from app
    if Model_1 == 1
        kappa_SV_M = 0;
        kappa_SV_S1 = 0;
    elseif Model_2 == 1
        kappa_SV_M = 0;
        kappa_SV_S1 = 0;
        kappa_SP12_S1 = 0;
        kappa_SP12_S2 = 0;
    elseif Model_3 == 1
        kappa_cat_M = 0;
        kappa_cat_S1 = 0;
    elseif Model_4 == 1
        kappa_cat_M = 0;
        kappa_cat_S1 = 0;
        kappa_SP12_S1 = 0;
        kappa_SP12_S2 = 0;
    end
    if No_SC1 == 1
        kappa_SC1_M = 0;
        kappa_SC1_S1 = 0;
    end
    if No_SC2 == 1
        sigmaf_S1 = 0;
        sigmab_S1 = 0;
    end
    
AA = [0;1];

for i = 1:(2 -No_SC1)
    
    kappa_SC1_M_ode = kappa_SC1_M * AA(i);
    kappa_SC1_S1_ode = kappa_SC1_S1 * AA(i);

    Cycle_Number = i;
%     disp(Cycle_Number)
        
    t_start = tic;
 
    odeoptions = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'NormControl','on','NonNegative',1:(N_X_Nodes*3),'OutputFcn',@odestatbar,'Events',@odeevent);

    if i == 1
                
        [t_Sol_SC1, C_Sol_SC1] = ode15s(@(t,x) odefunctionSimulation(t, x,...
            omega_M, omega_S1, omega_S2,...
            kappa_cat_M, kappa_cat_S1, kappa_SC1_M_ode, kappa_SC1_S1_ode, kappa_SP12_S1, kappa_SP12_S2,...
            mu, theta, theta_bi, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1, kappa_SV_M, kappa_SV_S1, z_S1,z_M,...
            light_on_minus, light_on_plus, light_off_minus, light_off_plus, h, z_X, N_X_Nodes, X_Nodes, tau_tot, all_timesteps, Cycle_Number),...
            all_timesteps, C, odeoptions);
        
        t_ode1 = toc(t_start);
        
        
    elseif i == 2
        
        [t_Sol, C_Sol] = ode15s(@(t,x) odefunctionSimulation(t, x,...
            omega_M, omega_S1, omega_S2,...
            kappa_cat_M, kappa_cat_S1, kappa_SC1_M_ode, kappa_SC1_S1_ode, kappa_SP12_S1, kappa_SP12_S2,...
            mu, theta,theta_bi, sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1, kappa_SV_M, kappa_SV_S1, z_S1,z_M,...
            light_on_minus, light_on_plus, light_off_minus, light_off_plus, h, z_X, N_X_Nodes, X_Nodes, tau_tot, all_timesteps, Cycle_Number),...
            all_timesteps, C, odeoptions);
        
        t_ode2 = toc(t_start);
    end 
end

    if No_SC1 == 1
        t_Sol = t_Sol_SC1;
        C_Sol = C_Sol_SC1;
        t_ode2 = 0;
    end
    
    %Reassign old values
        kappa_SV_M = kappa_SV_M_old;
        kappa_SV_S1 = kappa_SV_S1_old;
        kappa_SP12_S1 = kappa_SP12_S1_old;
        kappa_SP12_S2 = kappa_SP12_S2_old;
        
        kappa_cat_M = kappa_cat_M_old;
        kappa_cat_S1 = kappa_cat_S1_old;
  
        sigmaf_S1 = sigmaf_S1_old;
        sigmab_S1 = sigmab_S1_old;
%% Currents

[i_main_SC1, i_main, i_SC2_SC1, i_SC2, i_SC1, i_tot] = Currents (h, X_Nodes, N_X_Nodes, t_Sol, t_Sol_SC1, N_all_timesteps, C_Sol_SC1, C_Sol, factor_main, factor_SC2);

I_Expected_Region_S_Validation_YZ = (-1).*z_M.*F.*A_E.*D_SP2.*S2_tot./(l_tot*l1_d);

catch ME
    errordlg(ME.message,'Error!');
    
end

