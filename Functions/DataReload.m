function [k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
          l_tot, l1_d, z_X, N_Space,...
          t_tot, tau, tau_eq, tau_rec, timesteps,...
          d_E, Temp, E_hold,...
          beta_1, beta_2,Fps...
          ]= DataReload(Parameter)
%% Parameter Definitons
   % l1_um, z_X, d_E_mm                                                                 |  filmthickness (um), zeta_x(-), diameter electrode (mm)
   % t, t_eq, t_rec                                                                     |  time Experiment (s), time equilibrium (s), time recovery (s)
   % M_tot_mmolL, M_red_0, S1_tot_mmolL, S1_0, S2_tot_mmolL, S2_0, E_tot_mmolL          |  total conentrations (mmol/L) and inital concentrations (%)
   % D_M, D_SP1, D_SP2                                                                  |  diffusion Coefficients (cm^2/s)
   % E0_M, E0_S1, z_M, z_S1, E_hold                                                     |  standard Potential (V), number of electrons (-), hold Potential (V)
   % k_M, alpha_M, k_SC2, alpha_SC2, k_ET_L, k_cat, k_SV_L, k_SP12_L, k_SC1_L, KM_umolL |  kinetic parameter (cm/s, -, cm/s, -, L/mol*s, 1/s, L/mol*s, L/mol*s, L/mol*s, umol/L)
   % Temp_C                                                                             |  temperature (°C)
   % timesteps, t1, t2, t3, t4, t5, FPS                                                 |  timesteps for simulation, times for plot presentation (s) MAYBE add fps as frames per seconds for film display
   % beta_1, beta_2                                                                     |  space domain coefficient (-)
   % SimMode                                                                            |  Simulation Mode (-)

%% Data Import from Excel
fileID = fopen(Parameter,'r');
    fgetl(fileID);fgetl(fileID);fgetl(fileID);

    % Preallocate parameter array
    Para_arr = {};

    for i = 1:37
        fline = fgetl(fileID);
        linesplit = strsplit(fline,',');
        linesplit{2} = str2num(linesplit{2});
        Para_arr{i,1} = linesplit{1};
        Para_arr{i,2} = linesplit{2};
        Para_arr{i,3} = linesplit{3};
    end
    
    
    %Kinetic
    k_M = Para_arr{1,2};
    alpha_M = Para_arr{2,2};
    k_SC2 = Para_arr{3,2};
    alpha_SC2  = Para_arr{4,2};
    k_ET_L = Para_arr{5,2};
    k_cat = Para_arr{6,2};
    k_SP12_L = Para_arr{7,2};
    k_SC1_L = Para_arr{8,2};
    k_SV_L = Para_arr{9,2};
  
    %Concentrations
    M_tot_mmolL = Para_arr{10,2};
    M_red_0_percent = Para_arr{11,2};
    S1_tot_mmolL = Para_arr{12,2};
    S1_ox_0_percent = Para_arr{13,2};
    S2_tot_mmolL = Para_arr{14,2};
    S2_ox_0_percent = Para_arr{15,2};
    E_tot_umolL = Para_arr{16,2};
    
     %Properties
    E0_M = Para_arr{17,2};
    E0_S1 = Para_arr{18,2};
    z_M = Para_arr{19,2};
    z_S1 = Para_arr{20,2};
    D_M = Para_arr{21,2};
    D_SP1 = Para_arr{22,2};
    D_SP2 = Para_arr{23,2};
    KM_umol = Para_arr{24,2};
    
    %Experimental Conditions
    l1_um = Para_arr{25,2};
    z_X = Para_arr{26,2};
    d_E_mm = Para_arr{27,2};
    t_exp = Para_arr{28,2};
    t_eq = Para_arr{29,2};
    t_rec = Para_arr{30,2};
    Temp_C = Para_arr{31,2};
    E_hold = Para_arr{32,2};
    
    %Simulation Parameters
    N_Space = Para_arr{33,2};
    beta_1 = Para_arr{34,2};
    beta_2 = Para_arr{35,2};
    timesteps = Para_arr{36,2};
    Fps = Para_arr{37,2};
    
%% Converting to SI units, exept lenght whichs will be cm not m

    %Kinetics
     k_ET = k_ET_L * 10^3;               % from l to cm^3
     k_SP12 = k_SP12_L * 10^3;
     k_SC1 = k_SC1_L * 10^3;
     k_SV = k_SV_L * 10^3;
  
    %Concentrations
     M_tot = M_tot_mmolL * 10^(-6);      % from mmol/L to mol/cm^3
     S1_tot = S1_tot_mmolL * 10^(-6);
     S2_tot = S2_tot_mmolL * 10^(-6);
     E_tot = E_tot_umolL * 10^(-9);
     M_0 = M_red_0_percent/100;          % converting % in number (dimensionless concentration)
     S1_0 = S1_ox_0_percent/100;
     S2_0 = S2_ox_0_percent/100;
    
    %Properties
     KM = KM_umol * 10^(-9);             % from umol/L to mol/cm^3
    
    %Experimental Conditions
     l1 = l1_um * 10^(-4);               % from um to cm
     d_E = d_E_mm * 10^(-1);             % from mm to cm
     Temp = Temp_C + 273.15;             % from °C to K

%% Dimensionless Time and Space


    %Experimental Conditions
    t_tot = t_eq + t_exp + t_rec;                   % total time
    tau = t_exp/t_tot;                              % dimensionless experimental time
    %t_eq_d = t_eq/t_tot;                           % dimensionless times
    %t_rec_d = t_rec/t_tot;
    
    tau_eq = t_eq/t_exp;
    tau_rec = t_rec/t_exp;
    
    
    l_tot = l1*(1+z_X); %+ 6*sqrt(D_SP1*t_tot); %*(1+z_X);     % total length
    %z_X = l_tot/l1 - 1;
    l1_d = l1/l_tot;                                % dimensionless length first domain
    
