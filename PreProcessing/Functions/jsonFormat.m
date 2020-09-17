function [] = jsonFormat(fileName,jsonName)

clc
load(fileName)
version = 'testing';
userList = fieldnames(response.(version));
userNum = size(userList,1);

for i = 1:userNum
    
    for j =  0:149
        sample = sprintf('idx_%d',j);
        
       results.(version).(userList{i}).class.(sample)                  = response.(version).(userList{i}).class{j+1,1} ;
       results.(version).(userList{i}).vectorOfLabels.(sample)         = response.(version).(userList{i}).vectorOfLabels{j+1,1} ;
       results.(version).(userList{i}).vectorOfTimePoints.(sample)     = response.(version).(userList{i}).vectorOfTimePoints{j+1,1} ;
       results.(version).(userList{i}).vectorOfProcessingTime.(sample) = response.(version).(userList{i}).vectorOfProcessingTime{j+1,1};
        
           
    end
    
end


txt = jsonencode(results);
fid = fopen(jsonName, 'wt');
fprintf(fid,txt);
fclose(fid);


end

