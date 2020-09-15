% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function [emg_mod,i] = WM_Extraction_mod(user_,gestures_,electrode_ref,ventana,rotationMode)

userData  =  evalin('base', 'userData');
indices   =  evalin('base', 'indices');
gestureLocation  =  evalin('base', 'gestureLocation');

orientation     =   evalin('base','orientation');

energy_index = find(strcmp(orientation(:,1), user_));

v=1;
for i=1:1:50
    
    if electrode_ref==0
        
        if i<=25
            loc=gestureLocation.(user_).training.(gestures_){i,1};
            
            
            if rotationMode=="NR"                
             Matrix=userData.training{loc,1}.emg;    
            else
             Matrix=userData.training{loc,1}.emg(:,WM_X(orientation{energy_index,5})); 
            end
            
            
        else
            loc=gestureLocation.(user_).testing.(gestures_){i-25,1};
           
            
            
            if rotationMode=="NR"      
             Matrix=userData.testing{loc-150,1}.emg;
   
            else
             Matrix=userData.testing{loc-150,1}.emg(:,WM_X(orientation{energy_index,5})); 
            end
            
            
        end
        
    else
        if i<=25
            loc=gestureLocation.(user_).training.(gestures_){i,1};
            
            if rotationMode=="NR"
               
                Matrix_=userData.training{loc,1}.emg;
            else
                Matrix_=userData.training{loc,1}.emg(:,WM_X(orientation{energy_index,5}));
                
            end
            
            
        else
            loc=gestureLocation.(user_).testing.(gestures_){i-25,1};
            
            if rotationMode=="NR"
                
               Matrix_=userData.testing{loc-150,1}.emg; 
            else
               Matrix_=userData.testing{loc-150,1}.emg(:,WM_X(orientation{energy_index,5}));
                
            end
            
            

        end
        
        Matrix=Matrix_(:,WM_X(electrode_ref)); 
               
    end
    
    relax_add=zeros(400,8);
    Matrix=vertcat(Matrix,relax_add);
    
    % ====================== Wmoos Default options =====================
    
    check_size=size(Matrix);
    indicest_low=indices.(user_){loc,1};
    indicest_high=indices.(user_){loc,2};
    
    
    if check_size(1,1)<=600
        led=0;
    else
        led=1;
    end
    
    if led==1
        low_  = indicest_low;
        high_ = indicest_low+ventana;
    else
        low_  = indicest_high-ventana;
        high_ = indicest_high;
        pause(10)
    end
    
    step_=25;
    signals_per_gesture=7;
    
    for x=1:signals_per_gesture
        
        if gestures_~="noGesture"
            switch x
                case 1
                    emg_mod{1,v}=Matrix(low_:high_,:);
                case 2
                    emg_mod{1,v}=Matrix(low_+(1)*step_:high_+(1)*step_,:);
                case 3
                    emg_mod{1,v}=Matrix(low_+(2)*step_:high_+(2)*step_,:);
                case 4
                    emg_mod{1,v}=Matrix(low_+(3)*step_:high_+(3)*step_,:);
                
                case 5
                    if low_<76
                        emg_mod{1,v}=Matrix(low_+(1.5)*step_:high_+(1.5)*step_,:);
                    else
                        emg_mod{1,v}=Matrix(low_-(1)*step_:high_-(1)*step_,:);
                    end
                    
                case 6
                    if low_<76
                        emg_mod{1,v}=Matrix(low_+(2.5)*step_:high_+(2.5)*step_,:);
                    else
                        emg_mod{1,v}=Matrix(low_-(2)*step_:high_-(2)*step_,:);
                    end
                    
                case 7
                    if low_<76
                        emg_mod{1,v}=Matrix(low_+(3.5)*step_:high_+(3.5)*step_,:);
                    else
                        emg_mod{1,v}=Matrix(low_-(3)*step_:high_-(3)*step_,:);
                    end
                    
                    
                otherwise
            end
        else
            switch x
                case 1
                    emg_mod{1,v}=Matrix(low_:high_,:);
                case 2
                    emg_mod{1,v}=Matrix(low_+(1)*step_:high_+(1)*step_,:);
                case 3
                    emg_mod{1,v}=Matrix(low_+(2)*step_:high_+(2)*step_,:);
                case 4
                    emg_mod{1,v}=Matrix(low_+(3)*step_:high_+(3)*step_,:);
                case 5
                    emg_mod{1,v}=Matrix(low_+(4)*step_:high_+(4)*step_,:);
                case 6
                    emg_mod{1,v}=Matrix(low_+(5)*step_:high_+(5)*step_,:);
                case 7
                    emg_mod{1,v}=Matrix(low_+(6)*step_:high_+(6)*step_,:);
                    
                otherwise
            end
            
        end
        
        v=v+1;
    end
    
end
i=i*signals_per_gesture;

end