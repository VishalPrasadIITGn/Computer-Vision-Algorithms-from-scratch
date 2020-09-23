function [kp_new2]=sobel_op(A,B)
%NOTE:REPLACE CONVOLUTION INBUILT
%A=imread('cameraman.tif');
%B=[5 5 10 55 34 38];
%B=keypoints_loc;
[r2 c2]=size(B);
Dx=[-1 -2 -1;0 0 0;1 2 1];
Dy=[-1 0 1;-2 0 2;-1 0 1];
% Dxpad=[0 0 0 0 0;0 -1 -2 -1 0;0 0 0 0 0;0 1 2 1 0;0 0 0 0 0];
% Dypad=[0 0 0 0 0;0 -1 0 1 0;0 -2 0 2 2;0 -1 0 1 0;0 0 0 0 0];
Dx2=[1 4 6 4 1;0 0 0 0 0;-2 -8 -12 -8 -2;0 0 0 0 0;1 4 6 4 1];
Dy2=[1 0 -2 0 1;4 0 -8 0 4;6 0 -12 0 6;4 0 -8 0 4;1 0 -2 0 1];
DxDy=[1 2 0 -2 -1;2 4 0 -4 -2;0 0 0 0 0;-2 -4 0 4 2;-1 -2 0 2 1];
DXX=conv2(A,Dx2);
DYY=conv2(A,Dx2);
DXY=conv2(A,DxDy);
% H=[DXX DXY;DXY DYY];
% TrH=DXX+DYY;
% DetH=DXX.*DYY-(DXY).^2;
kp_new=zeros(1,c2);
c=1;
for i=1:2:c2-1
    x=B(i);
    y=B(i+1);
    TrH=DXX(x,y)+DYY(x,y);
    DetH=DXX(x,y).*DYY(x,y)-(DXY(x,y)).^2;
    r=(((TrH).^2)/DetH);    
    if DetH>0 && r<12
        kp_new(1,c)=x;
        kp_new(1,c+1)=y;
        c=c+2;
    end
            
end
if c==1
    kp_new2=ones(1,2);
else
    for i=1:2:c-1
    kp_new2(1,i)=kp_new(1,i);
    kp_new2(1,i+1)=kp_new(1,i+1);
    end
end
end
