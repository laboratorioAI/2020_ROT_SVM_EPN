function [Ms1,Ms2,Ms3,Ms4,Ms5,Ms6,Ms7,Ms8] = extract_mod(emg,i)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------


    for j=1:i
                
        data=emg{1,j};
        emg_data=data';

        s1=emg_data(1,:);
        s2=emg_data(2,:);
        s3=emg_data(3,:);
        s4=emg_data(4,:);
        s5=emg_data(5,:);
        s6=emg_data(6,:);
        s7=emg_data(7,:);
        s8=emg_data(8,:);

        Ms1{j,:}=s1;
        Ms2{j,:}=s2;
        Ms3{j,:}=s3;
        Ms4{j,:}=s4;
        Ms5{j,:}=s5;
        Ms6{j,:}=s6;
        Ms7{j,:}=s7;
        Ms8{j,:}=s8;
    end

    
assignin('base','Ms1',Ms1);
assignin('base','Ms2',Ms2);
assignin('base','Ms3',Ms3);
assignin('base','Ms4',Ms4);
assignin('base','Ms5',Ms5);
assignin('base','Ms6',Ms6);
assignin('base','Ms7',Ms7);
assignin('base','Ms8',Ms8);

end

