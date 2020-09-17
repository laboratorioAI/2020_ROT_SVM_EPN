
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------
% Absolute Envelope
function Y = WMoos_F2(X)

        envol=hilbert(X);
        out_partial=abs(envol);
        
        %% Filter  Savitzky-Golay 
         aux = sgolayfilt(out_partial,1,7);
         Y=trapz(aux,2);        
        

end

