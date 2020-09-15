% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [trainActivity,Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8] = Wmoos_data_union(ventana,name_indices,correctionMode,rotationMode)

addpath('Data\General\Training');
addpath('FeatureExtraction\Features');
addpath('PreProcessing\Functions');

users_good_checked  =  evalin('base', 'users_good_checked');
size_checked=(size(users_good_checked))*[1;0];

indseg = load(name_indices) ;
indices=indseg.indices;
gestureLocation=indseg.gestureLocation;
assignin('base','indices',indices);
assignin('base','gestureLocation',gestureLocation);

folders = orderfields(dir('Data\General\Training'));
numFolders = length(folders);
gestures = {'waveOut', 'waveIn','fist','open','pinch','noGesture'};

for i = 1:numFolders
    
    if ~(strcmpi(folders(i).name, '.') || strcmpi(folders(i).name, '..'))
        
        for j = 1:size_checked
            
            if (strcmpi(folders(i).name, users_good_checked{j,1}))
                
                info = load(['Data/General/Training/' folders(i).name '/userData.mat']) ;
                userData = info.userData;
                assignin('base','userData',userData);
                WM_gestures=6;
                nameUser_ = userData.userInfo.username;
                
                for wm=1:WM_gestures
                    
                    switch wm
                        case 1
                            wm_gesture='waveOut';
                        case 2
                            wm_gesture='waveIn';
                        case 3
                            wm_gesture='fist';
                        case 4
                            wm_gesture='open';
                        case 5
                            wm_gesture='pinch';
                        case 6
                            wm_gesture='noGesture';
                    end
                    
                    clc
                    fprintf('>> Actual user : %d / %d \n',i-2,size_checked);
                    fprintf('>> Username : %s \n',nameUser_);
                    fprintf('>> Actual gesture : %s\n',wm_gesture);
  
                    if correctionMode=="NC"
                        e_=  0;                        
                    elseif correctionMode=="C"
                        e_=  users_good_checked{j,2};
                    end
                    
                    
                    [emg,p]=WM_Extraction_mod(nameUser_,wm_gesture,e_,ventana,rotationMode);

                    
                    [Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8]=extract_mod(emg,p);
                    
                    if wm==1 && j==1
                        previus_size=1;
                        size_matrix=WM_AddData;
                        actual_size=size_matrix(1,1);
                    else
                        previus_size=(size_matrix(1,1) + 1 );
                        size_matrix=WM_Concatenate;
                        actual_size=size_matrix(1,1);
                    end
                    
                    for wrecord=previus_size:1:actual_size
                        trainActivity(wrecord)=categorical(gestures(wm));
                        assignin('base','trainActivity',trainActivity);
                    end
                end
                
 
            end
        
        end
        
    end
    
end

trainActivity= evalin('base', 'trainActivity');
Ms1  =  evalin('base', 'MS1');
Ms2  =  evalin('base', 'MS2');
Ms3  =  evalin('base', 'MS3');
Ms4  =  evalin('base', 'MS4');
Ms5  =  evalin('base', 'MS5');
Ms6  =  evalin('base', 'MS6');
Ms7  =  evalin('base', 'MS7');
Ms8  =  evalin('base', 'MS8');

end






