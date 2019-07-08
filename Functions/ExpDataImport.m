function [...
          Exp_Time, Exp_Current,...
          User_Abort]= ExpDataImport()
      
%% Experimental Data

[ExpData_Filename,ExpData_Filepath] = uigetfile('*.xlsx', 'Select File with Experimental Data');
ExpData = fullfile(ExpData_Filepath,ExpData_Filename);

if ExpData_Filename == 0
    User_Abort = 2;
    Exp_Time = [];
    Exp_Current = [];
else
    User_Abort = 0;
    [Exp_Time, ~, ~] = xlsread(ExpData, 'Experimental Data', 'A:A');
    [Exp_Current, ~, ~] = xlsread(ExpData, 'Experimental Data', 'B:B');
     Exp_Current = Exp_Current*(10^6);
end
    

end