% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function train_index = random_train()
control=true;

while control==true
    
    train_index = randi([1 25],1,10);
    train_index=unique(train_index);
    last_=size(train_index);
    last_=last_(1,2);
    
    if last_<10
        control=true;
    else
        control=false;
    end
        
end
train_index=sort(train_index);

end

