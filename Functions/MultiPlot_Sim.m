function [] = MultiPlot_Sim(Save_Setting,...
                                Time,i_tot,i_main_SC1,i_main,i_SC2,Exp_Time,Exp_Current,t_ode,...
                                X_Nodes,X_Interface,z_X,...
                                C_M,C_S1,C_P1,C_S2,...
                                t_selected,all_Simtimesteps)

%% Create Current Figure with a UIcontrol to use saveas

    x = X_Nodes;   
%% Current Time Plot                
    Fig = figure('Name','Multiplot of Simulation Results','NumberTitle','off','Visible','on','pos',[125 75 1200 675]);
    
    SimPlotAxis = subplot(3,4,[11,12]); %axes('Parent',Fig);         
    plot(SimPlotAxis, Time, i_tot,'-','color',rgb('MidnightBlue'),'DisplayName','i_{tot}','LineWidth',4);
    hold(SimPlotAxis,'on')
    plot(SimPlotAxis,Time, i_main_SC1,':','color',rgb('DodgerBlue'),'DisplayName','i_{main-SC1}','LineWidth',2);
    plot(SimPlotAxis,Time, i_main,'--','color',rgb('DarkGrey'),'DisplayName','i_{main}','LineWidth',2);
    plot(SimPlotAxis,Time, i_SC2,'--','color',rgb('DarkRed'),'DisplayName','i_{SC2}','LineWidth',2);
    hold(SimPlotAxis,'off')
                
            
    YLim_up = max([i_tot; i_main_SC1; i_main; i_SC2; Exp_Current]);
    YLim_bottom = min([i_tot; i_main_SC1; i_main; i_SC2; Exp_Current]);
         
    SimPlotAxis.XLim = [0,max(Time)];
    SimPlotAxis.YLim = [YLim_bottom,YLim_up];
            
    SimPlotAxis.XMinorGrid = 'on';
    SimPlotAxis.YMinorGrid = 'on';
                        
    SimPlotAxis.TickDir = 'in';
    SimPlotAxis.FontSize = 12;
    SimPlotAxis.Box = 'on';
    SimPlotAxis.XLabel.String = sprintf('Time/s');
    SimPlotAxis.XLabel.FontSize = 14;
    SimPlotAxis.YLabel.String = sprintf('Total Current/%cA',char(181));
    SimPlotAxis.YLabel.FontSize = 14;
            
    lgd_SimPlot = legend(SimPlotAxis);
    lgd_SimPlot.Location = 'bestoutside';

    
%% Plot Concentration Profiles at different Times

for a = 1:length(Time)
    for n = 1:length(t_selected)
        if round(all_Simtimesteps(a),2) == t_selected(n)
            if n == 9
                SimPlotAxisConc = subplot(3,4,[9,10]);
            else
                SimPlotAxisConc = subplot(3,4,n);
            end
            
            plot(SimPlotAxisConc, x, C_M(a,:),'.','color',rgb('Navy'),'DisplayName','M_{red}','MarkerSize',3);
            hold(SimPlotAxisConc,'on')
            plot(SimPlotAxisConc,x, C_S1(a,:),'.','color',rgb('Gold'),'DisplayName','Y_{ox}','MarkerSize',3);
            plot(SimPlotAxisConc,x, C_P1(a,:),'.','color',rgb('Tomato'),'DisplayName','Y_{red}','MarkerSize',3);
            plot(SimPlotAxisConc,x, C_S2(a,:),'.','color',rgb('DarkOrange'),'DisplayName','Z_{ox}','MarkerSize',3);
            plot(SimPlotAxisConc,[X_Interface,X_Interface],[0,1],'-','color',rgb('DarkSlateGray'),'DisplayName','Film Edge','LineWidth',2);
            hold(SimPlotAxisConc,'off')
    
            if X_Interface < 0.5     
                SimPlotAxisConc.XLim = [0,2*X_Interface];
            else
                SimPlotAxisConc.XLim = [0,1];
            end
    
            SimPlotAxisConc.YLim = [0,1];
            
            SimPlotAxisConc.XMinorGrid = 'on';
            SimPlotAxisConc.YMinorGrid = 'on';

            SimPlotAxisConc.TickDir = 'in';
            SimPlotAxisConc.FontSize = 12;
            SimPlotAxisConc.Box = 'on';
            SimPlotAxisConc.Title.String = sprintf( 'Time = %0.1f s',Time(a));

            
            if n == 9
                SimPlotAxisConc.XLabel.String = sprintf('Dim. Dis.');
                SimPlotAxisConc.XLabel.FontSize = 14;
                SimPlotAxisConc.YLabel.String = sprintf('Dim. Conc.');
                SimPlotAxisConc.YLabel.FontSize = 14;
                lgd_SimPlot = legend(SimPlotAxisConc);
                lgd_SimPlot.NumColumns = 1;
                lgd_SimPlot.FontSize = 8;
                lgd_SimPlot.Location = 'bestoutside';
            end
        end
    end
end
%% Save created Fig    

if Save_Setting == 1
    dir = uigetdir;
    DestinationFolder = dir;
    Filepath = DestinationFolder;
    Filename = 'Multiplot Simulation Results';
    indx = 'png';
end

if Save_Setting == 2

    [Filename, Filepath, indx] = uiputfile(...
        {'*.m;*.fig','MATLAB Files (*.m,*.fig)';
        '*.jpg','JPEG Image (*.jpg)';
        '*.png','Portable Network Graphics (*.png)';
        '*.eps','Encapsulated PostScript (*.eps)';
        '*.pdf','Portable Document Format (*.pdf)';
        '*.svg','SVG scaleable vector graphics (*.svg)';
        '*.bmp','Windows Bitmap (*.bmp)';
        '*.emf','Enhanced Metafile (*.emf)';
        '*.pbm','Portable Bitmap File (*.pbm)';
        '*.ppm','Portable Pixmap (*.ppm)';
        '*.tif','TIFF Image (*.tif)'...
        });
    if indx == 1
        indx = 'mfig';
    elseif indx == 2
        indx = 'jpeg';
    elseif indx == 3
        indx = 'png';
    elseif indx == 4
        indx = 'epsc';   
    elseif indx == 5
        indx = 'pdf';
    elseif indx == 6
        indx = 'svg';    
    elseif indx == 7
        indx = 'bmp';    
    elseif indx == 8
        indx = 'meta';
    elseif indx == 9
        indx = 'pbm';
    elseif indx == 10
        indx = 'ppm';    
    elseif indx == 11
        indx = 'tiffn'; 
    else
        indx = 'png';
    end
end

if Save_Setting == 3
    dir = uigetdir;
    DestinationFolder = dir;
    Filepath = DestinationFolder;         
    Filename = 'Multiplot of Simulation Results.fig';
    indx = 'fig';
end

if sum(dir) == 0 || sum(indx) == 0
    return
end

I_t_Fullfile = fullfile(Filepath,Filename);
saveas(Fig,I_t_Fullfile,indx)

end
