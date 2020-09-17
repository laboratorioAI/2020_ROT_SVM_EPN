function responses = read_jsonresponses(file)

text = fileread(file);
results = jsondecode(text);

userVersion = fieldnames(results);
userList = fieldnames(results.(userVersion{1,1}));
userNum = size(userList,1);


for i = 1:userNum
    
    for j =  0:149
        sample = sprintf('idx_%d',j);
        responses.(userVersion{1,1}).(userList{i}).class{j+1,1} = categorical(cellstr(results.(userVersion{1,1}).(userList{i}).class.(sample)));
        responses.(userVersion{1,1}).(userList{i}).vectorOfLabels{j+1,1} = categorical(cellstr(results.(userVersion{1,1}).(userList{i}).vectorOfLabels.(sample))');
        responses.(userVersion{1,1}).(userList{i}).vectorOfTimePoints{j+1,1} = results.(userVersion{1,1}).(userList{i}).vectorOfTimePoints.(sample)';
        responses.(userVersion{1,1}).(userList{i}).vectorOfProcessingTime{j+1,1} = results.(userVersion{1,1}).(userList{i}).vectorOfProcessingTime.(sample)';
    end
    
end



end

