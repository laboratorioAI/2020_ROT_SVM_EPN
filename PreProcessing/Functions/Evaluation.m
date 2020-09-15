function [] = Evaluation(directory,responseValues,type)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

DataDir=[pwd,'\',directory];
addpath(pwd,'\','Postprocessing\libs');
addpath(DataDir);

dataPacket      = orderfields(dir(DataDir));
dataPacketSize  = length(dataPacket);
pathUser        = pwd;
pathOrigin      = directory;

assignin('base','dataPacket',    dataPacket);
assignin('base','dataPacketSize',dataPacketSize);
assignin('base','pathUser',      pathUser);
assignin('base','pathOrigin',    pathOrigin);

response_  = load([pwd,'\',responseValues]);
response   = response_.response;

control=true;


if type=="training"
    names_responses=fields(response.training);
    field = 'training';
elseif type=="testing"
    names_responses=fields(response.testing);
    field = 'testing';
else
    disp('Error, no valid name...')
    control=false;
end

summary=zeros(125*4,2);
aux=1;
if control==true
    try
        for k=1:dataPacketSize
            
            if ~(strcmpi(dataPacket(k).name, '.') || strcmpi(dataPacket(k).name, '..'))
                usuario     = dataPacket(k).name;
                userFolder  = horzcat(pathUser,'\',pathOrigin,'\',dataPacket(k).name,'\','userData.mat');
                load(userFolder);
                
                for u=1:length(names_responses)
                    
                    if string(names_responses(u,1)) == string(usuario)
                        
                        user_=char(names_responses(u,1));
                        
                        for i=26:150
                            clc
                            usuario
                            pause(0.1)
                            
                            groundTruth                       = userData.testing{i,1}.groundTruth;
                            repOrgInfo.gestureName            = categorical(userData.(field){i,1}.gestureName);
                            repOrgInfo.groundTruth            = groundTruth;
                            
                            response_.class                   = response.(field).(user_).class{i,1};
                            response_.vectorOfLabels          = response.(field).(user_).vectorOfLabels{i,1};
                            response_.vectorOfTimePoints      = response.(field).(user_).vectorOfTimePoints{i,1};
                            response_.vectorOfProcessingTimes = response.(field).(user_).vectorOfProcessingTime{i,1};
                            
                            r1 = evalRecognition(repOrgInfo,response_)
                            
                            %=========================================
                            
                            % Your code here!  
                            
                            if r1.classResult==true
                                
                                summary(aux,1)=1;
                            else
                                summary(aux,1)=0;
                            end
                            
                            if r1.recogResult==true
                                summary(aux,2)=1;
                            else
                                summary(aux,2)=0;
                            end
                            
                            %=========================================                            
                            aux=aux+1;
                        end
                        
                    end
                    
                end
                
            end
            
        end        
    catch 
        fprintf('No data to evaluate in folder: %s\n',field);
    end   
end

classification = sum(summary(:,1))/length(summary)
recognition    = sum(summary(:,2))/length(summary)


end

