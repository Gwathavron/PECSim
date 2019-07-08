function[...
    all_timesteps, N_all_timesteps, light_on_minus, light_on_plus, light_off_minus, light_off_plus,...
    Nodes_Domain1, Nodes_Domain2, X_Nodes, N_X_Nodes, h,...
    N_Nodes_Domain1, N_Nodes_Domain2]...
    = TimeandSpace(...
    l1_d, z_X, N_Space,...
    tau, tau_eq, timesteps, tau_selected,...
    beta_1, beta_2)

%% Definition of the Time Domain

timesteps_spaced = linspace(0, 1, timesteps);

light_on = tau*tau_eq;
light_off = tau*tau_eq + tau;

all_timesteps = unique([0, timesteps_spaced, light_on, light_off, tau_selected]);
    N_all_timesteps = numel(all_timesteps);

if light_on == 0   
    light_on = all_timesteps(2);
end

light_on_minus = all_timesteps(find(all_timesteps==light_on)-1);
light_on_plus = all_timesteps(find(all_timesteps==light_on)+1);


light_off_minus = all_timesteps(find(all_timesteps==light_off)-1);
light_off_plus = all_timesteps(find(all_timesteps==light_off)+1);

%% Definition of the Space Domain

N_X_Domain1 = (250*N_Space)+2;

Nodes_Domain1_plus1 = (DoubleExponentialXGrid(beta_1, N_X_Domain1))*l1_d;
    Nodes_Domain1 = [Nodes_Domain1_plus1(1:(((250*N_Space)/2)-1)), Nodes_Domain1_plus1(((250*N_Space)/2)+1:end)];
    N_Nodes_Domain1 = numel(Nodes_Domain1);
    
N_X_Domain2 = (250*N_Space)+1;

Nodes_Domain2 = ExponentialXGrid(beta_2,(1-l1_d), N_X_Domain2) + l1_d;
    N_Nodes_Domain2 = numel(Nodes_Domain2);

X_Nodes = unique([Nodes_Domain1,Nodes_Domain2(2:end)]);
    N_X_Nodes = numel(X_Nodes);
    
h = zeros(1, N_X_Nodes-1);
for i = 1:(N_X_Nodes-1)
    h(i) = X_Nodes(i+1) - X_Nodes(i);
end
