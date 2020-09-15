% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function []= initBuffer(mean_)

for i=1: mean_
buffer_compact{1,i}='noGesture';
end

assignin('base','buffer_compact', buffer_compact);
assignin('base','emgCounterCompact', 1);

end
