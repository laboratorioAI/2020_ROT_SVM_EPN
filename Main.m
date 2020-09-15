%
% This code is based on the paper entitled 
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
% 
% Before using this code, please read the file README
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
%  Escuela Politecnica Nacional
%  (C) Copyright Victor Hugo Vimos T.
%  2020

%-----------------------------------------
% Set Path folders if the code does not run
%------------------------------------------


exitLoop      = false;
syncro        = 4; 
energy_umbral = 0.17;
control       = true;

addpath('Data');
addpath('PreProcessing');
addpath('FeatureExtraction');
addpath('Classification');
addpath('PostProcessing');
rng('default'); 
warning off all;

while exitLoop~=true
    clc
    disp('Gesture Recognition');
    disp(' [1] Experiment 1');
    disp(' [2] Experiment 2');
    disp(' [3] Experiment 3');
    disp(' [4] Experiment 4');
    disp(' [5] Exit');
    disp(' ');
    option=input('Select an option to run:  ');
    
    switch option
               
        case 1            
               model  = selectModel();
            if model ~= false
               control=experiment_1(model,syncro,energy_umbral);
               if control==false
                   exitLoop=true;
               elseif control==true
                   exitLoop=true;
               end
            else
               disp('No model selected...')
               pause(1)
               beep;
               clear option
            end
            
        case 2
               model  = selectModel();
            if model ~= false
               control= experiment_2(model,syncro,energy_umbral);
               if control==false
                   exitLoop=true;
               elseif control==true
                   exitLoop=true;
               end
            else
                disp('No model selected...')
                pause(1)
                beep;
                clear option
            end
            
        case 3
               model  = selectModel();
            if model ~= false
               control= experiment_3(model,syncro,energy_umbral);
                if control==false
                    exitLoop=true;
                elseif control==true
                    exitLoop=true;
                end
            else
                disp('No model selected...')
                pause(1)
                beep;
                clear option
            end
            
        case 4
               model  = selectModel();
            if model ~= false
               control= experiment_4(model,syncro,energy_umbral);
                if control==false
                    exitLoop=true;
                elseif control==true
                    exitLoop=true;
                end
            else
                disp('No model selected...')
                pause(1)
                beep;
                clear option
            end
            
        case 5
            exitLoop=true;
            
        otherwise
            disp(' Please, select a valid option... ');
            pause(2)
    end
    
end

if control==true
    delete(pwd,'\','userData.mat')
    clc
    disp('Experiment has finished ... ')
end
clearvars -except usersLowIndex response
close all
