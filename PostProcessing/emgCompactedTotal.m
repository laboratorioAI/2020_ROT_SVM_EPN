% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [buffer_compact_fixed] = emgCompactedTotal(emgTargetPostprocessed,mean_)

buffer_compact=emgTargetPostprocessed;

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
[val_vector,checkVector] = max(vector);



if checkVector==0
    
    TargetFixed='noGesture';
        for i=1: mean_
            buffer_compact_fixed{1,i}=TargetFixed;
        end
    
else
    
    if val_vector>=4
        
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
        
        idfixed   = strfind(buffer_compact, TargetFixed);
        idempty    = find((cellfun('isempty', idfixed)));
        index_zero    = length(idempty);
        
        for j=1:index_zero
            k=idempty(j);
            idfixed{1,k}=0;
        end
        aux_fixed=cell2mat(idfixed);
        aux_logical=(aux_fixed>0);
        
        buffer_compact_fixed={};
        
       
        
        [~,location_]=find(aux_logical>0);
        min_=min(location_);
        max_=max(location_);
        
        
        for k=min_:max_
            
            aux_logical(k)=1;
            
            
        end
        
        for k=1:mean_
            
            if aux_logical(k)==1
                buffer_compact_fixed{1,k}=TargetFixed;
            else
                buffer_compact_fixed{1,k}='noGesture';
            end
            
        end
        

        
    else
        TargetFixed='noGesture';
        
        for i=1: mean_
            buffer_compact_fixed{1,i}='noGesture';
        end
    end
    
end



end