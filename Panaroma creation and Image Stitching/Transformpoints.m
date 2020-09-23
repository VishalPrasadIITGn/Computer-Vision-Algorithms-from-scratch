%this function transforms co-ordinates based on homography matrix
function [Tx,Ty]=Transformpoints(A,H)
temp1=ones(length(A),3);
temp1(:,1)=A(:,1);
temp1(:,2)=A(:,2);
for i=1:length(A)
    Tx1=H(1,1:3)*temp1(i,1:3)';
    Ty1=H(2,1:3)*temp1(i,1:3)';
    Tw1=H(3,1:3)*temp1(i,1:3)';
    x=Tx1./Tw1;
    y=Ty1./Tw1;
    tx(i,1)=x;
    ty(i,1)=y;
end
Tx=tx;
Ty=ty;
end