function [size_matrix] = WM_AddData()
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

MS1  =  evalin('base', 'Ms1');
MS2  =  evalin('base', 'Ms2');
MS3  =  evalin('base', 'Ms3');
MS4  =  evalin('base', 'Ms4');
MS5  =  evalin('base', 'Ms5');
MS6  =  evalin('base', 'Ms6');
MS7  =  evalin('base', 'Ms7');
MS8  =  evalin('base', 'Ms8');

assignin('base','MS1',MS1);
assignin('base','MS2',MS2);
assignin('base','MS3',MS3);
assignin('base','MS4',MS4);
assignin('base','MS5',MS5);
assignin('base','MS6',MS6);
assignin('base','MS7',MS7);
assignin('base','MS8',MS8);
size_matrix=size(MS1);
end

