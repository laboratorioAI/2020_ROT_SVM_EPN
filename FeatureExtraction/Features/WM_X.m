% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function Y_org = WM_X(xyz)

X_org=zeros(1,7);
k_sync=1;
xyzDefault=1;

if xyz >8 || xyz<=0
    Sx=xyzDefault;
else
    Sx=xyz;
end

for y=1:(8-Sx)
    sx=mod(Sx+y,9);
    X_org(1,k_sync)=sx;
    k_sync=k_sync+1;
end

for y=0:(Sx-2)
    sx=mod(1+y,9);
    X_org(1,k_sync)=sx;
    k_sync=k_sync+1;
end
Y_org=[Sx X_org];
end

