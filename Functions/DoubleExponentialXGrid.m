function [x] = DoubleExponentialXGrid(Beta,TotNumXPts)

% Based on modification of the single exponentially expanding grid used for
% semi-infinite geometry.  Instead of letting x go from 0 to x_max, which
% is determined based on the diffusion layer thickness, the points are
% split into two groups.

% The first group, from 0 to 0.5 (halfway through the normalized thickness
% of the film), the exponential grid is done as normal.  For the second
% group, the points from the first group are subtracted from 1 in order to
% reflect the points.

% The result is a symmetrical set of exponentially spaced points in the
% film, with concentration of points at the edges.


% The initial set of exponentially increasing points


%     TotNumPts=100; % Total number of points
%     Beta=0.50; %Typical value chosen
    
    xnumpts=TotNumXPts/2; %Number of points for each sub-section
    x_max=0.4999; %Maximum value of the x-variable

    % Pre-allocation of memory for x
        x=zeros(0,xnumpts);
    
    % Calculation of the exponential series sum

        ExpSeriesSum=0;
    
            ExpSeriesContribution=zeros(0,xnumpts-1);
        for j=1:xnumpts-1
            ExpSeriesContribution(j)=exp(Beta*(j-1));
            ExpSeriesSum=ExpSeriesSum + ExpSeriesContribution(j);
        end
    
    % Calculation of deltaX

        DeltaX=x_max./ExpSeriesSum;
    
    % Generation of the x grid

        % Calculation of the local spacing
                LocalSpacing=zeros(0,xnumpts);
            for k=1:xnumpts-1
                LocalSpacing(k)=DeltaX.*ExpSeriesContribution(k);
            end
        
        % Adding the local spacing to each data point
    
                x(1)=0;
            for l=2:xnumpts
                x(l)=x(l-1)+LocalSpacing(l-1);
            end

    % Keeping the initial set of points
    
        xleft=x;
        
    % Obtaining the right-hand set of points
    
        xright=1-x;
        
    % Reordering the right-hand set of points before combining (needs to be
    % in ascending order)
    
        xright=sort(xright,'ascend');
        
    % Combining the points together
    
        x = [xleft xright];
            
end