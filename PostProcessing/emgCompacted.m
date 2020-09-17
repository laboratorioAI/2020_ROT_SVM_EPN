% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [TargetFixed,buffer_compact_fixed] = emgCompacted(emgTargetPostprocessed,mean_)



emgCounterCompact  =  evalin('base', 'emgCounterCompact');
buffer_compact  =  evalin('base', 'buffer_compact');

if emgCounterCompact==mean_
    
    
    buffer_compact{1,emgCounterCompact}=emgTargetPostprocessed;
    assignin('base','emgCounterCompact', 1);
    
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
        else
           if val_vector>=2 
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
            assignin('base','buffer_compact_fixed', buffer_compact_fixed);
            control=0;
            
            for k=1:mean_
                buffer_compact_fixed  =  evalin('base', 'buffer_compact_fixed');
                
                if aux_logical(k)==0 && control==0
                    buffer_compact_fixed{1,k}='noGesture';
                    assignin('base','buffer_compact_fixed', buffer_compact_fixed);
                else
                    control=1;
                    buffer_compact_fixed{1,k}=TargetFixed;
                    assignin('base','buffer_compact_fixed', buffer_compact_fixed);
                end
                
            end
           else
               TargetFixed='noGesture';
               
               for i=1: mean_
                   buffer_compact_fixed{1,i}='noGesture';
               end
           end
        end
        
        initBuffer(mean_);
        
    
else
    
    buffer_compact{1,emgCounterCompact}=emgTargetPostprocessed;
    TargetFixed='noGesture';
    assignin('base','emgCounterCompact', emgCounterCompact+1);
    assignin('base','buffer_compact', buffer_compact);
    buffer_compact_fixed='noGesture';
    
end





end