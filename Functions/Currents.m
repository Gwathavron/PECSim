function [i_main_SC1, i_main, i_SC2_SC1, i_SC2, i_SC1, i_tot] = Currents (h, X_Nodes, N_X_Nodes, t_Sol, t_Sol_SC1, N_all_timesteps, C_Sol_SC1, C_Sol, factor_main, factor_SC2)

%% Interpolation and Oberserving Change of Concentration near the Electrode

% C_Sol is a function of space and time, need for 4/5 Datapoint in space
% and all in time so C_Sol(time,1:5) for mediator and
% c_sol(time,1+N_X_Nodes:5+N_X_Nodes)

    % Grid = unigrid(0,((sum(X_Nodes(1:2)))/4),(2*sum(X_Nodes(1:2))));
    
    t = numel(t_Sol);
    t_SC1 = numel(t_Sol_SC1);
    
    dC_M_SC1  = zeros(t_SC1,1);
    dC_S1_SC1 = zeros(t_SC1,1);
    
    dC_M  = zeros(t,1);
    dC_S1 = zeros(t,1);

    
for i = 1:t_SC1 
    dC_M_SC1(i,1)  = (C_Sol_SC1(i,2) - C_Sol_SC1(i,1))./h(1);
    dC_S1_SC1(i,1) = (C_Sol_SC1(i,(2+N_X_Nodes)) - C_Sol_SC1(i,(1+N_X_Nodes)))./h(1);
end
for i = 1:t
    dC_M(i,1)      = (C_Sol(i,2)-C_Sol(i,1))./h(1);
    dC_S1(i,1)     = (C_Sol(i,(2+N_X_Nodes))-C_Sol(i,(1+N_X_Nodes)))./h(1);
end

i_main_SC1 = (dC_M_SC1./factor_main)*10^(6);
i_main = (dC_M./factor_main)*10^(6);

i_SC2_SC1 = -1*(dC_S1_SC1./factor_SC2)*10^(6);
i_SC2 = -1*(dC_S1./factor_SC2)*10^(6);

% i_main_SC1 means no SC1

i_SC1 = i_main - i_main_SC1;
i_tot = i_main + i_SC2;

end


