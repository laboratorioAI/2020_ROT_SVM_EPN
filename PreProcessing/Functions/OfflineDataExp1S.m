% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function emgDataTested = OfflineDataExp1S(timeWindow,stepWindow,correctionMode)

dataPacket      =   evalin('base','dataPacket');
dataPacketSize	=   evalin('base','dataPacketSize');
pathUser        =   evalin('base','pathUser');
pathOrigin      =   evalin('base','pathOrigin');

userIndex       =   evalin('base','userIndex');
emgRepetition   =   evalin('base','emgRepetition');
stepControl     =   evalin('base','stepControl');

orientation     =   evalin('base','orientation');

% ==============================================================================
% Step control manages every window step over the EMG signal
%
if stepControl == 1
    
    startWave  = 1;              % First start window point to analize
    endWave    = timeWindow*200; % First end window point to analize
    
    assignin('base','startWave', startWave);
    assignin('base','endWave',   endWave);
    
else
    startWave       =   evalin('base', 'startWave');
    endWave         =   evalin('base', 'endWave');
    startWave       =   startWave + stepWindow;   % Next start window point to analize
    endWave         =   endWave   + stepWindow;   % Next end window point to analize
    
    
    assignin('base','startWave',startWave);
    assignin('base','endWave',  endWave);
end
% ==============================================================================


if userIndex~=dataPacketSize+1
    
    if ~(strcmpi(dataPacket(userIndex).name, '.') || strcmpi(dataPacket(userIndex).name, '..'))
        
        usuario=dataPacket(userIndex).name;
        assignin('base','usuario',usuario);
        
        energy_index = find(strcmp(orientation(:,1), usuario));
        
        assignin('base','low_umbral', orientation{energy_index,3});
        assignin('base','high_umbral',orientation{energy_index,4});
        

        recognitionTestUserData=(horzcat(pathUser,'\',pathOrigin,'\',dataPacket(userIndex).name,'\','userData.mat'));
        load(recognitionTestUserData);
        
        repTraining    = length(userData.training);
        repTesting     = length(userData.testing);
        fields         = fieldnames(userData);
        
        % =================================================================
        % This csection verifies if orientationCorrection is ON or OFF
        %
        if correctionMode=="off"
            order        = 1;
        else
            
        end
        
        sequence_mad  = evalin('base','sequence_mad');
        
        if sequence_mad==true
            sequence_=WM_X(order);
        else
            
        end
        
        % ================================================================
        
        if emgRepetition <= repTraining + repTesting
            
            % =================================================================
            % This code loads EMG signal fron taining or testing folder
            %
            if emgRepetition <=repTraining
                emgData        = userData.training{emgRepetition,1}.emg(:,sequence_);
                fromfield      = fields{5,1};
                field_ground   = fieldnames(userData.(fromfield){emgRepetition,1});
            else
                emgData        = userData.testing{emgRepetition-repTraining,1}.emg(:,sequence_);
                fromfield      = fields{6,1};
                field_ground   = fieldnames(userData.(fromfield){emgRepetition-repTraining,1});
            end
            
            % =================================================================
            
            
            % =================================================================
            % This code sets "start" and  "end" index for every window step
            %
            if endWave >= length(emgData)
                endWave     = length(emgData);
                startWave   = endWave-timeWindow*200;
                controlExit = true;
            else
                controlExit = false;
            end
            assignin('base','controlExit',controlExit);
            % ================================================================
            
            % ================================================================
            
            groundTruthLocation  = find(field_ground=="groundTruth");
            gestureNameLocation  = find(field_ground=="gestureName");
            if isempty(groundTruthLocation)
                groundTruth_      = zeros(1,length(emgData));
            else
                if fromfield =="training"
                    groundTruth_      = userData.(fromfield){emgRepetition,1}.groundTruth;
                else
                    groundTruth_      = userData.(fromfield){emgRepetition-repTraining,1}.groundTruth;
                end
            end
            assignin('base','groundTruth_',groundTruth_);
            % ===============================================================
            
            emgDataTested=emgData(startWave:endWave,:);
            
            timeAnalized   = (endWave-(timeWindow*200));
            timeAnalized   = cast(timeAnalized,'double');
            timeAnalized   = timeAnalized/200;
            timeAnalized   = timeAnalized+((timeWindow)*(3/5));
            assignin('base','timeAnalized',timeAnalized);
            
            % =================================================
            % This code plots the RAW EMG and the groundTruth
            %
%             figure(1);
%             subplot(2,1,1);
%             plot(emgData)
%             xlim([0 length(emgData)])
%             ylim([-2 2])
%             grid on
%             
%             subplot(2,1,1)
%             rect = findall(gcf,'Type', 'rectangle');
%             delete(rect);
%             rectangle('Position',[startWave -1  round(timeWindow*200) 2],'EdgeColor','r')
%             
%             subplot(2,1,2);
%             plot(groundTruth_)
%             xlim([0 length(emgData)])
%             ylim([-0.5 2])
%             grid on
            % =====================================================
            
            
            % =====================================================================================
            % This code shows the information
            %
            clc
            disp('                Pseudo Online Test             ')
            disp('                Classifier testing              ')
            fprintf('User number = %d / %d\n',userIndex-2,dataPacketSize-2);
            fprintf('User name = %s\n',usuario);
            fprintf('User channel = %d\n',order);
            fprintf('Current gesture repetition = %d / %d \n',emgRepetition,repTraining+repTesting);
            fprintf('Current window = %d \n',stepControl);
            fprintf('Data from field = %s \n',fromfield);
            
            if fromfield=="training"
                fprintf('Real Training Target is = %s \n',userData.training{emgRepetition,1}.gestureName);
            
            elseif fromfield=="testing"
                
                if isempty(gestureNameLocation)
                    fprintf('Real Testing Target is unknown \n');
                else
                    fprintf('Real Testing Target is = %s \n',userData.testing{emgRepetition-repTraining,1}.gestureName);
                end
                
            end
            pause(0.01)
            % ==========================================================================================
            
            
            % ==================================================================
            % This section checks the end index of the signal and increases
            % the next emg gestures register to be loaded
            %
            if controlExit==true
                % This code runs when end windows index goes to the last value
                % Window over end limit
                % |-------------|      |    |
                %
                assignin('base','stepControl',1);
                
                % =====================================================================
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
                
                
            else
                % This code runs when end windows index does not go to the last value
                % Window end limit is not over
                % |--------|          |
                %
                assignin('base','stepControl',stepControl+1);
            end
            % ==================================================================
            
        else
            assignin('base','userIndex',userIndex+1);
            assignin('base','emgRepetition',151);
            assignin('base','controlExit',false);
            assignin('base','usuario','NaN');
            assignin('base','change_user',false);
            
            emgDataTested=zeros(10,8);
        end
        
    else
        
        assignin('base','userIndex',userIndex+1);
        assignin('base','usuario',"NaN");
        assignin('base','controlExit',false);
        emgDataTested=zeros(10,8);
        disp('Waiting folder....')
    end
else
    
    assignin('base','testControl',false);
    emgDataTested=zeros(10,8);
    
end

end

