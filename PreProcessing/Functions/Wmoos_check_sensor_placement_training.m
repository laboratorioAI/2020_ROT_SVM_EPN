% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [users_to_check,users_good_check,user_names] = Wmoos_check_sensor_placement_training(name_indices,rotation_Mode,syncro)

addpath('Data\Specific');
addpath('FeatureExtraction\Features');
folders = orderfields(dir('Data\Specific'));
numFolders = length(folders);

indseg = load(name_indices) ;
numIndper  = length(fieldnames(indseg.indices));
user_names = fieldnames(orderfields(indseg.indices));

indices=indseg.indices;
gestureLocation=indseg.gestureLocation;
assignin('base','indices',indices);
assignin('base','gestureLocation',gestureLocation);


m=1;

for i = 1:numFolders
    if ~(strcmpi(folders(i).name, '.') || strcmpi(folders(i).name, '..'))
        info = load(['Data/Specific/' folders(i).name '/userData.mat']); 
        userData = info.userData;
        assignin('base','userData',userData);
        
        for j = 1:numIndper
            if (strcmpi(folders(i).name, user_names{j,1}))
                clc
                nameUser = userData.userInfo.username;                
                
                [emg,~]=WM_Extraction_ref_train_(nameUser,1,0,rotation_Mode,syncro);               
                
                sens=WMoos_F5(emg');
                sens=sens';
                
                pos=zeros(1,syncro);
                energy_order=zeros(syncro,8);    
                
                for l=1:syncro
                    N=8;
                    if l==1
                        colum=(l : l*N);
                    else
                        colum=(l+(l-1)*(N-1) : l*N);
                    end                    
                    [~,pos(l)]=max(abs(sens(colum)));
                     energy_order(l,:)=abs(sens(colum));
                    
                end
                ref_partial=histcounts(pos,1:(8+1));
                [~,pos_]=max(ref_partial);
                ref_electrode=pos_;                         
                %==========================================================
                fprintf('Actual specific user is:  %d / %d \n',i-2, numIndper);
                fprintf('X sensor to be taken is:  %d %d \n',i-2, ref_electrode);
                if (ref_electrode == 1  || ref_electrode == 2 ||...
                    ref_electrode == 3  || ref_electrode == 4 || ref_electrode == 5 ||...
                    ref_electrode == 6  || ref_electrode == 7 || ref_electrode == 8)
                    sensor_good_placement=struct('sensor',ref_electrode);
                    sensor_energy_vals=struct('sensor_energy',energy_order);
                    good_users.users{m,1}={nameUser,sensor_good_placement};
                    good_users.users{m,2}={nameUser,sensor_energy_vals};
                    m=m+1;
                else

                end
            else
                j = 1;
            end
        end
    end
end

    users_to_check=0;    
        for i=1:m-1
            users_good_check{i,1}=good_users.users{i,1}{1,1};
            users_good_check{i,2}=good_users.users{i,1}{1,2}.sensor;
            users_good_check{i,3}=good_users.users{i,2}{1,2}.sensor_energy;
        end    
end



