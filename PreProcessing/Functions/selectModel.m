% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function modelSelected = selectModel()
clc
        disp(' Classification Models');
        disp(' [1] General');
        disp(' [2] Especific');
        disp(' [3] Exit');
        disp(' ');
        classifierOption=input('Select a model to run:  ');
        
        if classifierOption==1
            modelSelected  = 1;
        elseif classifierOption==2
            modelSelected  = 2;
        elseif classifierOption==3
            modelSelected  = false;
        else
            disp('Error selecting model ...');
            modelSelected  = false;
            pause(2)
            
        end
end

