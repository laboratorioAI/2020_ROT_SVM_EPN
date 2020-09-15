% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

%WMoos Welch
function [Y] = WMoos_F3(X)
xn=X';
tam=size(xn);
ventana=blackmanharris(tam(1,1));
noverlap=round(length(ventana)/4);
[psd1,~]=pwelch(xn,ventana,noverlap,1024,400);
Y1=psd1';
Y=400*(trapz(Y1,2));
end

