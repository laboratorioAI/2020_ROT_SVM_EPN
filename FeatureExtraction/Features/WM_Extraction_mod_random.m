function [emg_mod,i] = WM_Extraction_mod_random(user_,gestures_,electrode_ref,ventana,new_order,random_data)
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

 

 for i=1:1:10
     
     
     if electrode_ref==0
         
         if i<=25
             loc=gestureLocation.(user_).training.(gestures_){i,1};
             Matrix=userData.training{loc,1}.emg;
         else
             loc=gestureLocation.(user_).testing.(gestures_){i-25,1};
             Matrix=userData.testing{loc-150,1}.emg;
             
         end
     else
         
         if i<=10
             
             if i==1
             loc_=gestureLocation.(user_).training.(gestures_){i,1};
             assignin('base','loc_',loc_);
             end
             loc_  =  evalin('base', 'loc_');
             index_=loc_+random_data(i)-1;
             
             Matrix_=userData.training{index_,1}.emg;

         end
         

Matrix=Matrix_(:,new_order);
          
     end

   
   
   % ====================== Wmoos Default options =====================   
   
   check_size=size(Matrix);
   indicest_low=indices.(user_){index_,1};
   indicest_high=indices.(user_){index_,2};   

    if check_size(1,1)<=600        
        % ------------------------- EMG POINTS -------------------- [1000]        
        %
        %                              [600]
        %             ______________   |   
        %            |              |  |   
        %------------|              |X-|
        %            |______________|  |   
        %                              |       
        led=0;
    else
        led=1;
    end 
    
    if led==1
        %        _________|____                    |                   |
        %       |         |    |                   |                   |
        %------X|         |    |-------------------|-------------------|
        %       |_________|____|                   |                   |
        %                 |                        |                   |
        
        %                 |     ______________     |                   |
        %                 |    |              |    |                   |
        %-----------------|---X|              |----|-------------------|
        %                 |    |______________|    |                   |
        %                 |                        |                   |
        
        %                 |                        |          _________|_____    
        %                 |                        |         |         |     |   
        %-----------------|------------------------|--------X|         |     |
        %                 |                        |         |_________|_____|   
        %                 |                        |                   |    
        
        %                 |                        |  ______________   |   
        %                 |                        | |              |  |   
        %-----------------|------------------------|-|              |X-|
        %                 |                        | |______________|  |   
        %                 |                        |                   | 
        if indicest_low<=ventana
            low_  = indicest_low;
            high_ = indicest_low+ventana;
        end        
        if indicest_low>ventana && indicest_low<check_size(1,1)-ventana
            low_  = indicest_low;
            high_ = indicest_low+ventana;
        end      
        if indicest_low>=check_size(1,1)-ventana
            low_  = indicest_high-ventana;
            high_ = indicest_high;
        end               
    else
        low_  = indicest_high-ventana;
        high_ = indicest_high;
    end       
      emg_mod{1,i}=Matrix(low_:high_,:);
      
  % =====================================================================    
      
      
   
 end

end