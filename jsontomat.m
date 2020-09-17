function [] = jsontomat()
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

clc
close all
warning off all;

%%
userFolder = 'training';
folderData = [userFolder 'JSON'];
filesInFolder = dir(folderData);
numFiles = length(filesInFolder);
userProcessed = 0;

for user_i = 1:numFiles
    
  if ~(strcmpi(filesInFolder(user_i).name, '.') || strcmpi(filesInFolder(user_i).name, '..') || strcmpi(filesInFolder(user_i).name, '.DS_Store'))

      
     userProcessed = userProcessed + 1;
     file = [folderData '/' filesInFolder(user_i).name '/' filesInFolder(user_i).name '.json'];
     userName=filesInFolder(user_i).name;
     text = fileread(file);
     user = jsondecode(text);
     userData = user;
     
     folder=[pwd,'\','TrainingData','\',userName];
     
     mkdir (folder)
     cd (folder)
     save('userData.mat','userData')
     
     
     userData.sync        = userData.synchronizationGesture;
     userData.training    = userData.trainingSamples;
     userData.testing     = userData.testingSamples;
     
     userData  = rmfield(userData,'synchronizationGesture');
     userData  = rmfield(userData,'trainingSamples');
     userData  = rmfield(userData,'testingSamples');
     userData  = rmfield(userData,'generalInfo');
     
     userData.userInfo.username = userData.userInfo.name;
     
     %% sync
     userData.sync     = struct2cell(userData.sync);
     aux               = length(fieldnames(userData.sync{1,1}));
    
     for o=1:aux
       
         index=char(strcat('idx_',string(o)));
         rx=userData.sync{1,1}.(index);         
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
        
         userData.sync_{o,1}.emg                = emg_;
         userData.sync_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.sync_{o,1}.pose_myo           = rx.myoDetection;
         userData.sync_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.sync_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];                                                       
     end
     
     userData.sync        = userData.sync_;
     userData  = rmfield(userData,'sync_');
     
     %% training

     userData.training = struct2cell(userData.training);
        
     for o=1:150       
         rx=userData.training{o,1};         
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
        
         userData.train_{o,1}.emg                = emg_;
         userData.train_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.train_{o,1}.pose_myo           = rx.myoDetection;
         userData.train_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.train_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];                                                       
         userData.train_{o,1}.gestureName        = categorical(string(rx.gestureName)); 
         
         if string(rx.gestureName)=="noGesture"         
         else
         userData.train_{o,1}.groundTruthIndex   = (rx.groundTruthIndex)'; 
         userData.train_{o,1}.groundTruth        = (logical(rx.groundTruth))'; 
         end         
     end   
      userData.training   = userData.train_;
      userData            = rmfield(userData,'train_');
     

     %% testing
     userData.testing  = struct2cell(userData.testing);
     
     for o=1:150
         rx=userData.testing{o,1};
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
         
         userData.test_{o,1}.emg                = emg_;
         userData.test_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.test_{o,1}.pose_myo           = rx.myoDetection;
         userData.test_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.test_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];
         userData.test_{o,1}.gestureName        = categorical(string(rx.gestureName));
         
         if string(rx.gestureName)=="noGesture"
         else
             userData.test_{o,1}.groundTruthIndex   = (rx.groundTruthIndex)';
             userData.test_{o,1}.groundTruth        = (logical(rx.groundTruth))';
         end
     end
      userData.testing   = userData.test_;
      userData           = rmfield(userData,'test_');

     save('userData.mat','userData')
     
     
     cd ../
     cd ../
     
  end
  

end

clearvars 


%% Testing Data Transformation
userFolder = 'testing';
folderData = [userFolder 'JSON'];
filesInFolder = dir(folderData);
numFiles = length(filesInFolder);
userProcessed = 0;

for user_i = 1:numFiles
    
  if ~(strcmpi(filesInFolder(user_i).name, '.') || strcmpi(filesInFolder(user_i).name, '..') || strcmpi(filesInFolder(user_i).name, '.DS_Store'))

      
     userProcessed = userProcessed + 1;
     file = [folderData '/' filesInFolder(user_i).name '/' filesInFolder(user_i).name '.json'];
     userName=filesInFolder(user_i).name;
     text = fileread(file);
     user = jsondecode(text);
     userData = user;
     
     folder=[pwd,'\','TestingData','\',userName];
     
     mkdir (folder)
     cd (folder)
     save('userData.mat','userData')
     
     
     userData.sync        = userData.synchronizationGesture;
     userData.training    = userData.trainingSamples;
     userData.testing     = userData.testingSamples;
     
     userData  = rmfield(userData,'synchronizationGesture');
     userData  = rmfield(userData,'trainingSamples');
     userData  = rmfield(userData,'testingSamples');
     userData  = rmfield(userData,'generalInfo');
     
     userData.userInfo.username = userData.userInfo.name;
     
     %% sync
     userData.sync     = struct2cell(userData.sync);
     aux               = length(fieldnames(userData.sync{1,1}));
    
     for o=1:aux
       
         index=char(strcat('idx_',string(o)));
         rx=userData.sync{1,1}.(index);         
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
        
         userData.sync_{o,1}.emg                = emg_;
         userData.sync_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.sync_{o,1}.pose_myo           = rx.myoDetection;
         userData.sync_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.sync_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];                                                       
     end
     
     userData.sync        = userData.sync_;
     userData  = rmfield(userData,'sync_');
     
     %% training

     userData.training = struct2cell(userData.training);
        
     for o=1:150       
         rx=userData.training{o,1};         
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
        
         userData.train_{o,1}.emg                = emg_;
         userData.train_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.train_{o,1}.pose_myo           = rx.myoDetection;
         userData.train_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.train_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];                                                       
         userData.train_{o,1}.gestureName        = categorical(string(rx.gestureName)); 
         
         if string(rx.gestureName)=="noGesture"         
         else
         userData.train_{o,1}.groundTruthIndex   = (rx.groundTruthIndex)'; 
         userData.train_{o,1}.groundTruth        = (logical(rx.groundTruth))'; 
         end         
     end   
      userData.training   = userData.train_;
      userData            = rmfield(userData,'train_');
     

     %% testing
     userData.testing  = struct2cell(userData.testing);
     
     for o=1:150
         rx=userData.testing{o,1};
         emg_=[rx.emg.ch1,rx.emg.ch2,rx.emg.ch3,rx.emg.ch4,rx.emg.ch5,rx.emg.ch6,rx.emg.ch7,rx.emg.ch8]/128;
         
         userData.test_{o,1}.emg                = emg_;
         userData.test_{o,1}.pointGestureBegins = rx.startPointforGestureExecution;
         userData.test_{o,1}.pose_myo           = rx.myoDetection;
         userData.test_{o,1}.gyro               = [rx.gyroscope.x,rx.gyroscope.y,rx.gyroscope.z];
         userData.test_{o,1}.accel              = [rx.accelerometer.x,rx.accelerometer.y,rx.accelerometer.z];

     end
      userData.testing   = userData.test_;
      userData           = rmfield(userData,'test_');

     save('userData.mat','userData')
     
     
     cd ../
     cd ../
     
  end
  

end

clearvars 


end

