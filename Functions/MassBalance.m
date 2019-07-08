function fig = ...
    MassBalance(...
    C_Sol, Time, A_E, l_tot, z_X, X_Nodes, N_X_Nodes,...
    M_tot, S1_tot, S2_tot, M_0, S1_0, S2_0, z_M, z_S1,...
    Current, SC2_Current, SC1_Current, x...
    )

% Constants
F_A = 96485.33389;    % A s/mol
F = F_A*10^6;         % µA s/mol

% Calculate Volume and total mols of each species in the volume
% as Volume the basis volume length*electrodediameter

M_red = C_Sol(1:size(C_Sol,1),1:N_X_Nodes);
M_ox = 1-C_Sol(1:size(C_Sol,1),1:(N_X_Nodes));
M_ox(:,((N_X_Nodes)/2+0.5):N_X_Nodes) = 0;
S1 = C_Sol(1:size(C_Sol,1),N_X_Nodes+1:2*N_X_Nodes);
P1 = 1-C_Sol(1:size(C_Sol,1),N_X_Nodes+1:2*N_X_Nodes);
S2 = C_Sol(1:size(C_Sol,1),2*N_X_Nodes+1:3*N_X_Nodes);
P2 = 1-C_Sol(1:size(C_Sol,1),2*N_X_Nodes+1:3*N_X_Nodes);

n_M_red = zeros(size(C_Sol,1),1);
n_M_ox  = zeros(size(C_Sol,1),1);

n_S1 = zeros(size(C_Sol,1),1);
n_P1 = zeros(size(C_Sol,1),1);

n_S2 = zeros(size(C_Sol,1),1);
n_P2 = zeros(size(C_Sol,1),1);

for i = 1:size(C_Sol,1)
    n_M_red(i) = trapz(X_Nodes,M_red(i,:))*M_tot*A_E*l_tot*10^9;
    n_M_ox(i)  = trapz(X_Nodes,M_ox(i,:))*M_tot*A_E*l_tot*10^9;

    n_S1(i) = trapz(X_Nodes,S1(i,:))*S1_tot*A_E*l_tot*10^9;
    n_P1(i) = trapz(X_Nodes,P1(i,:))*S1_tot*A_E*l_tot*10^9;

    n_S2(i) = trapz(X_Nodes,S2(i,:))*S2_tot*A_E*l_tot*10^9;
    n_P2(i) = trapz(X_Nodes,P2(i,:))*S2_tot*A_E*l_tot*10^9;
end

% Calculate total values

    M_tot_red = sum(n_M_red(2:end)-n_M_red(1:(end-1)));
    M_tot_ox = sum(n_M_ox(2:end)-n_M_ox(1:(end-1)));
    Err_M = (abs(abs(M_tot_ox)-abs(M_tot_red))/abs(M_tot_red))*100;
    
    S1_tot_Sim = sum(n_S1(2:end)-n_S1(1:(end-1)));
    P1_tot_Sim = sum(n_P1(2:end)-n_P1(1:(end-1)));
    Err_S1 = (abs(abs(P1_tot_Sim)-abs(S1_tot_Sim))/abs(S1_tot_Sim))*100;
    Err_S1(Err_S1 == Inf | Err_S1 == -Inf | isnan(Err_S1)) = 0;
    
    S2_tot_Sim = sum(n_S2(2:end)-n_S2(1:(end-1)));
    P2_tot_Sim = sum(n_P2(2:end)-n_P2(1:(end-1)));
    Err_S2 = (abs(abs(P2_tot_Sim)-abs(S2_tot_Sim))/abs(S2_tot_Sim))*100;
    Err_S2(Err_S2 == Inf | Err_S2 == -Inf | isnan(Err_S2)) = 0;
    
% Total amount of Mediator outside of the film

    M_outside = trapz(X_Nodes((((N_X_Nodes-1)/2)+2):N_X_Nodes),M_red(end,(((N_X_Nodes-1)/2)+2):N_X_Nodes));


if strcmp(x,'M')
    fig = figure('Name','Mediator Mass Balance');
    figax = axes;
    plot(figax,Time,n_M_red,'color',rgb('Navy'),'LineWidth',1.0)
    hold(figax,'on')
    plot(figax,Time,n_M_ox,'color',rgb('Green'),'LineWidth',1.0)
    plot(figax,Time, (n_M_red+n_M_ox),'color',rgb('Red'),'LineWidth',1.0)
    hold(figax,'off')
    legend('M_{red}','M_{ox}','M_{tot}','Location','bestoutside')
    annotation(fig,'textbox', [.8 .4 .19 .32] ,'String',sprintf('Total reduced:\n %.2d mmol \n\nTotal oxidized:\n %.2d mmol \n\nTotal outside Film:\n %.2d mmol \n\nError:  %.2f %',M_tot_red, M_tot_ox, M_outside, Err_M),'FitBoxToText','off','BackgroundColor','w');
elseif strcmp(x,'Y')
    fig = figure('Name','Y Mass Balance');
    figax = axes(fig);
    plot(figax,Time,n_S1,'color',rgb('Green'),'LineWidth',1.0)
    hold(figax,'on')
    plot(figax,Time,n_P1,'color',rgb('Tomato'),'LineWidth',1.0)
    plot(figax,Time, (n_S1+n_P1),'color',rgb('Indigo'),'LineWidth',1.0)
    hold(figax,'off')
    legend('Y_{ox}','Y_{red}','Y_{tot}','Location','bestoutside')
    annotation(fig,'textbox', [.79 .4 .19 .22] ,'String',sprintf('Total Y (ox):\n %.2d mmol \n\nTotal Y (red):\n %.2d mmol \n\nError:  %.2f %',S1_tot_Sim, P1_tot_Sim, Err_S1),'FitBoxToText','off','BackgroundColor','w');
elseif strcmp(x,'Z')
    fig = figure('Name','Z Mass Balance');
    figax = axes(fig);
    plot(figax,Time,n_S2,'color',rgb('LimeGreen'),'LineWidth',1.0)
    hold(figax,'on')
    plot(figax,Time,n_P2,'color',rgb('Sienna'),'LineWidth',1.0)
    plot(figax,Time, (n_S2+n_P2),'color',rgb('Orchid'),'LineWidth',1.0)
    hold(figax,'off')
    legend('Z_{ox}','Z_{red}','Z_{tot}','Location','bestoutside')
    annotation(fig,'textbox', [.79 .4 .19 .22] ,'String',sprintf('Total Z (ox):\n %.2d mmol \n\nTotal Z (red):\n %.2d mmol \n\nError:  %.2f %',S2_tot_Sim, P2_tot_Sim, Err_S2),'FitBoxToText','off','BackgroundColor','w');
elseif strcmp(x,'Overall')
    fig = figure('Name','Overall Mass Balance', 'Position', [440 378 704 226]);
    
    
    % Total Net Product
    S1_init = S1_tot*S1_0*A_E*l_tot*10^9;
    S1_end = trapz(X_Nodes,S1(end,:))*S1_init/trapz(X_Nodes,S1(1,:));
    P1_produced = S1_init-S1_end;
    
    % Total Net Med
    M_red_init = M_tot*M_0*A_E*(l_tot/(1+z_X))*10^9;
    M_red_end = trapz(X_Nodes,M_red(end,:))*(M_red_init/trapz(X_Nodes,M_red(1,:)));
    M_reacted = M_red_init-M_red_end;
    M_produced = trapz(Time,Current)*(-1*10^9)/(z_M*F);
    M_used = M_reacted + M_produced;
    M_to_P1_ratio = P1_produced/M_used;
    
    % Substrate 2
    S2_init = S2_tot*S2_0*A_E*l_tot/(1+z_X)*10^9;
    S2_end = trapz(X_Nodes,S2(end,:))*S2_init/trapz(X_Nodes,S2(1,:));
    P2_produced = S2_init-S2_end;
    P2_init = (1-S2_0)*S2_tot*A_E*l_tot*10^6;
    P2_end = trapz(X_Nodes,(P2(end,:)))*S2_tot*A_E*l_tot/(1+z_X)*10^9;
    P1_to_P2_ratio = P2_produced/P1_tot_Sim;
    P1_to_P2_ratio(isnan(P1_to_P2_ratio)) = 0;
    
    % SC2 product loss
    P1_init = (1-S1_0)*S1_tot*A_E*l_tot*10^6;
    P1_end = trapz(X_Nodes,(P1(end,:)))*S1_tot*A_E*l_tot*10^6;
    P1SC2_loss = trapz(Time,SC2_Current)*10^3/(z_S1*F);
    
    % SC1 product loss
    P1SC1_loss = trapz(Time,SC1_Current)*(1*10^9)/(z_S1*F);
    
    % Total produced S1 due to SC1,SC2 and SP12 reaction
    S1_produced = P1SC1_loss+P1SC2_loss+P2_produced;
    
%     annotation(fig,'textbox',[.0 .0 1 1], 'String',...
%         sprintf('Solutions of mass Balance (in mmol):\n\nSubstrate 1: \n    initial    %.4d        end    %.4d        produced    %.4d\n\nProduct: \n    produced    %.4d\n\nMediator (reduced): \n    initial:    %.4d \n    end:    %.4d \n    toal reacted:    %.4d\n\nReaction ratio Mediator to Product1:    %.4d\n\nSubstrate 2: \n    inital    %.4d \n    end    %.4d\n\nProduct 2: \n    produced    %.4d \n\n Reaction ratio Product 1 to 2    %.4d:\n\nProduct 1 loss due to: \n    SC1    %.4d \n    SC2    %.4d'...
%         ,S_init,S_end,S_produced,P_produced,M_red_init,M_red_end,M_used,M_to_P_ratio,S2_init,S2_end,P2_produced,P1_to_P2_ratio,P1SC1_loss,P1SC2_loss),...
%         'FitBoxTOTExt','off','BackgroundColor','w')
    
    tabledata = {S1_init, P1_init, S2_init, P2_init, M_red_init;
                 S1_end, P1_end, S2_end, P2_end, M_red_end;
                 S1_produced, P1_produced, '', P2_produced, M_produced;
                 '', '', '', '', M_used;
                 '', '', '', '', '';
                 '', '', '', '', '';
                 M_to_P1_ratio, '', '', '', '';
                 P1_to_P2_ratio '', '', '', '';
                 '', '', '', '', '';
                 '', '', '', '', '';
                 P1SC1_loss, '', '', '', '';
                 P1SC2_loss, '', '', '', '';};
    
    Col_Name = {'Y (oxidized)  (nmol):'; 'Y (reduced)  (nmol):'; 'Z (oxidized)  (nmol):'; 'Z (reduced)  (nmol):'; 'reduced Mediator  (nmol):'};
    Row_Name = {'inital'; 'end'; 'produced'; 'total reacted'; ''; 'Ratios'; 'M(red) to Y(red):'; 'Y(red) to Z(red):'; ''; 'Y(red) loss due to'; 'SC1 (nmol):'; 'SC2 (nmol):'};
             
    CoWidth = (fig.Position(3)-110)/4;
    BackCol = [0.94 0.94 0.94; 0.94 0.94 0.94; 1 1 1];
    
    tab = uitable(fig,'Data',tabledata,'ColumnFormat',{'numeric'},'Units','normalized','Position',[0, 0, 1, 1],'ColumnWidth',{112 112 112 112 112},...
                  'BackgroundColor',BackCol,'RowStriping','on','ColumnName',Col_Name,'RowName',Row_Name,'FontSize', 12);
    
end

end


