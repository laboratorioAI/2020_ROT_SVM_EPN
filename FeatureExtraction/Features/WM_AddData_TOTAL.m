function [] = WM_AddData_TOTAL()
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

Ms1  =  evalin('base', 'MS1');
Ms2  =  evalin('base', 'MS2');
Ms3  =  evalin('base', 'MS3');
Ms4  =  evalin('base', 'MS4');
Ms5  =  evalin('base', 'MS5');
Ms6  =  evalin('base', 'MS6');
Ms7  =  evalin('base', 'MS7');
Ms8  =  evalin('base', 'MS8');

assignin('base','Ms1',Ms1);
assignin('base','Ms2',Ms2);
assignin('base','Ms3',Ms3);
assignin('base','Ms4',Ms4);
assignin('base','Ms5',Ms5);
assignin('base','Ms6',Ms6);
assignin('base','Ms7',Ms7);
assignin('base','Ms8',Ms8);

end
