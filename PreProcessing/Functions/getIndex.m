% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function  [Location,indices,gestureLocation,low_bajo] = getIndex(modelSelected)

low_bajo.NaN{1,1} =  0;

if modelSelected=="general"
    dataPacket      = orderfields(dir('Data\General\Training'));
    pathOrigin      = 'Data\General\Training';
elseif modelSelected=="specific"
    dataPacket      = orderfields(dir('Data\Specific'));
    pathOrigin      = 'Data\Specific';
end

dataPacketSize  = length(dataPacket);
pathUser        = pwd;

low_limit_segmentation = 0;
start_  = 1;
end_    = 6;

for k=1:dataPacketSize
    
    if ~(strcmpi(dataPacket(k).name, '.') || strcmpi(dataPacket(k).name, '..'))
        usuario = dataPacket(k).name;
        recognition_test_userData=horzcat(pathUser,'\',pathOrigin,'\',dataPacket(k).name,'\','userData.mat');
        load(recognition_test_userData);
        
        if modelSelected=="general"
            repTraining  = length(userData.training);
            repTesting   = length(userData.testing);

        elseif modelSelected=="specific"
            repTraining  = length(userData.training);
            repTesting   = 0;
        end
        
         fields       = fieldnames(userData);        
        
         for auxIndex=1:(repTraining+repTesting)
             
             if auxIndex<=repTraining
                 
                 fromfield=fields{5,1};
                 gesture=userData.(fromfield){auxIndex,1}.gestureName;
                 if gesture == "noGesture"
                     lowIndex= 1;
                     hightIndex= 1000;
                 else
                     lowIndex   = userData.training{auxIndex,1}.groundTruthIndex(1);
                     hightIndex = userData.training{auxIndex,1}.groundTruthIndex(2);
                     
                     if lowIndex < low_limit_segmentation 
                         low_bajo.(usuario){auxIndex,1} =  lowIndex;
                     end
                 end
                 
             else
                 
                 fromfield=fields{6,1};
                 gesture=userData.(fromfield){auxIndex-repTraining,1}.gestureName;
                 if gesture == "noGesture"
                     lowIndex   = 1;
                     hightIndex = 1000;
                 else
                     lowIndex   = userData.testing{auxIndex-repTraining,1}.groundTruthIndex(1);
                     hightIndex = userData.testing{auxIndex-repTraining,1}.groundTruthIndex(2);
                     
                     if lowIndex < low_limit_segmentation
                         low_bajo.(usuario){auxIndex,1} =  lowIndex;
                     end
                 end
                 
             end
             indices.(usuario){auxIndex,1} =  lowIndex;
             indices.(usuario){auxIndex,2} =  hightIndex;
             indices.(usuario){auxIndex,3} =  char(gesture);
             indices.(usuario){auxIndex,4} =  char(fromfield);
         end
        
        waveOut_   = find(indices.(usuario)(:,3)=="waveOut");
        
        for m=1:length(waveOut_)            
            if waveOut_(m)<=repTraining
                gestureLocation.(usuario).training.waveOut{m,1} =  waveOut_(m);
            else
                gestureLocation.(usuario).testing.waveOut{m-((length(waveOut_))/2),1} =  waveOut_(m);
            end            
        end
        
        waveIn_    = find(indices.(usuario)(:,3)=="waveIn");
        for m=1:length(waveIn_)            
            if waveIn_(m)<=repTraining
                gestureLocation.(usuario).training.waveIn{m,1} =  waveIn_(m);
            else
                gestureLocation.(usuario).testing.waveIn{m-((length(waveIn_))/2),1} =  waveIn_(m);
            end            
        end
       
        fist_     = find(indices.(usuario)(:,3)=="fist");
        for m=1:length(fist_)            
            if fist_(m)<=repTraining
                gestureLocation.(usuario).training.fist{m,1} =  fist_(m);
            else
                gestureLocation.(usuario).testing.fist{m-((length(fist_))/2),1} =  fist_(m);
            end            
        end
        
        open_     = find(indices.(usuario)(:,3)=="open");
        for m=1:length(open_)
            if open_(m)<=repTraining
                gestureLocation.(usuario).training.open{m,1} =  open_(m);
            else
                gestureLocation.(usuario).testing.open{m-((length(open_))/2),1} =  open_(m);
            end
        end
         
        pinch_    = find(indices.(usuario)(:,3)=="pinch");
        for m=1:length(pinch_)
            if pinch_(m)<=repTraining
                gestureLocation.(usuario).training.pinch{m,1} =  pinch_(m);
            else
                gestureLocation.(usuario).testing.pinch{m-((length(pinch_))/2),1} =  pinch_(m);
            end
        end
        
        noGesture_ = find(indices.(usuario)(:,3)=="noGesture");
        for m=1:length(noGesture_)
            if noGesture_(m)<=repTraining
                gestureLocation.(usuario).training.noGesture{m,1} =  noGesture_(m);
            else
                gestureLocation.(usuario).testing.noGesture{m-((length(noGesture_))/2),1} =  noGesture_(m);
            end
        end    
        Location(:,start_:end_)=[waveOut_ waveIn_ fist_ open_ pinch_ noGesture_];
        start_=end_+1;
        end_=end_+6;
           
    end
end

end

