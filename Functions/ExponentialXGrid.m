function [x] = ExponentialXGrid(Beta,x_max,xnumpts)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Beta is the same beta from the DigiElch paper.

% x_max is the maximum value of x

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

end