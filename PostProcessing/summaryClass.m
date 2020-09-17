% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function TargetFixed = summaryClass(buffer_compact)


idwaveOut = strfind(buffer_compact, 'waveOut');
idwaveOut = find(not(cellfun('isempty', idwaveOut)));
waveOut_  = length(idwaveOut);

idwaveIn  = strfind(buffer_compact, 'waveIn');
idwaveIn  = find(not(cellfun('isempty', idwaveIn)));
waveIn_   = length(idwaveIn);

idfist    = strfind(buffer_compact, 'fist');
idfist    = find(not(cellfun('isempty', idfist)));
fist_     = length(idfist);

idopen    = strfind(buffer_compact, 'open');
idopen    = find(not(cellfun('isempty', idopen)));
open_     = length(idopen);

idpinch   = strfind(buffer_compact, 'pinch');
idpinch   = find(not(cellfun('isempty', idpinch)));
pinch_    = length(idpinch);

vector      = [waveOut_ waveIn_ fist_ open_ pinch_ ];
checkVector = max(vector);



if checkVector==0
    TargetFixed='noGesture';
else
    
    [~,pos]=max(vector);
    switch pos
        
        case 1
            TargetFixed='waveOut';
        case 2
            TargetFixed='waveIn';
        case 3
            TargetFixed='fist';
        case 4
            TargetFixed='open';
        case 5
            TargetFixed='pinch';
            
    end
    
end
end

