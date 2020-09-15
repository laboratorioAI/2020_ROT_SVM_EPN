function [emg,i] = WM_(user_,gestures_,electrode_ref,rotation_Mode)

userData  =  evalin('base', 'userData');
indices   =  evalin('base', 'indices');
gestureLocation  =  evalin('base', 'gestureLocation');
ven=255; start_at= 1; end_at= 25;

orientation     =   evalin('base','orientation');

energy_index = find(strcmp(orientation(:,1), user_));


end