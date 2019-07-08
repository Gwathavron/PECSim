function [k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
          l_tot, l1_d, z_X, N_Space,...
          t_tot, tau, tau_eq, tau_rec, timesteps,...
          d_E, Temp, E_hold,...
          beta_1, beta_2,Fps,...
          Parameter,...
          User_Abort] ...
    = DataImport()
%% Load Parameters from .txt file

[Parameter_filename,Parameter_filepath] = uigetfile('*.txt','Select the Parameter File');

if Parameter_filename == 0
    User_Abort = 1;
    k_M=0;
    alpha_M=0;
    k_SC2=0;
    alpha_SC2=0;
    k_ET=0;
    k_cat=0;
    k_SP12=0;
    k_SC1=0;
    k_SV=0;
    M_tot=0;
    M_0=0;
    S1_tot=0;
    S1_0=0;
    S2_tot=0;
    S2_0=0;
    E_tot=0;
    E0_M=0;
    E0_S1=0;
    z_M=0;
    z_S1=0;
    D_M=0;
    D_SP1=0;
    D_SP2=0;
    KM=0;
    l_tot=0;
    l1_d=0;
    z_X=0;
    N_Space=0;
    t_tot=0;
    tau=0;
    tau_eq=0;
    tau_rec=0;
    timesteps=0;
    d_E=0;
    Temp=0;
    E_hold=0;
    beta_1=0;
    beta_2=0;
    Fps=0;
    Parameter=0;
    return
else
    Parameter = fullfile(Parameter_filepath,Parameter_filename);
    
    fileID = fopen(Parameter,'r');
    fgetl(fileID);fgetl(fileID);%fgetl(fileID);

    % Preallocate parameter array
    Para_arr = {};

%     for i = 1:37
%         fline = fgetl(fileID);
%         if isempty(fline)|| fline = 0
%             i
%         else
%             i
%             linesplit = strsplit(fline,',');
%             linesplit{2} = str2num(linesplit{2});
%             Para_arr{i,1} = linesplit{1};
%             Para_arr{i,2} = linesplit{2};
%             Para_arr{i,3} = linesplit{3};
%         end
%     end
    
    fline = fgetl(fileID);
    while fline ~= -1
        linesplit = strsplit(fline,',');
        linesplit{2} = str2num(linesplit{2});
        Para_arr{end+1,1} = linesplit{1};
        Para_arr{end,2} = linesplit{2};
        Para_arr{end,3} = linesplit{3};
        fline = fgetl(fileID);
    end
    
    if size(Para_arr,1) > 37
        waitfor(warndlg('Parameter file has a wrong fromat. Please use other'))
        return
    end
    
    User_Abort = 0;
    
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
    
end

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
    
    tau_eq(tau_eq == Inf|tau_eq == -Inf|isnan(tau_eq)) = 0;
    tau_rec(tau_rec == Inf|tau_rec == -Inf|isnan(tau_rec)) = 0;
    
    
    l_tot = l1*(1+z_X); %+ 6*sqrt(D_SP1*t_tot); %*(1+z_X);     % total length
    %z_X = l_tot/l1 - 1;
    l1_d = l1/l_tot;                                % dimensionless length first domain
    
end
