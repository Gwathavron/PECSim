function [] = SaveAllFig_Sim(NextPlotCounter,Save_Setting,Save_Video,...
                                Time,i_tot,i_main_SC1,i_main,i_SC2,Exp_Time,Exp_Current,t_ode,...
                                X_Nodes,X_Interface,z_X,...
                                C_M,C_S1,C_P1,C_S2,...
                                t_selected,Fps,all_Simtimesteps)

%% Create Current Figure with a UIcontrol to use saveas

    x = X_Nodes;
    
%% Current Time Plot                
    Fig = figure('Name','I-t-curve Simulation','NumberTitle','off','Visible','off');
    SimPlotAxis = axes('Parent',Fig);
                

                
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
    SimPlotAxis.Title.String = sprintf( 'Current-Time Curve\nCalculation Time = %0.2f s',t_ode);
    SimPlotAxis.XLabel.String = sprintf('Time/s');
    SimPlotAxis.XLabel.FontSize = 14;
    SimPlotAxis.YLabel.String = sprintf('Total Current/%cA',char(181));
    SimPlotAxis.YLabel.FontSize = 14;
            
    lgd_SimPlot = legend(SimPlotAxis);
    lgd_SimPlot.Location = 'bestoutside';

%% Current Sim vs Exp Time Plot                
    Fig_Exp = figure('Name','I-t-curve Sim. vs. Exp.','NumberTitle','off','Visible','off');
    SimPlotAxis_Exp = axes('Parent',Fig_Exp);
                

                
    plot(SimPlotAxis_Exp, Time, i_tot,'-','color',rgb('MidnightBlue'),'DisplayName','i_{tot}','LineWidth',4);
    hold(SimPlotAxis_Exp,'on')
    plot(SimPlotAxis_Exp,Exp_Time, Exp_Current,'--','color',rgb('Black'),'DisplayName','i_{exp}','LineWidth',2);
    hold(SimPlotAxis_Exp,'off')
                
            
    YLim_up_Exp = max([i_tot; Exp_Current]);
    YLim_bottom_Exp = min([i_tot; Exp_Current]);
         
    SimPlotAxis_Exp.XLim = [0,max(Time)];
    SimPlotAxis_Exp.YLim = [YLim_bottom_Exp,YLim_up_Exp];

    SimPlotAxis_Exp.XMinorGrid = 'on';
    SimPlotAxis_Exp.YMinorGrid = 'on';
                        
    SimPlotAxis_Exp.TickDir = 'in';
    SimPlotAxis_Exp.FontSize = 12;
    SimPlotAxis_Exp.Box = 'on';
    SimPlotAxis_Exp.Title.String = sprintf( 'Current-Time Curve Sim. vs. Exp.\nCalculation Time = %0.2f s',t_ode);
    SimPlotAxis_Exp.XLabel.String = sprintf('Time/s');
    SimPlotAxis_Exp.XLabel.FontSize = 14;
    SimPlotAxis_Exp.YLabel.String = sprintf('Total Current/%cA',char(181));
    SimPlotAxis_Exp.YLabel.FontSize = 14;
            
    lgd_SimPlot_Exp = legend(SimPlotAxis_Exp);
    lgd_SimPlot_Exp.Location = 'bestoutside';    
%% Plot Concentration Profiles at different Times

% Frames = repmat(struct,length(Time),1);

% if mod(length(Time),2) == 0
%     start = 2;
%     c = 0;
% elseif mod(length(Time),2) == 1
%     start = 1;
%     c = 1;
% end

% step = 2;
if Save_Video == 1
    wbar = waitbar(0,sprintf('Frame %d of %d',0,length(Time)),'Name','Video is created');
    for a = 1:length(Time) % start:steps
        Figa = figure('Name','Concentration Profles','NumberTitle','off','Visible','off');
        SimPlotAxisConc = axes('Parent',Figa);
        
        plot(SimPlotAxisConc, x, C_M(a,:),'.','color',rgb('Navy'),'DisplayName','M_{red}','LineWidth',1);
        hold(SimPlotAxisConc,'on')
        plot(SimPlotAxisConc,x, C_S1(a,:),'.','color',rgb('Gold'),'DisplayName','Y_{ox}','LineWidth',1);
        plot(SimPlotAxisConc,x, C_P1(a,:),'.','color',rgb('Tomato'),'DisplayName','Y_{red}','LineWidth',1);
        plot(SimPlotAxisConc,x, C_S2(a,:),'.','color',rgb('DarkOrange'),'DisplayName','Z_{ox}','LineWidth',1);
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
        SimPlotAxisConc.Title.String = sprintf( 'Concentration Profile Overlay Plot\nTime = %0.1f s',Time(a));
        SimPlotAxisConc.XLabel.String = sprintf('Dimensionless Distance');
        SimPlotAxisConc.XLabel.FontSize = 14;
        SimPlotAxisConc.YLabel.String = sprintf('Dimensionless Concentration');
        SimPlotAxisConc.YLabel.FontSize = 14;
        
        lgd_SimPlot = legend(SimPlotAxisConc);
        lgd_SimPlot.Location = 'bestoutside';
        
        %     k = (a+c)/2;
        %     Frames(k) = getframe(Figa);
        Frames(a) = getframe(Figa);
        
%         for n = 1:length(t_selected)
%             if all_Simtimesteps(a) == t_selected(n) %round(timesteps)
%                 Frames_static(n) = Figa;
%             end
%         end
        waitbar(a/length(Time),wbar,sprintf('Frame %d of %d',a,length(Time)));
    end
    
    close(wbar)
    % Conc_movie = movie(Frames,1,Fps);
    
    if Save_Setting == 1
        dir = uigetdir; 
        DestinationFolder = dir;
        Video_Filepath = DestinationFolder;
        Video_Filename = 'Video of Concentration Profiles';
        Video_index = 'MPEG-4';
    end
    
    
    if Save_Setting == 2
        [Video_Filename, Video_Filepath, Video_index] = uiputfile(...
            {'*.mp4','MPEG 4 (*.mp4)';
            '*.avi','Uncompressed AVI (*.avi)'...
            });
        if Video_index == 1
            Video_index = 'MPEG-4';
        elseif Video_index == 2
            Video_index = 'Uncompressed AVI';
        end
    end
    
    if Save_Setting == 3
        dir = uigetdir;
        DestinationFolder = dir;
        Frames_Filepath = DestinationFolder;
        Frames_Filename = 'Frames of Concentraion Profile Video';
        Frames_indx = '.mat';
        
        Frames_Fullfile = fullfile(Frames_Filepath,[Frames_Filename,Frames_indx]);
        save(Frames_Fullfile,'Frames','-mat')
        
        Video_Filepath = DestinationFolder;
        Video_Filename = 'Video of Concentration Profiles';
        Video_index = 'MPEG-4';
    end
    
    if sum(dir) == 0 || sum(Video_index) == 0
        
    else
        FullFileVideo = fullfile(Video_Filepath,Video_Filename);
        v = VideoWriter(FullFileVideo, Video_index);
        v.FrameRate = Fps;
        open(v)
        for k = 1 : length(Time)
            writeVideo(v,Frames(k));
        end
        close(v)
    end
    return
end

%% Save Every created Fig    

if Save_Setting == 1
    dir = uigetdir;
    DestinationFolder = dir;
    Filepath = DestinationFolder;
    Filename = 'I-t-curve';
    Filename_Exp = 'I-t-curve Sim vs Exp';
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
    [Filename_Exp] = uiputfile();
end

if Save_Setting == 3
    dir = uigetdir;
    DestinationFolder = dir;
    Filepath = DestinationFolder;         
    Filename = 'I-t-curve_Sim.fig';
    Filename_Exp = 'I-t-curve Sim vs Exp.fig';
    indx = 'fig';
end

if sum(dir) == 0 || sum(indx) == 0

else
    I_t_Fullfile = fullfile(Filepath,Filename);
    I_t_Fullfile_Exp = fullfile(Filepath,Filename_Exp);
    saveas(Fig,I_t_Fullfile,indx)
    saveas(Fig_Exp,I_t_Fullfile_Exp,indx)
end

% if Save_Video == 1
%     for k = 1:length(Frames_static)
%         DestinationFolder_static = 'Static Concentration Profiles';
%         status = mkdir(Filepath,DestinationFolder_static);
%         Filepath_static = [Filepath,'/',DestinationFolder_static];
%         Filename_Conc = sprintf('Concentration Profile Time_%0.2f s.%s',t_selected(k),indx);
%         if sum(dir) == 0 || sum(indx) == 0
%             return
%         elseif status == 0
%             msgbox('Filepath could not be created')
%         end
%         Conc_Fullfile = fullfile(Filepath_static,Filename_Conc);
%         if isgraphics(Frames_static(k))
%             saveas(Frames_static(k),Conc_Fullfile,indx);
%         end
%     end
% else
% Plot Concentration Profiles at different Times
   t = find(ismember(Time,t_selected));
   for a = 1:length(t)
       Figa = figure('Name','Concentration Profles','NumberTitle','off','Visible','off');
       SimPlotAxisConc = axes('Parent',Figa);
       plot(SimPlotAxisConc, x, C_M(t(a),:),'.','color',rgb('Navy'),'DisplayName','M_{red}','MarkerSize',3);
       hold(SimPlotAxisConc,'on')
       plot(SimPlotAxisConc,x, C_S1(t(a),:),'.','color',rgb('Gold'),'DisplayName','Y_{ox}','MarkerSize',3);
       plot(SimPlotAxisConc,x, C_P1(t(a),:),'.','color',rgb('Tomato'),'DisplayName','Y_{red}','MarkerSize',3);
       plot(SimPlotAxisConc,x, C_S2(t(a),:),'.','color',rgb('DarkOrange'),'DisplayName','Z_{ox}','MarkerSize',3);
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
       SimPlotAxisConc.Title.String = sprintf( 'Concentration Profile Overlay Plot\nTime = %0.1f s',Time(t(a)));
       SimPlotAxisConc.XLabel.String = sprintf('Dimensionless Distance');
       SimPlotAxisConc.XLabel.FontSize = 14;
       SimPlotAxisConc.YLabel.String = sprintf('Dimensionless Concentration');
       SimPlotAxisConc.YLabel.FontSize = 14;
       lgd_SimPlot = legend(SimPlotAxisConc);
       lgd_SimPlot.NumColumns = 1;
       lgd_SimPlot.FontSize = 8;
       lgd_SimPlot.Location = 'bestoutside';
       Frames_static(a) = Figa;
   end
   for k = 1:length(Frames_static)
        DestinationFolder_static = 'Static Concentration Profiles';
        status = mkdir(Filepath,DestinationFolder_static);
        Filepath_static = [Filepath,'/',DestinationFolder_static];
        Filename_Conc = sprintf('Concentration Profile Time_%0.2f s.%s',Time(t(k)),indx);
        if sum(dir) == 0 || sum(indx) == 0
            return
        elseif status == 0
            msgbox('Filepath could not be created')
        end
        Conc_Fullfile = fullfile(Filepath_static,Filename_Conc);
        saveas(Frames_static(k),Conc_Fullfile,indx);
    end
% end