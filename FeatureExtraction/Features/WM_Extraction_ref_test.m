function [emg,i] = WM_Extraction_ref_test(user_,gestures_,electrode_ref)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------


 userData  =  evalin('base', 'userData');
 indices   =  evalin('base', 'indices');
 gestureLocation  =  evalin('base', 'gestureLocation');
 ven=255;

start_at= 26;
end_at= 50;

 
for i=start_at:1:end_at
    
    
    if electrode_ref==0
        
        switch gestures_
            
            case 1
                
                if i<=25
                    loc=gestureLocation.(user_).training.waveOut{i,1};
                    
                    Matrix=userData.training{loc,1}.emg;
                    etiqueta=userData.training{loc,1}.gestureName
                    
                    if etiqueta ~="waveOut"
                        pause(10)
                    end
                else
                    
                    loc=gestureLocation.(user_).testing.waveOut{i-25,1};
                    Matrix=userData.testing{loc-150,1}.emg;
                    
                    etiqueta=userData.testing{loc-150,1}.gestureName;
                    if etiqueta ~="waveOut"
                        pause(10)
                        
                    end
                    
                end
            otherwise
        end
    end
    
    indicest_low=indices.(user_){loc,1};
    indicest_high=indices.(user_){loc,2};
    
    if i== start_at
        emg=Matrix(indicest_high-ven:indicest_high,:);
        emg_=emg;
    else
        emg=Matrix(indicest_high-ven:indicest_high,:);
        emg_=horzcat(emg_,emg);
        emg=emg_;
    end
end

end