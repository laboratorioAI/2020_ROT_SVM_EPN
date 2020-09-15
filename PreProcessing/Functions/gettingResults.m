% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [] = gettingResults(fileName)

        response        =  evalin('base','response');
        orientation     =  evalin('base','orientation');
        
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
        
        save(fileName,'response');
        start_at=151;
        zero_analysis = start_at-150;
        WM_conversion_newFormat(fileName,zero_analysis)
        
        
end

