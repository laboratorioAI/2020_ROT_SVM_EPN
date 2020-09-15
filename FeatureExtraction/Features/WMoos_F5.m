% WMoos Energy
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function Y = WMoos_F5(X)
matrix=X;
mat=size(matrix);
rows=mat(1,1);
columns=mat(1,2);
zeromat=zeros(rows,1);
z=0;
zz=0;
for j=1:rows
    for i=1:columns-1
         z= abs( matrix(j,i+1)*matrix(j,i+1)*( sign(matrix(j,i+1))) - matrix(j,i)*matrix(j,i)*sign(matrix(j,i)) ); 
         zz=zz+z;   
         zeromat(j)=zz/2;
    end
 zz=0; 
end
Y=zeromat;
end