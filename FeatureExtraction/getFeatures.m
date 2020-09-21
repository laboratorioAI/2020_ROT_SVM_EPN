function emgActivity = getFeatures(emgData)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------



low_umbral       = evalin('base','low_umbral');
high_umbral      = evalin('base','high_umbral');
energy_          = WMoos_F5(emgData');

    
tic 

if sum(energy_(1:4,:)) > high_umbral  || sum(energy_(5:8,:)) > low_umbral 
    TestedData=emgData';
    Ms1=TestedData(1,:);
    Ms2=TestedData(2,:);
    Ms3=TestedData(3,:);
    Ms4=TestedData(4,:);
    Ms5=TestedData(5,:);
    Ms6=TestedData(6,:);
    Ms7=TestedData(7,:);
    Ms8=TestedData(8,:);
    TableEmgData = table(Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8);



    WM_F1   =   varfun(@WMoos_F1,     TableEmgData);
    WM_F2   =   varfun(@WMoos_F2,     TableEmgData);
    WM_F3   =   varfun(@WMoos_F3,     TableEmgData);
    WM_F4   =   varfun(@WMoos_F4,     TableEmgData);
    WM_F5   =   varfun(@WMoos_F5,     TableEmgData);
   

    emgActivity      = [WM_F1,  WM_F2,  WM_F3,  WM_F4,  WM_F5];

                          
    assignin('base','check_umbral','classificationNeeded'); 
    timeFeaturing=toc; 
    assignin('base','timeFeaturing',timeFeaturing); 
else 
    timeFeaturing=toc;
    emgActivity=0;
    assignin('base','check_umbral','noClassificationNeeded');
    assignin('base','timeFeaturing',timeFeaturing);
end




end

