function [] = DataExport(k_M, alpha_M, k_SC2, alpha_SC2, k_ET, k_cat, k_SP12, k_SC1,k_SV,...
          M_tot, M_0, S1_tot, S1_0, S2_tot, S2_0, E_tot,...
          E0_M, E0_S1, z_M, z_S1, D_M, D_SP1, D_SP2, KM,...
          l1,z_X,...
          t_exp, t_eq, t_rec,...
          d_E, Temp, E_hold,...
          beta_1, beta_2,...
          N_Space,...
          timesteps,...
          Fps,...
          Parameter...
         )
    
%% Data Import from Excel

    answer = questdlg('Save Parameters to new file?','','Yes','No','Select other file','Yes');
    
    switch answer
        case 'Yes'
            [file,path] = uiputfile('*.txt','Name new Parameter file');
            fullfilepath = fullfile(path,file);
        case 'No'
            fullfilepath = Parameter;
        case 'Select other file'
            [file,path] = uigetfile('*.txt','Select Parameter file');
            fullfilepath = fullfile(path,file);
        case ''
            return
    end
    
    
    fileID = fopen(fullfilepath,'w','native','UTF-8');
    fprintf(fileID,'Simulation Parameter for redox-active Film Simulation:\r\n');
    % fprintf(fileID,'\r\n');
    fprintf(fileID,'Parameter,\t Quantity,\t\t Unit\r\n');
    fprintf(fileID,'k_M,\t\t %.4g,\t\t cm/s\r\n',k_M);
    fprintf(fileID,'alpha_M,\t %.3g,\t\t -\r\n',alpha_M);
    fprintf(fileID,'k_SC2,\t\t %.4g,\t\t cm/s\r\n',k_SC2);
    fprintf(fileID,'alpha_SC2,\t %.3g,\t\t -\r\n',alpha_SC2);
    fprintf(fileID,'k_MP,\t\t %.4g,\t\t L/mol s\r\n',k_ET);
    fprintf(fileID,'k_cat,\t\t %.4g,\t\t 1/s\r\n',k_cat);
    fprintf(fileID,'k_YZ,\t\t %.4g,\t\t L/mol s\r\n',k_SP12);
    fprintf(fileID,'k_SC1,\t\t %.4g,\t\t L/mol s\r\n',k_SC1);
    fprintf(fileID,'k_PY,\t\t %.4g,\t\t L/mol s\r\n',k_SV);
    fprintf(fileID,'M_Tot,\t\t %.2g,\t\t mmol/L\r\n',M_tot);
    fprintf(fileID,'Ratio of M_red,\t\t %.d,\t %%\r\n',M_0);
    fprintf(fileID,'Y_Tot,\t\t %.2g,\t\t mmol/L\r\n',S1_tot);
    fprintf(fileID,'Ratio of Y_Tot,\t\t %.d,\t %%\r\n',S1_0);
    fprintf(fileID,'Z_Tot,\t\t %.2g,\t\t mmol/L\r\n',S2_tot);
    fprintf(fileID,'Ratio of Z_Tot,\t %.d,\t\t %%\r\n',S2_0);
    fprintf(fileID,'E_Tot,\t\t %.2g,\t\t %cmol/L\r\n',E_tot,181);
    fprintf(fileID,'E0_M,\t\t %.4g,\t\t V\r\n',E0_M);
    fprintf(fileID,'E0_Y,\t\t %.4g,\t\t V\r\n',E0_S1);
    fprintf(fileID,'z_M,\t\t %.d,\t\t -\r\n',z_M);
    fprintf(fileID,'z_Y,\t\t %.d,\t\t -\r\n',z_S1);
    fprintf(fileID,'D_M,\t\t %.4g,\t\t cm^2/s\r\n',D_M);
    fprintf(fileID,'D_Y,\t\t %.4g,\t\t cm^2/s\r\n',D_SP1);
    fprintf(fileID,'D_Z,\t\t %.4g,\t\t cm^2/s\r\n',D_SP2);
    fprintf(fileID,'KM,\t\t %.d,\t\t %cmol/L\r\n',KM,181);
    fprintf(fileID,'l_1,\t\t %.2g,\t\t %cm\r\n',l1,181);
    fprintf(fileID,'%c_x,\t\t %.4g,\t\t -\r\n',950,z_X);
    fprintf(fileID,'d_Electrode,\t %.2d,\t\t mm\r\n',d_E);
    fprintf(fileID,'t_exposure,\t %.2g,\t\t s\r\n',t_exp);
    fprintf(fileID,'t_equilibrium,\t %.2g,\t\t s\r\n',t_eq);
    fprintf(fileID,'t_recovery,\t %.2g,\t\t s\r\n',t_rec);
    fprintf(fileID,'T,\t\t %.2d,\t\t °C\r\n',Temp);
    fprintf(fileID,'E_hold,\t\t %.4g,\t\t V\r\n',E_hold);
    fprintf(fileID,'Spacepoints,\t %.0d,\t\t -\r\n',N_Space);
    fprintf(fileID,'%c_1,\t\t %.4d,\t\t -\r\n',946,beta_1);
    fprintf(fileID,'%c_2,\t\t %.4d,\t\t -\r\n',946,beta_2);
    fprintf(fileID,'Timesteps,\t %.0d,\t\t -\r\n',timesteps);
    fprintf(fileID,'Fps,\t\t %.0d,\t\t 1/s',Fps);

    
    fclose(fileID);
end
    
    
    
    
    
    