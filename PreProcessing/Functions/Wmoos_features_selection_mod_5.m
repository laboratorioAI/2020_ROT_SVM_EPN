function [sEMGActivityData] = Wmoos_features_selection_mod_5()
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------


addpath('Data\General\Training');
addpath('FeatureExtraction\Features');

CellEMGDataTrain  =  evalin('base', 'CellEMGDataTrain');
trainActivity     =  evalin('base', 'trainActivity');

functions_tested={'WMoos_F1', 'WMoos_F2', 'WMoos_F3', 'WMoos_F4',  'WMoos_F5'};
functions_WM={'WM_F1', 'WM_F2', 'WM_F3', 'WM_F4',  'WM_F5'};

%%                          FEATURES EXTRACTION

WM_F1  =   cellfun(@WMoos_F1,     CellEMGDataTrain);
WM_F2  =   cellfun(@WMoos_F2,     CellEMGDataTrain);
WM_F3  =   cellfun(@WMoos_F3,     CellEMGDataTrain);
WM_F4  =   cellfun(@WMoos_F4,     CellEMGDataTrain);
WM_F5  =   cellfun(@WMoos_F5,     CellEMGDataTrain);


assignin('base','WM_F1',WM_F1);
assignin('base','WM_F2',WM_F2);
assignin('base','WM_F3',WM_F3);
assignin('base','WM_F4',WM_F4);
assignin('base','WM_F5',WM_F5);


 tam=length(functions_tested);

 for i=1:tam
     
     actual_function=char(functions_tested(i));
     actual_WM=char(functions_WM(i));
     
     x_Ms1=strcat(actual_function,'_Ms1');
     x_Ms2=strcat(actual_function,'_Ms2'); 
     x_Ms3=strcat(actual_function,'_Ms3'); 
     x_Ms4=strcat(actual_function,'_Ms4'); 
     x_Ms5=strcat(actual_function,'_Ms5'); 
     x_Ms6=strcat(actual_function,'_Ms6'); 
     x_Ms7=strcat(actual_function,'_Ms7'); 
     x_Ms8=strcat(actual_function,'_Ms8'); 
     
     var_fun  =  evalin('base', actual_WM);    
     
     if i==1
          Cell_Data_EMG = array2table(var_fun,'VariableNames',{x_Ms1,x_Ms2,x_Ms3,x_Ms4,x_Ms5,x_Ms6,x_Ms7,x_Ms8});
          sEMGActivityData= Cell_Data_EMG;     
     else
          Cell_Data_EMG = array2table(var_fun,'VariableNames',{x_Ms1,x_Ms2,x_Ms3,x_Ms4,x_Ms5,x_Ms6,x_Ms7,x_Ms8});
          sEMGActivityData = horzcat(sEMGActivityData,Cell_Data_EMG);
     end
 
 end

sEMGActivityData.activity = trainActivity;
clear WM_F1 WM_F2 WM_F3 WM_F4 WM_F5


end

