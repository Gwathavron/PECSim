function [] = cancleodestatbar(odewbar,event)
% function handle to cancel waitbar and running ode with global boolean
% CclSim. If true than the next call of odefcn will break the ode and
% returns an error
global CclSim
    answer = questdlg('Do you really want to cancel Simulation?','','Yes','No','No');
    switch answer
        case 'Yes'
          CclSim = true;  
          delete(odewbar)
        case 'No'
            return
        case ''
            return
    end
end
