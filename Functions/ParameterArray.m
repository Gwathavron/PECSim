function [ParameterArray] = ParameterArray(k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
          l1,z_X,...
          t_exp, t_eq, t_rec,...
          d_E, Temp, E_hold,...
          beta_1, beta_2,...
          N_Space,...
          timesteps,...
          Fps...
         )
         
%% Creat array from values
ParameterArray = [k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
          l1,z_X,...
          t_exp, t_eq, t_rec,...
          d_E, Temp, E_hold,...
          beta_1, beta_2,...
          N_Space,...
          timesteps,...
          Fps...
         ];
end