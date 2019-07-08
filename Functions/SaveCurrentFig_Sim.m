function [] = SaveCurrentFig_Sim(NextPlotCounter,Save_Setting,...
                                Time,i_tot,i_main_SC1,i_main,i_SC2,Exp_Time,Exp_Current,t_ode,...
                                XLim_low,XLim_up,YLim_low,YLim_up,...
                                X_Nodes,X_Interface,z_X,...
                                C_M,C_S1,C_P1,C_S2)

%% Create Current Figure with a UIcontrol to use saveas

            
    a = NextPlotCounter+1;
    x = X_Nodes;
       

if NextPlotCounter > length(Time) || NextPlotCounter < 0
                
    Fig = figure('Name','I-t-curve Simulation','NumberTitle','off','Visible','off');
    SimPlotAxis = axes('Parent',Fig);
                
    %Current Time Plot
                
    plot(SimPlotAxis, Time, i_tot,'-','color',rgb('MidnightBlue'),'DisplayName','i_{tot}','LineWidth',4);
    hold(SimPlotAxis,'on')
    plot(SimPlotAxis,Time, i_main_SC1,':','color',rgb('DodgerBlue'),'DisplayName','i_{main-SC1}','LineWidth',2);
    plot(SimPlotAxis,Time, i_main,'--','color',rgb('DarkGrey'),'DisplayName','i_{main}','LineWidth',2);
    plot(SimPlotAxis,Time, i_SC2,'--','color',rgb('DarkRed'),'DisplayName','i_{SC2}','LineWidth',2);
    plot(SimPlotAxis, Exp_Time,Exp_Current,'--','color',rgb('Black'),'DisplayName','i_{exp}','LineWidth',2);
    hold(SimPlotAxis,'off')
                
            
    SimPlotAxis.XLim = [XLim_low,XLim_up];
    SimPlotAxis.YLim = [YLim_low,YLim_up];
            
    SimPlotAxis.XMinorGrid = 'on';
    SimPlotAxis.YMinorGrid = 'on';
                        
    SimPlotAxis.TickDir = 'in';
    SimPlotAxis.FontSize = 12;
    SimPlotAxis.Box = 'on';
    SimPlotAxis.Title.String = sprintf( 'Current-Time Curve\n Calculation Time = %0.2f s',t_ode);
    SimPlotAxis.XLabel.String = sprintf('Time/s');
    SimPlotAxis.XLabel.FontSize = 14;
    SimPlotAxis.YLabel.String = sprintf('Total Current/%cA',char(181));
    SimPlotAxis.YLabel.FontSize = 14;
            
    lgd_SimPlot = legend(SimPlotAxis);
    lgd_SimPlot.Location = 'bestoutside';
elseif NextPlotCounter == 0                      
    Fig = figure('Name','I-t Sim vs. Exp.','NumberTitle','off','Visible','off');
    SimPlotAxis = axes('Parent',Fig);
                
    %Current Time Plot
                
    plot(SimPlotAxis, Time, i_tot,'-','color',rgb('MidnightBlue'),'DisplayName','i_{tot}','LineWidth',4);
    hold(SimPlotAxis,'on')
    plot(SimPlotAxis, Exp_Time,Exp_Current,'--','color',rgb('Black'),'DisplayName','i_{exp}','LineWidth',2);
    hold(SimPlotAxis,'off')
       
    SimPlotAxis.XLim = [XLim_low,XLim_up];
    SimPlotAxis.YLim = [YLim_low,YLim_up];
            
    SimPlotAxis.XMinorGrid = 'on';
    SimPlotAxis.YMinorGrid = 'on';
                        
    SimPlotAxis.TickDir = 'in';
    SimPlotAxis.FontSize = 12;
    SimPlotAxis.Box = 'on';
    SimPlotAxis.Title.String = sprintf( 'Current-Time Curve Sim. vs. Exp.\n Calculation Time = %0.2f s',t_ode);
    SimPlotAxis.XLabel.String = sprintf('Time/s');
    SimPlotAxis.XLabel.FontSize = 14;
    SimPlotAxis.YLabel.String = sprintf('Total Current/%cA',char(181));
    SimPlotAxis.YLabel.FontSize = 14;
            
    lgd_SimPlot = legend(SimPlotAxis);
    lgd_SimPlot.Location = 'bestoutside';          
else

    Fig = figure('Name','Concentration Profiles','NumberTitle','off','Visible','off');
    SimPlotAxis = axes('Parent',Fig);
            
    % Plot Concentration Profiles at different Times
     
    plot(SimPlotAxis, x, C_M(a,:),'.','color',rgb('Navy'),'DisplayName','M_{red}','LineWidth',1);
    hold(SimPlotAxis,'on')
    plot(SimPlotAxis,x, C_S1(a,:),'.','color',rgb('Gold'),'DisplayName','Y_{ox}','LineWidth',1);
    plot(SimPlotAxis,x, C_P1(a,:),'.','color',rgb('Tomato'),'DisplayName','Y_{red}','LineWidth',1);
    plot(SimPlotAxis,x, C_S2(a,:),'.','color',rgb('DarkOrange'),'DisplayName','Z_{ox}','LineWidth',1);
    plot(SimPlotAxis,[X_Interface,X_Interface],[YLim_low,YLim_up],'-','color',rgb('DarkSlateGray'),'DisplayName','Film Edge','LineWidth',2);
    hold(SimPlotAxis,'off')
         
    SimPlotAxis.XLim = [XLim_low,XLim_up];
    SimPlotAxis.YLim = [YLim_low,YLim_up];

    SimPlotAxis.XMinorGrid = 'on';
    SimPlotAxis.YMinorGrid = 'on';

    SimPlotAxis.TickDir = 'in';
    SimPlotAxis.FontSize = 12;
    SimPlotAxis.Box = 'on';
    SimPlotAxis.Title.String = sprintf( 'Concentration Profile Overlay Plot\nTime = %0.1f s', Time(a));
    SimPlotAxis.XLabel.String = sprintf('Dimensionless Distance');
    SimPlotAxis.XLabel.FontSize = 14;
    SimPlotAxis.YLabel.String = sprintf('Dimensionless Concentration');
    SimPlotAxis.YLabel.FontSize = 14;
            
    lgd_SimPlot = legend(SimPlotAxis);
    lgd_SimPlot.Location = 'bestoutside';
end

if Save_Setting == 1
    dir = uigetdir;
    DestinationFolder = dir;
    Filepath = DestinationFolder;
    if NextPlotCounter > length(Time) || NextPlotCounter < 0
        Filename = 'I-t-curve.png';
    elseif NextPlotCounter == 0
        Filename = 'I-t Sim vs. Exp.png';
    else
        Filename = sprintf('Concentration Profile Time_%0.2f s.png',Time(a));
    end
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
    if NextPlotCounter > length(Time) || NextPlotCounter < 0
        Filename = 'I-t-curve';
    elseif NextPlotCounter == 0
        Filename = 'I-t Sim vs. Exp.fig';
    else
        Filename = sprintf('Concentration Profile at Time = %0.2f s.fig',Time(a));
    end
    indx = 'fig';
end

if sum(dir) == 0 || sum(indx) == 0
    return
end

I_t_Fullfile = fullfile(Filepath,Filename);
saveas(Fig,I_t_Fullfile,indx) 
