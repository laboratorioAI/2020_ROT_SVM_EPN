function emgTargeted = getClassification(emgTableFeatures,sourceData)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------


check_umbral       =  evalin('base','check_umbral');
ClassifierModel    =  evalin('base','trainedClassifier');

if sourceData =="online" 
    
    if check_umbral=="noClassificationNeeded"
        emgTargeted ='noGesture';
    else
        Predicted = ClassifierModel.predictFcn(emgTableFeatures);
        emgTargeted=char(Predicted);        
    end
    

else
     if check_umbral=="noClassificationNeeded"
         emgTargeted ='noGesture';
         
         time_features  =  evalin('base','timeFeaturing'); 
         assignin('base','timeRecognition',time_features); 
     else
         tic         
         [Predicted, Scores]= ClassifierModel.predictFcn(emgTableFeatures);         
         emgTargeted=char(Predicted);
         timeRecognition=toc;
         
         % ================= nuevo  con " probabilidad " =================
         aux_scores      =   abs(Scores);
         aux_scores_max  =   max(aux_scores);
         aux_scores      =   aux_scores/aux_scores_max;
         prob_scores     =   1-aux_scores;
         [prob_,gest_pos]=   max(prob_scores);         
        
         if prob_>=0.90  
          
         switch gest_pos
             case 1
                 emgTargeted ='waveOut';
             case 2
                 emgTargeted ='waveIn';
             case 3
                 emgTargeted ='fist';
             case 4
                 emgTargeted ='open';
             case 5
                 emgTargeted ='pinch';
             case 6
                 emgTargeted ='noGesture';         
         end         
        else            
         emgTargeted ='noGesture';               
        end
        fprintf(' P >= 90  %s \n',emgTargeted);

         time_features  =  evalin('base','timeFeaturing');       
         assignin('base','timeRecognition',timeRecognition+time_features); 
                
     end

end

end

