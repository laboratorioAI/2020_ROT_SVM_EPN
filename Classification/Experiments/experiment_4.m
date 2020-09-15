function control = experiment_4(model,syncro,energy_umbral)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

if model==1
    modelSelected='general';
else
    modelSelected='specific';
end

assignin('base','modelSelected',modelSelected);

fprintf('Experiment selected :%d\n',4);
fprintf('Model selected      :%s\n',modelSelected);

if modelSelected=="general"
    dataPacket      = orderfields(dir('Data\General\Training'));
    pathOrigin      = 'Data\General\Training';
elseif modelSelected=="specific"
    dataPacket      = orderfields(dir('Data\Specific'));
    pathOrigin      = 'Data\Specific';
end

dataPacketSize  = length(dataPacket);
pathUser        = pwd;
userCounter     = 1;
% ================================ MAD & Energy ==================================
orientation  = cell(dataPacketSize-2,2);    
for k=1:dataPacketSize
    
    if ~(strcmpi(dataPacket(k).name, '.') || strcmpi(dataPacket(k).name, '..'))
        usuario     = dataPacket(k).name;
        userFolder  = horzcat(pathUser,'\',pathOrigin,'\',dataPacket(k).name,'\','userData.mat');
        load(userFolder);
        
        if syncro>0            
            for x=1:150
                gesto_=userData.training{x,1}.gestureName;
                if gesto_=="waveOut"
                    location_=x;
                    break;
                end
            end            
            elec_=zeros(1,syncro);
            aux=1;
            energy_order=zeros(syncro,8);            
            % =======================================================
            %                     WITH ROTATION
            % =======================================================
            for goto_=location_:location_+syncro-1    
                
                % =============================================================
                if goto_==location_
                    assignin('base','simulate_Rotation', simulateRotation);
                end
                simulate_Rotation       = evalin('base','simulate_Rotation');
                % ============================================================
                
                emgData             = userData.training{goto_,1}.emg(:,simulate_Rotation);
                Index_              = userData.training{goto_,1}.groundTruthIndex;
                Index_high_         = Index_(1,2);
                emgData             = emgData(Index_high_ - 255:Index_high_,:);
                energy_wm           = WMoos_F5(emgData');
                energy_order(aux,:) = energy_wm;
                [~,max_energy]      = max((energy_wm));
                elec_(1,aux)        = max_energy;
                aux = aux+1;
            end            
                ref_partial         = histcounts(elec_(1,:),1:(8+1));
                [~,ref]             = max(ref_partial);
                xyz                 = ref;           
        else            
                xyz                 = 1 ;         
        end        
        % ================== Umbral =========================

        calibration_umbral=zeros(8,syncro);
        for o=1:syncro
            waveout_pure=userData.sync{o,1}.emg(:,simulate_Rotation);
            umbral_envelope_wm=WMoos_F5(waveout_pure');
            calibration_umbral(:,o)=umbral_envelope_wm;
        end
        sequence_=WM_X(xyz);
        calibration_umbral=calibration_umbral';
        calibration_umbral=calibration_umbral(:,sequence_);       
        mean_umbral=calibration_umbral;
        mean_umbral=mean(mean_umbral,1);      
        val_umbral_high = energy_umbral*sum(mean_umbral(1:4))/4;
        val_umbral_low  = energy_umbral*sum(mean_umbral(5:8))/4;
        
        % ==================================================
        
        orientation{userCounter,1} = usuario; 
        orientation{userCounter,2} = xyz;    
        orientation{userCounter,3} = val_umbral_low; 
        orientation{userCounter,4} = val_umbral_high;   
        orientation{userCounter,5} = simulate_Rotation(:,1);
        userCounter = userCounter+1;              
    end
end
orientation_training=orientation;
assignin('base','orientation_training',orientation_training);
assignin('base','orientation',orientation);
% ================= Index & locations ================
[Location,indices,gestureLocation,low_bajo]=getIndex(modelSelected);
% ======================================================
  
low_bajo            = rmfield(low_bajo,'NaN');
low_bajoPacket      = fieldnames(low_bajo);

if length(fields(low_bajo)) >=1
    exitCheck=false;
else
    fprintf('All users can be used for training .... \n');
    pause(4)
    exitCheck=true;
end


if exitCheck==true
    
% ==================================================================================
% =========================    TRAINING MODELS    ==================================
% ==================================================================================

    if  modelSelected =="general"
    
        % ============================== GENERAL ====================================
        name_indices='indicesTodosExp4G.mat'; 
        save('indicesTodosExp4G.mat','Location','indices','gestureLocation')
        % ============================== Check sensor placement =====================
        [~,users_good_checked,~] = Wmoos_check_sensor_placement(name_indices,'R',syncro);
        assignin('base','users_good_checked',users_good_checked);    
        % ============================== Packing EMG Data ===========================
        fprintf('\nPacking all EMG Data ...\n');    
        ventana=180;
        [trainActivity,Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8]=Wmoos_data_union(ventana,name_indices,'C','R');
        trainActivity=trainActivity';
        CellEMGDataTrain= [Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8];
        assignin('base','trainActivity',trainActivity);
        assignin('base','CellEMGDataTrain',CellEMGDataTrain);
        % ============================== Featuring EMG Data =========================
        fprintf('\nFeaturing EMG Data ...\n');
        fprintf('Please wait ... \n'); 
        sEMGActivityData=Wmoos_features_selection_mod_5();
        clear CellEMGDataTrain Ms1 Ms2 Ms3 Ms4 Ms5 Ms6 Ms7 Ms8 
        % ================================= Training ================================
        fprintf('\nTraining General Model Exp4 ...\n');
        fprintf('Please wait ... \n'); 
        [trainedClassifier, ~] = trainClassifier(sEMGActivityData)
        assignin('base','trainedClassifier',trainedClassifier);
        
        beep
        pause(6)
        clc
        
        % ====================================
        % ======= READY TO TEST EXP 4 ========
        % ====================================

        % ==     ==     ==
        %  ==   ====   ==
        %   == ==  == ==
        %    ===    ===
    
    
    elseif modelSelected =="specific"  
        
        % ============================== SPECIFIC ===================================
        name_indices='indicesTodosExp4S.mat'; 
        save('indicesTodosExp4S.mat','Location','indices','gestureLocation')
        % ============================== Check sensor placement =====================
        [~,users_good_checked,~] = Wmoos_check_sensor_placement_training(name_indices,'R',syncro); 
        assignin('base','users_good_checked',users_good_checked);    
        % ============================== Packing EMG Data ===========================
        fprintf('\nPacking all EMG Data ...\n');    
        ventana=180;
        [trainActivity,Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8] = Wmoos_data_union_train(ventana,name_indices,'C','R');
        trainActivity=trainActivity';
        CellEMGDataTrain= [Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8];
        assignin('base','trainActivity',trainActivity);
        assignin('base','CellEMGDataTrain',CellEMGDataTrain);
        % ============================== Featuring EMG Data ===========================
        fprintf('\nFeaturing EMG Data ...\n');
        fprintf('Please wait ... \n'); 
        sEMGActivityData=Wmoos_features_selection_mod_5();
        clear CellEMGDataTrain Ms1 Ms2 Ms3 Ms4 Ms5 Ms6 Ms7 Ms8 
        fprintf('Please wait ... \n');
        % ========================= Packing Featured Data =============================
        step_=1050; 
        clc
        fprintf('\nPacking specific users featured data ...\n');
        fprintf('Please wait ... \n');
        for w=1:(size(users_good_checked))*[1;0]
            inf_=step_*(w-1)+1;
            sup_=w*step_;        
            sEMGActivityDataRandom{w,1}=users_good_checked(w,1);
            sEMGActivityDataRandom{w,2}=sEMGActivityData(inf_:sup_,:);
        end
        % ================================= Training ==================================
        aux=1;
        clc
        fprintf('\nTraining with each specific user data ...\n');
        fprintf('Please wait ... \n');
                
        for i=1:(size(sEMGActivityDataRandom))*[1;0]

            name=char(sEMGActivityDataRandom{i,1});            
            dataTable=sEMGActivityDataRandom{i,2};        
                     
                [classifierSVM,accuracySVM]=trainClassifierS(sEMGActivityDataRandom{i,2})                 
                fprintf('Actual train users is  : %s \n',name);
                accu{aux,1}=name;
                accu{aux,2}=accuracySVM;
                aux=aux+1;
                save('userData.mat','classifierSVM','dataTable','name')
                load('userData.mat')                
                if i==1
                folder=[pwd,'\','Data\Trained_Specific_Exp4','\',char(sEMGActivityDataRandom{i,1})];
                else
                folder=['Trained_Specific_Exp4','\',char(sEMGActivityDataRandom{i,1})];
                end
                mkdir (folder)
                cd (folder)
                save('userData.mat','classifierSVM','dataTable','name') 
                cd ../
                cd ../
                
        end
        assignin('base','accu', accu);
        delete(pwd,'\','userData.mat')
        clear i name val username_ aux userData
        clc
        cd ../      
        delete(pwd,'\','userData.mat')

        % ====================================
        % ======= READY TO TEST EXP 4 ========
        % ====================================
        
        % ==     ==     ==
        %  ==   ====   ==
        %   == ==  == ==
        %    ===    ===

    end

% ==================================================================================
% ==========================    TESTING MODELS    ==================================
% ==================================================================================


    if  modelSelected =="general"
        % ============================== GENERAL ====================================
        dataPacket      = orderfields(dir('Data\General\Testing'));     
        dataPacketSize  = length(dataPacket);
        pathUser        = pwd;
        pathOrigin      = 'Data\General\Testing';  
        
        assignin('base','dataPacket',     dataPacket);
        assignin('base','dataPacketSize', dataPacketSize);
        assignin('base','pathUser',       pathUser);
        assignin('base','pathOrigin',     pathOrigin);
            
        userCounter     = 1;
        % ================================ MAD & Energy ==================================
        orientation  = cell(dataPacketSize-2,2);
        
        for k=1:dataPacketSize
            
            if ~(strcmpi(dataPacket(k).name, '.') || strcmpi(dataPacket(k).name, '..'))
                usuario     = dataPacket(k).name;
                userFolder  = horzcat(pathUser,'\',pathOrigin,'\',dataPacket(k).name,'\','userData.mat');
                load(userFolder);
                
                if syncro>0
                    for x=1:150
                        gesto_=userData.training{x,1}.gestureName;
                        if gesto_=="waveOut"
                            location_=x;
                            break;
                        end
                    end
                    elec_=zeros(1,syncro);
                    aux=1;
                    energy_order=zeros(syncro,8);
                    
                    % =======================================================
                    %                     WITH ROTATION
                    % =======================================================
                    for goto_=location_:location_+syncro-1
                        
                        % =============================================================
                        if goto_==location_
                        assignin('base','simulate_Rotation', simulateRotation);
                        end                        
                        simulate_Rotation       = evalin('base','simulate_Rotation');
                        % ============================================================
                        
                        emgData             = userData.training{goto_,1}.emg(:,simulate_Rotation);
                        Index_              = userData.training{goto_,1}.groundTruthIndex;
                        Index_high_         = Index_(1,2);
                        emgData             = emgData(Index_high_ - 255:Index_high_,:);
                        energy_wm           = WMoos_F5(emgData');
                        energy_order(aux,:) = energy_wm;
                        [~,max_energy]      = max((energy_wm));
                        elec_(1,aux)        = max_energy;
                        aux = aux+1;
                    end
                    ref_partial         = histcounts(elec_(1,:),1:(8+1));      
                    [~,ref]             = max(ref_partial);                    
                    xyz                 = ref;                                 
                else
                    xyz_aux             = simulateRotation;
                    xyz                 = xyz_aux(:,1);
                                                                               
                                                           
                end
                % ================== Umbral =========================
                
                calibration_umbral=zeros(8,syncro);
                for o=1:syncro
                    waveout_pure=userData.sync{o,1}.emg(:,simulate_Rotation);
                    umbral_envelope_wm=WMoos_F5(waveout_pure');
                    calibration_umbral(:,o)=umbral_envelope_wm;
                end
                sequence_=WM_X(xyz);
                calibration_umbral=calibration_umbral';
                calibration_umbral=calibration_umbral(:,sequence_);
                mean_umbral=calibration_umbral;
                mean_umbral=mean(mean_umbral,1);
                val_umbral_high = energy_umbral*sum(mean_umbral(1:4))/4;
                val_umbral_low  = energy_umbral*sum(mean_umbral(5:8))/4;
                
                % ==================================================
                
                orientation{userCounter,1} = usuario;
                orientation{userCounter,2} = xyz;
                orientation{userCounter,3} = val_umbral_low;
                orientation{userCounter,4} = val_umbral_high;
                orientation{userCounter,5} = simulate_Rotation(:,1);
                userCounter = userCounter+1;
            end
        end
        assignin('base','orientation',orientation);

       
        % ============================ Initialization =============================
  
        userIndex       = 1;            % Start reading from first user
        emgRepetition   = 151;          % Start getting the first gesture repetition
        stepControl     = 1;            % Set the first windows index(steps) to 1
        responseIndex   = 1;            % First response goes to the location 1
        responseBuffer  = 'noGesture';  % First gesture located the buffer is "noGesture"

        start_at        = emgRepetition;

        assignin('base','userIndex',     userIndex);
        assignin('base','emgRepetition', emgRepetition);
        assignin('base','stepControl',   stepControl);
        assignin('base','responseIndex', responseIndex);
        assignin('base','responseBuffer',responseBuffer);
        
        assignin('base','low_umbral', 0);
        assignin('base','high_umbral',0);
        assignin('base','matrix',0);
        
        % Buffers
        
        conditionBuffer       = false;
        conditionBuffer_one   = false;
        conditionBuffer_two   = false;
        
        responseBuffer      = 'noGesture';  % First  buffer gesture located the buffer is "noGesture"
        responseBuffer_one  = 'noGesture';  % Second  buffer gesture located the buffer is "noGesture"
        responseBuffer_two  = 'noGesture';  % Third  buffer gesture located the buffer is "noGesture"
        
        assignin('base','conditionBuffer',     conditionBuffer);
        assignin('base','conditionBuffer_one', conditionBuffer_one);
        assignin('base','conditionBuffer_two', conditionBuffer_two);
        
        assignin('base','responseBuffer',     responseBuffer);
        assignin('base','responseBuffer_one', responseBuffer_one);
        assignin('base','responseBuffer_two', responseBuffer_two);
        assignin('base','counter_target', 0);
             
        % Creatting variable "response" to locate all responses
        
        response.NaN.class{1,1}{1,1}                  = "NaN";
        response.NaN.vectorOfLabels{1,1}{1,1}         = "NaN";
        response.NaN.vectorOfTimePoints{1,1}{1,1}     = 0;
        response.NaN.vectorOfProcessingTime{1,1}{1,1} = 0;
        assignin('base','response',response);
        
        % Variables to select classifier model sequence 
        assignin('base','sequence_mad', true); 
        
        % Postprocessing variables
        
        for i=1:4
            buffer_compact{1,i}='noGesture';
        end
        
        assignin('base','buffer_compact', buffer_compact);
        assignin('base','emgCounterCompact', 1);
        
        TargetPrediction{1,1}='noGesture';
        assignin('base','TargetPrediction', TargetPrediction);
        TargetPredictionHorzcat{1,1}='';
        assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);
        
        % ======================================================================= 
  
        testControl=true;
        assignin('base','testControl', testControl);
        
        while testControl==true
            
                emgDataTested           = OfflineDataExp4G(1,20,"on");
                emgFeatured             = getFeatures(emgDataTested);
                emgTarget               = getClassification(emgFeatured,"offline");
                emgTargetPostprocessed  = getTargetPostprocessed(emgTarget,"offline");

                controlExit       = evalin('base','controlExit');
                usuario           = evalin('base','usuario');
                emgRepetition     = evalin('base','emgRepetition');


            if controlExit==false && usuario~="NaN"

                TargetPrediction   = evalin('base', 'TargetPrediction');
                responseIndex      = evalin('base', 'responseIndex');
                [TargetPrediction_actual,TargetPrediction_fixed]=emgCompacted(emgTargetPostprocessed,4);
                TargetPrediction{1,responseIndex-1} = TargetPrediction_actual;
                assignin('base','TargetPrediction', TargetPrediction);
                emgCounterCompact  =  evalin('base', 'emgCounterCompact');
                check_compact      = emgCounterCompact-1;

                if check_compact==0
                    TargetPrediction_fixed_up  =  TargetPrediction_fixed;
                    TargetPredictionHorzcat    =  evalin('base', 'TargetPredictionHorzcat');
                    TargetPredictionHorzcat    = horzcat(TargetPredictionHorzcat,TargetPrediction_fixed_up);
                    assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);
                end

            elseif controlExit==true && usuario~="NaN"        
                TargetPrediction=evalin('base', 'TargetPrediction');
                usuario          =  evalin('base','usuario');
                response         =  evalin('base','response');

                resp=summaryClass(TargetPrediction);
                response.(usuario).classNew{emgRepetition-1,1}=resp;
                TargetPrediction{1,1}='noGesture';
                assignin('base','TargetPrediction', TargetPrediction);

                TargetPredictionHorzcat  =  evalin('base', 'TargetPredictionHorzcat');
                TargetPredictionHorzcat  =  TargetPredictionHorzcat(1,2:end);
                TargetPredictionUnion= emgCompactedTotal(TargetPredictionHorzcat,length (TargetPredictionHorzcat));

                resp2=summaryClass(TargetPredictionUnion)
                response.(usuario).classNew2{emgRepetition-1,1}=resp2;

                response.(usuario).vectorOfLabelsNew{emgRepetition-1,1}=TargetPredictionUnion;
                clear TargetPredictionHorzcat
                TargetPredictionHorzcat{1,1}='';
                assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);
                assignin('base','response',response);
            end

            testControl   = evalin('base','testControl');
        end
        
        
        response        =  evalin('base','response');
        orientation     =  evalin('base','orientation');
        
        clearvars -except usersLowIndex response orientation start_at
   
        for i=1:size(orientation)*([1;0]) 
            if i == 1
            response                                          = rmfield(response,'NaN');
            end 
            response.(char(orientation(i,1))).vectorOfLabels  = response.(char(orientation(i,1))).vectorOfLabelsNew;
            response.(char(orientation(i,1))).class           = response.(char(orientation(i,1))).classNew2;
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'vectorOfLabelsNew');
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'classNew');
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'classNew2');  
        end
        
        assignin('base','response',response);
        fileName='responseExp4G.mat';
        save(fileName,'response');       
        zero_analysis = start_at-150;
        WM_conversion_newFormat(fileName,zero_analysis)
        exitCheck=true;
        delete(pwd,'\','indicesTodosExp4G.mat')
        
        check_point=true;  
                
        % ====================================
        % ======  TEST EXP 4 HAS DONE ========
        % ====================================

        % ==     ==     ==
        %  ==   ====   ==
        %   == ==  == ==
        %    ===    ===
        
    elseif modelSelected =="specific"

        % ============================== SPECIFIC ===================================

        dataPacket      = orderfields(dir('Data\Specific'));     
        dataPacketSize  = length(dataPacket);
        pathUser        = pwd;
        pathOrigin      = 'Data\Specific';  
        
        assignin('base','dataPacket',     dataPacket);
        assignin('base','dataPacketSize', dataPacketSize);
        assignin('base','pathUser',       pathUser);
        assignin('base','pathOrigin',     pathOrigin);
            
        userCounter     = 1;
        % ================================ MAD & Energy ==================================
        orientation  = cell(dataPacketSize-2,2);
        for k=1:dataPacketSize
            
            if ~(strcmpi(dataPacket(k).name, '.') || strcmpi(dataPacket(k).name, '..'))
                usuario     = dataPacket(k).name;
                userFolder  = horzcat(pathUser,'\',pathOrigin,'\',dataPacket(k).name,'\','userData.mat');
                load(userFolder);
                
                if syncro>0
                    for x=1:150
                        gesto_=userData.training{x,1}.gestureName;
                        if gesto_=="waveOut"
                            location_=x;
                            break;
                        end
                    end
                    elec_=zeros(1,syncro);
                    aux=1;
                    energy_order=zeros(syncro,8);
                    % =======================================================
                    %                     WITH ROTATION
                    % =======================================================                    
                    for goto_=location_:location_+syncro-1
                        
                        % =============================================================
                        if goto_==location_
                            assignin('base','simulate_Rotation', simulateRotation);
                        end
                        simulate_Rotation       = evalin('base','simulate_Rotation');
                        % ============================================================                        
                        
                        emgData             = userData.training{goto_,1}.emg(:,simulate_Rotation);
                        Index_              = userData.training{goto_,1}.groundTruthIndex;
                        Index_high_         = Index_(1,2);
                        emgData             = emgData(Index_high_ - 255:Index_high_,:);
                        energy_wm           = WMoos_F5(emgData');
                        energy_order(aux,:) = energy_wm;
                        [~,max_energy]      = max((energy_wm));
                        elec_(1,aux)        = max_energy;
                        aux = aux+1;
                    end
                    ref_partial         = histcounts(elec_(1,:),1:(8+1));
                    [~,ref]             = max(ref_partial);
                    xyz                 = ref;
                else
                    xyz_aux             = simulateRotation;
                    xyz                 = xyz_aux(:,1);
                end
                % ================== Umbral =========================
                
                calibration_umbral=zeros(8,syncro);
                for o=1:syncro
                    waveout_pure=userData.sync{o,1}.emg(:,simulate_Rotation);
                    umbral_envelope_wm=WMoos_F5(waveout_pure');
                    calibration_umbral(:,o)=umbral_envelope_wm;
                end
                sequence_=WM_X(xyz);
                calibration_umbral=calibration_umbral';
                calibration_umbral=calibration_umbral(:,sequence_);
                mean_umbral=calibration_umbral;
                mean_umbral=mean(mean_umbral,1);
                val_umbral_high = energy_umbral*sum(mean_umbral(1:4))/4;
                val_umbral_low  = energy_umbral*sum(mean_umbral(5:8))/4;
                
                % ==================================================
                
                orientation{userCounter,1} = usuario;
                orientation{userCounter,2} = xyz;
                orientation{userCounter,3} = val_umbral_low;
                orientation{userCounter,4} = val_umbral_high;
                orientation{userCounter,5} = simulate_Rotation(:,1);
                userCounter = userCounter+1;
            end
        end
        assignin('base','orientation',orientation);
        
        check_point=true;
              
        % ============================ Initialization =============================
  
        userIndex       = 1;            % Start reading from first user
        emgRepetition   = 151;          % Start getting the 151 th gesture repetition
        stepControl     = 1;            % Set the first windows index(steps) to 1
        responseIndex   = 1;            % First response goes to the location 1
        responseBuffer  = 'noGesture';  % First gesture located the buffer is "noGesture"
        
        start_at        = emgRepetition;
        
        assignin('base','userIndex',     userIndex);
        assignin('base','emgRepetition', emgRepetition);
        assignin('base','stepControl',   stepControl);
        assignin('base','responseIndex', responseIndex);
        assignin('base','responseBuffer',responseBuffer);
        
        assignin('base','low_umbral', 0);
        assignin('base','high_umbral',0);
        assignin('base','matrix',0);
        
        % Buffers
        
        conditionBuffer       = false;
        conditionBuffer_one   = false;
        conditionBuffer_two   = false;
        
        responseBuffer      = 'noGesture';  % First  buffer gesture located the buffer is "noGesture"
        responseBuffer_one  = 'noGesture';  % Second  buffer gesture located the buffer is "noGesture"
        responseBuffer_two  = 'noGesture';  % Third  buffer gesture located the buffer is "noGesture"
        
        assignin('base','conditionBuffer',     conditionBuffer);
        assignin('base','conditionBuffer_one', conditionBuffer_one);
        assignin('base','conditionBuffer_two', conditionBuffer_two);
        
        assignin('base','responseBuffer',     responseBuffer);
        assignin('base','responseBuffer_one', responseBuffer_one);
        assignin('base','responseBuffer_two', responseBuffer_two);
        assignin('base','counter_target', 0);
             
        % Creatting variable "response" to locate all responses
        
        response.NaN.class{1,1}{1,1}                  = "NaN";
        response.NaN.vectorOfLabels{1,1}{1,1}         = "NaN";
        response.NaN.vectorOfTimePoints{1,1}{1,1}     = 0;
        response.NaN.vectorOfProcessingTime{1,1}{1,1} = 0;
        assignin('base','response',response);
        
        % Variables to select classifier model sequence 
        assignin('base','sequence_mad', true);  
        
        % Variable to select user classifier  
        assignin('base','change_user',    false);
        
        % Postprocessing variables
        
        for i=1:4
            buffer_compact{1,i}='noGesture';
        end
        
        assignin('base','buffer_compact', buffer_compact);
        assignin('base','emgCounterCompact', 1);
        
        TargetPrediction{1,1}='noGesture';
        assignin('base','TargetPrediction', TargetPrediction);
        TargetPredictionHorzcat{1,1}='';
        assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);
        
        % =======================================================================
 
        addpath('Data\Trained_Specific_Exp4');
        
        
        dataPacket_aux      = orderfields(dir('Data\Trained_Specific_Exp4'));
        pathOrigin_aux      = 'Data\Trained_Specific_Exp4';
        pathUser_aux        = pwd;
        userFolder  = horzcat(pathUser_aux,'\',pathOrigin_aux,'\',dataPacket_aux(3).name,'\','userData.mat');
        Model=load(userFolder) ;
        trainedClassifier=Model.classifierSVM;        
        assignin('base','trainedClassifier', trainedClassifier);
        
        index_user  = 1;
        testControl = true;
        assignin('base','testControl', testControl);
        
        while testControl==true

            change_user = evalin('base', 'change_user');
            userIndex   = evalin('base', 'userIndex');  
            
            if userIndex>=3 && change_user==false
                clear classifierSVM dataTable name accuracySVM
                
                if index_user > dataPacketSize-2
                    usuario           = orientation{index_user-1,1};  
                else
                    usuario           = orientation{index_user,1};   
                end 
                
                folder_main       = 'Data\Trained_Specific_Exp4';
                folder_user       = char(usuario);
                folder_dir        = [pwd,'\',folder_main,'\',folder_user,'\userData.mat'];
                Model             = load(folder_dir) ;
                trainedClassifier = Model.classifierSVM;
                assignin('base','trainedClassifier', trainedClassifier);
                index_user        = index_user+1;
                assignin('base','change_user',true);
                
            end

                emgDataTested           = OfflineDataExp4S(1,20,"on");
                emgFeatured             = getFeatures(emgDataTested);
                emgTarget               = getClassification(emgFeatured,"offline");
                emgTargetPostprocessed  = getTargetPostprocessed(emgTarget,"offline");

                controlExit       = evalin('base','controlExit');
                usuario           = evalin('base','usuario');
                emgRepetition     = evalin('base','emgRepetition');
             

            if controlExit==false && usuario~="NaN"

                TargetPrediction      = evalin('base', 'TargetPrediction');
                responseIndex         = evalin('base', 'responseIndex');
                [TargetPrediction_actual,TargetPrediction_fixed]=emgCompacted(emgTargetPostprocessed,4);
                TargetPrediction{1,responseIndex-1}=TargetPrediction_actual;
                assignin('base','TargetPrediction', TargetPrediction);
                emgCounterCompact     = evalin('base', 'emgCounterCompact');
                check_compact         = emgCounterCompact-1;

                if check_compact==0
                    TargetPrediction_fixed_up  = TargetPrediction_fixed;
                    TargetPredictionHorzcat    = evalin('base', 'TargetPredictionHorzcat');
                    TargetPredictionHorzcat    = horzcat(TargetPredictionHorzcat,TargetPrediction_fixed_up);
                    assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);

                end

            elseif controlExit==true && usuario~="NaN"        
                TargetPrediction=evalin('base', 'TargetPrediction');
                usuario          =  evalin('base','usuario');
                response         =  evalin('base','response');

                resp=summaryClass(TargetPrediction);
                response.(usuario).classNew{emgRepetition-1,1}=resp;
                TargetPrediction{1,1}='noGesture';
                assignin('base','TargetPrediction', TargetPrediction);

                TargetPredictionHorzcat  =  evalin('base', 'TargetPredictionHorzcat');
                TargetPredictionHorzcat  =  TargetPredictionHorzcat(1,2:end);
                TargetPredictionUnion= emgCompactedTotal(TargetPredictionHorzcat,length (TargetPredictionHorzcat));

                resp2=summaryClass(TargetPredictionUnion)
                response.(usuario).classNew2{emgRepetition-1,1}=resp2;

                response.(usuario).vectorOfLabelsNew{emgRepetition-1,1}=TargetPredictionUnion;
                clear TargetPredictionHorzcat
                TargetPredictionHorzcat{1,1}='';
                assignin('base','TargetPredictionHorzcat', TargetPredictionHorzcat);
                assignin('base','response',response);
            end

           testControl    = evalin('base','testControl');
        end
        
        
        response        =  evalin('base','response');
        orientation     =  evalin('base','orientation');
        
        clearvars -except usersLowIndex response orientation start_at
   
        for i=1:size(orientation)*([1;0]) 
            if i == 1
            response                                          = rmfield(response,'NaN');
            end 
            response.(char(orientation(i,1))).vectorOfLabels  = response.(char(orientation(i,1))).vectorOfLabelsNew;
            response.(char(orientation(i,1))).class           = response.(char(orientation(i,1))).classNew2;
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'vectorOfLabelsNew');
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'classNew');
            response.(char(orientation(i,1)))                 = rmfield(response.(char(orientation(i,1))),'classNew2');  
        end
        
        assignin('base','response',response);
        
        fileName='responseExp4S.mat';        
        save( fileName,'response');        
        zero_analysis = start_at-150;
        WM_conversion_newFormat(fileName,zero_analysis)
        exitCheck=true;
        delete(pwd,'\','indicesTodosExp4S.mat')        
        check_point=true;   
      
        % ====================================
        % ======  TEST EXP 4 HAS DONE ========
        % ====================================

        % ==     ==     ==
        %  ==   ====   ==
        %   == ==  == ==
        %    ===    ===
    end

else 
    for i=1:length(fields(low_bajo))
    fprintf('User error due to training steps: %s \n',char(low_bajoPacket(i,1)));
    end 
    assignin('base','usersLowIndex',low_bajo);
    beep
    pause(1)
    beep
    pause(1)
    fprintf('Please check those users...\n');
end
control=exitCheck;

end

