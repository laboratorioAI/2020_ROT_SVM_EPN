function [emg_mod,emg,i] = WM_Extraction(gestures_,electrode_ref,l,ventana)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

 userData  =  evalin('base', 'userData');
 indicest_ =  evalin('base', 'indicest_');
 
 switch gestures_
            
            case 1
                rep_gestures_ = userData.gestures.waveOut.data;
            case 2
                rep_gestures_ = userData.gestures.waveIn.data;
            case 3
                rep_gestures_ = userData.gestures.fist.data;
            case 4
                rep_gestures_ = userData.gestures.fingersSpread.data;
            case 5
                rep_gestures_ = userData.gestures.doubleTap.data;
            case 6      
                rep_gestures_ = userData.gestures.relax.data;
            otherwise               
 end 
tam_gestures_=size(rep_gestures_);
rep_times=tam_gestures_(1,1);
 

 for i=1:1:rep_times
    
    if electrode_ref==0 
        
        switch gestures_
            
            case 1
                Matrix = userData.gestures.waveOut.data{i,1}.emg;
            case 2
                Matrix = userData.gestures.waveIn.data{i,1}.emg;
            case 3
                Matrix = userData.gestures.fist.data{i,1}.emg;
            case 4
                Matrix = userData.gestures.fingersSpread.data{i,1}.emg;
            case 5
                Matrix = userData.gestures.doubleTap.data{i,1}.emg;
            case 6      
                Matrix = userData.gestures.relax.data{i,1}.emg;
            otherwise               
        end
        
    else
     
       
        switch gestures_
            
            case 1
                Matrix_ = userData.gestures.waveOut.data{i,1}.emg;
            case 2
                Matrix_ = userData.gestures.waveIn.data{i,1}.emg;
            case 3
                Matrix_ = userData.gestures.fist.data{i,1}.emg;
            case 4
                Matrix_ = userData.gestures.fingersSpread.data{i,1}.emg;
            case 5
                Matrix_ = userData.gestures.doubleTap.data{i,1}.emg;
            case 6
                Matrix_ = userData.gestures.relax.data{i,1}.emg;
            otherwise
        end
        
        switch electrode_ref
            
            case 1
                Matrix=Matrix_(:,[1,2,3,4,5,6,7,8]);
            case 2
                Matrix=Matrix_(:,[2,3,4,5,6,7,8,1]);
            case 3
                Matrix=Matrix_(:,[3,4,5,6,7,8,1,2]);
            case 4
                Matrix=Matrix_(:,[4,5,6,7,8,1,2,3]);
            case 5
                Matrix=Matrix_(:,[5,6,7,8,1,2,3,4]);
            case 6
                Matrix=Matrix_(:,[6,7,8,1,2,3,4,5]);
            case 7
                Matrix=Matrix_(:,[7,8,1,2,3,4,5,6]);
            case 8
                Matrix=Matrix_(:,[8,1,2,3,4,5,6,7]);
            otherwise
        end
          
    end
 
    range=size(Matrix);    
    
    if range(1,1)<=600
        led=0;
    else
        led=1;
    end 
    
    if led==1
        
        if indicest_(i,l)<=ventana
            lim=indicest_(i,l);
            corte=(lim:lim+ventana);
        end
        
        if indicest_(i,l)>ventana && indicest_(i,l)<range(1,1)-ventana
            lim=indicest_(i,l);
            corte=(lim:lim+ventana);
        end
        
    
        if indicest_(i,l)>=range(1,1)-ventana
            lim=indicest_(i,l+1);
            corte=(lim-ventana:lim);           
        end
        
        
    else
            lim=indicest_(i,l+1);
            corte=(lim-ventana:lim);
    end
    

    if i==1
        emg=Matrix(corte,:);
        emg_=emg;
    else

        emg=Matrix(corte,:);
        emg_=horzcat(emg_,emg);
        emg=emg_;
    end
    
    

 end

end