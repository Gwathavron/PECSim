function[...
    omega_M, omega_S1, omega_S2, sqrt_omega_M, sqrt_omega_SP1, sqrt_omega_SP2,...
    kappa_cat_M, kappa_cat_S1, kappa_SC1_M, kappa_SC1_S1, kappa_SP12_S1, kappa_SP12_S2, kappa_ET_M,...
    sqrt_kappa_cat_M, sqrt_kappa_cat_S1, sqrt_kappa_SC1_M, sqrt_kappa_SC1_S1, sqrt_kappa_SP12_S1, sqrt_kappa_SP12_S2, sqrt_kappa_ET_M,...
    mu, theta,theta_bi,...
    R, F, A_E,...
    eta_M, eta_S1,...
    ypsilon0_M, ypsilon0_S1,...
    sigmab_M, sigmaf_M, sigmab_S1, sigmaf_S1,...
    kappa_main, kappa_SC2, factor_main, factor_SC2,...
    kappa_SC12, kappa_SV_M, kappa_SV_S1...
    ]...
    = DimensionlessGroups(...
    k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
    M_tot, S1_tot, S2_tot, E_tot,...
    E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
    l_tot, l1_d,...
    t_tot, tau,...
    d_E, Temp, E_hold...
    )

%% Dimensionless Groups of Differntial Equations


    % Calculating Omegas
    
    omega_M = ((l_tot*l1_d)^2)/((t_tot*tau)*D_M);
    omega_S1 = ((l_tot*l1_d)^2)/((t_tot*tau)*D_SP1);
    omega_S2 = ((l_tot*l1_d)^2)/((t_tot*tau)*D_SP2);
    
    omega_M(omega_M == Inf|omega_M == -Inf|isnan(omega_M)) = 0;
    omega_S1(omega_S1 == Inf|omega_S1 == -Inf|isnan(omega_S1)) = 0;
    omega_S2(omega_S2 == Inf|omega_S2 == -Inf|isnan(omega_S2)) = 0;
    
        % Omega suqared
        sqrt_omega_M = sqrt(omega_M);
        sqrt_omega_SP1 = sqrt(omega_S1);
        sqrt_omega_SP2 = sqrt(omega_S2);
    
    
    % Calculating Kappas
    
    kappa_cat_M = (k_cat*E_tot*(l_tot*l1_d)^2)/(M_tot*D_M);
    kappa_cat_S1 = (k_cat*E_tot*(l_tot*l1_d)^2)/(S1_tot*D_SP1);
    
    kappa_cat_M(kappa_cat_M == Inf|kappa_cat_M == -Inf|isnan(kappa_cat_M)) = 0;
    kappa_cat_S1(kappa_cat_S1 == Inf|kappa_cat_S1 == -Inf|isnan(kappa_cat_S1)) = 0;
    
        % Kappa cat squared
        sqrt_kappa_cat_M = sqrt(kappa_cat_M);
        sqrt_kappa_cat_S1 = sqrt(kappa_cat_S1);
        
        

    kappa_SV_M = (k_SV*S1_tot*E_tot*(l_tot*l1_d)^2)/(M_tot*D_M);
    kappa_SV_S1 = (k_ET*M_tot*E_tot*(l_tot*l1_d)^2)/(S1_tot*D_SP1);
    
    kappa_SV_M(kappa_SV_M == Inf|kappa_SV_M == -Inf|isnan(kappa_SV_M)) = 0; 
    kappa_SV_S1(kappa_SV_S1 == Inf|kappa_SV_S1 == -Inf|isnan(kappa_SV_S1)) = 0; 
    
    
        
    kappa_SC1_M = (k_SC1*S1_tot*(l_tot*l1_d)^2)/(D_M);
    kappa_SC1_S1 = (k_SC1*M_tot*(l_tot*l1_d)^2)/(D_SP1);
    
    kappa_SC1_M(kappa_SC1_M == Inf|kappa_SC1_M == -Inf|isnan(kappa_SC1_M)) = 0;
    kappa_SC1_S1(kappa_SC1_S1 == Inf|kappa_SC1_S1 == -Inf|isnan(kappa_SC1_S1)) = 0;

    % Kappa squared
        sqrt_kappa_SC1_M = sqrt(kappa_SC1_M);
        sqrt_kappa_SC1_S1 = sqrt(kappa_SC1_S1);
    
    kappa_SP12_S1 = (k_SP12*S2_tot*(l_tot*l1_d)^2)/(D_SP1);
    kappa_SP12_S2 = (k_SP12*S1_tot*(l_tot*l1_d)^2)/(D_SP2);
    
    kappa_SP12_S1(kappa_SP12_S1 == Inf|kappa_SP12_S1 == -Inf|isnan(kappa_SP12_S1)) = 0;
    kappa_SP12_S2(kappa_SP12_S2 == Inf|kappa_SP12_S2 == -Inf|isnan(kappa_SP12_S2)) = 0;
    
        % Kappa cat squared
        sqrt_kappa_SP12_S1 = sqrt(kappa_SP12_S1);
        sqrt_kappa_SP12_S2 = sqrt(kappa_SP12_S2);
    
    kappa_ET_M = (k_ET*E_tot*(l_tot*l1_d)^2)/(D_M);
    
    kappa_ET_M(kappa_ET_M == Inf|kappa_ET_M == -Inf|isnan(kappa_ET_M)) = 0;
    
        % Kappa cat squared
        sqrt_kappa_ET_M = sqrt(kappa_ET_M);
    
    %Calculating Mu and Theta
    
    mu = KM/S1_tot;
    theta = (k_cat)/(k_ET*M_tot);
    theta_bi = (k_SV*S1_tot)/(k_ET*M_tot); % for M
    %for S1 = (theta_bi)^-1
    
    mu(mu == Inf|mu == -Inf|isnan(mu)) = 0;
    theta(theta == Inf|theta == -Inf|isnan(theta)) = 0;
    theta_bi(theta_bi == Inf|theta_bi == -Inf|isnan(theta_bi)) = 0;
    
%% Dimensionless Groups of Current Expression

    % Definition of Natural Constants
    
    R = 8.314598;                     % kg m^2/s^2 mol K
    F = 96485.33389;                  % A s/mol
    
    % Electrode Area
    
    A_E = pi*(d_E/2)^2;
    
    % Calculating Etas 
    
    eta_M = ((E_hold-E0_M)*z_M*F)/(R*Temp);
    eta_S1 = ((E_hold-E0_S1)*z_S1*F)/(R*Temp);
    
    eta_M(eta_M == Inf|eta_M == -Inf|isnan(eta_M)) = 0;
    eta_S1(eta_S1 == Inf|eta_S1 == -Inf|isnan(eta_S1)) = 0;
    
    
    % Calculating Ypsilons
    
    ypsilon0_M = k_M*(l_tot*l1_d)/D_M;
    ypsilon0_S1 = k_SC2*(l_tot*l1_d)/D_SP1;
    
    ypsilon0_M(ypsilon0_M == Inf|ypsilon0_M == -Inf|isnan(ypsilon0_M)) = 0;
    ypsilon0_S1(ypsilon0_S1 == Inf|ypsilon0_S1 == -Inf|isnan(ypsilon0_S1)) = 0;
    
    
    % Calculating Sigmas
    
    sigmaf_M = ypsilon0_M*exp(-alpha_M*eta_M);
    sigmab_M = ypsilon0_M*exp((1-alpha_M)*eta_M);
    
    sigmaf_M(sigmaf_M == Inf|sigmaf_M == -Inf|isnan(sigmaf_M)) = 0;
    sigmab_M(sigmab_M == Inf|sigmab_M == -Inf|isnan(sigmab_M)) = 0;
    
    sigmaf_S1 = ypsilon0_S1*exp(-alpha_SC2*eta_S1);
    sigmab_S1 = ypsilon0_S1*exp((1-alpha_SC2)*eta_S1);
    
    sigmaf_S1(sigmaf_S1 == Inf|sigmaf_S1 == -Inf|isnan(sigmaf_S1)) = 0;
    sigmab_S1(sigmab_S1 == Inf|sigmab_S1 == -Inf|isnan(sigmab_S1)) = 0;

    % Calculating Kappas
    
    kappa_main = (sigmab_M+sigmaf_M);
    kappa_SC2 = (sigmab_S1+sigmaf_S1);
    
    kappa_main(kappa_main == Inf|kappa_main == -Inf|isnan(kappa_main)) = 0;
    kappa_SC2(kappa_SC2 == Inf|kappa_SC2 == -Inf|isnan(kappa_SC2)) = 0; 
    
    
    % Factors for i_main and i_SC2
    
    factor_main = (l_tot)/(z_M*F*A_E*M_tot*D_M);
    factor_SC2 = (l_tot)/(z_S1*F*A_E*S1_tot*D_SP1);
    
    factor_main(factor_main == Inf|factor_main == -Inf|isnan(factor_main)) = 0;
    factor_SC2(factor_SC2 == Inf|factor_SC2 == -Inf|isnan(factor_SC2)) = 0;
    
    
    % Ratio of Kappa 
    
    kappa_SC12 = kappa_SC1_S1/sigmab_S1;
   
    kappa_SC12(kappa_SC12 == Inf|kappa_SC12 == -Inf|isnan(kappa_SC12)) = 0; 

end
