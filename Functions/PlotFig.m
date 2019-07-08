function [Axis] = PlotFig(Axis, Space, Time, Concentration, Current, Parent_Text, X_Interface, n)

if strcmp(Parent_Text,'X-Values')
    return
    
    
elseif strcmp(Parent_Text,'Concentration')
    
    Color = zeros(size(Concentration,2),3);
    DispName = strings(size(Concentration,2),1);
    for i = 1:size(Concentration,2)
        if strcmp(Concentration(1,i),'Mediator')
            DispName(i) = 'M_{red}';
            A = rgb('Navy');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Concentration(1,i),'Y (oxidized)')
            DispName(i) = 'Y_{ox}';
            A = rgb('Gold');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Concentration(1,i),'Y (reduced)')
            DispName(i) = 'Y_{red}';
            A = rgb('Tomato');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Concentration(1,i),'Z (oxidized)')
            DispName(i) = 'Z_{ox}';
            A = rgb('LimeGreen');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Concentration(1,i),'Z (reduced)')
            DispName(i) = 'Z_{red}';
            A = rgb('Sienna');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
    end
    

    plot(Axis,Space,Concentration{2,1}(n,:),'.','color',Color(1,:),'DisplayName',DispName(1),'LineWidth',1);
    lgd_Axis = legend(Axis);
    
    hold(Axis,'on')
    for i = 2:size(Concentration,2)
        if ~isempty(Concentration(2,i))
            plot(Axis,Space,Concentration{2,i}(n,:),'.','color',Color(i,:),'DisplayName',DispName(i),'LineWidth',1);
        end
    end
    plot(Axis,[X_Interface,X_Interface],Axis.YLim,'-','color',rgb('DarkSlateGray'),'DisplayName','Film Edge','LineWidth',2);
    hold(Axis,'off')
    
    Axis.XMinorGrid = 'on';
    Axis.YMinorGrid = 'on';
    
    Axis.TickDir = 'in';
    Axis.FontSize = 12;
    Axis.Box = 'on';
    Axis.XLabel.String = sprintf('Dim. Space');
    Axis.XLabel.FontSize = 14;
    Axis.YLabel.String = sprintf('Dim. Concentration');
    Axis.YLabel.FontSize = 14;
    lgd_Axis.Location = 'bestoutside';
    
    
elseif strcmp(Parent_Text,'Current')
    Color = zeros(size(Current,2),3);
    LineSpec = strings(size(Current,2),1);
    DispName = strings(size(Current,2),1);
    for i = 1:size(Current,2)
        if strcmp(Current(1,i),'Total')
            LineSpec(i) = '-';
            DispName(i) = 'i_{tot}';
            A = rgb('MidnightBlue');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Current(1,i),'Main')
            LineSpec(i) = '--';
            DispName(i) = 'i_{main}';
            A = rgb('DarkGrey');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Current(1,i),'Main no SC1')
            LineSpec(i) = ':';
            DispName(i) = 'i_{main-SC1}';
            A = rgb('DodgerBlue');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Current(1,i),'SC2 ')
            LineSpec(i) = '--';
            DispName(i) = 'i_{SC2}';
            A = rgb('DarkRed');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Current(1,i),'SC2 no SC1')
            LineSpec(i) = '--';
            DispName(i) = 'i_{SC2-SC1}';
            A = rgb('Orange');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
        if strcmp(Current(1,i),'SC1')
            LineSpec(i) = '--';
            DispName(i) = 'i_{SC1}';
            A = rgb('LightBlue');
            Color(i,1) = A(1);
            Color(i,2) = A(2);
            Color(i,3) = A(3);
        end
    end
    
    plot(Axis,Time,Current{2,1},LineSpec(1),'color',Color(1,:),'DisplayName',DispName(1),'LineWidth',2);
    lgd_Axis = legend(Axis);
    hold(Axis,'on')
    for i = 2:size(Current,2)
        if ~isempty(Current(2,i))
            plot(Axis,Time,Current{2,i},LineSpec(i),'color',Color(i,:),'DisplayName',DispName(i),'LineWidth',2);
        end
    end
    hold(Axis,'off')
    
    Axis.XMinorGrid = 'on';
    Axis.YMinorGrid = 'on';
    
    Axis.TickDir = 'in';
    Axis.FontSize = 12;
    Axis.Box = 'on';
    Axis.XLabel.String = sprintf('Time/s');
    Axis.XLabel.FontSize = 14;
    Axis.YLabel.String = sprintf('Current/%cA',char(181));
    Axis.YLabel.FontSize = 14;
    lgd_Axis.Location = 'bestoutside';
end
