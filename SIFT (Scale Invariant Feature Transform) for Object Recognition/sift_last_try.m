clc
clear all
close all
%INCLUDED FUNCTIONS
%KEYPOINTS FOR 2, KEYPOINTS FOR 4, SOBEL OP,magtheta33,sift desc2
%basic stuff---------------------
I=imread('cameraman.tif');
%I=rgb2gray(I1);
[r1 c1]=size(I);
%imshow(I);
I=double(I);
orig_img=I;

%parameters------------------------
    Ipad=padarray(I,[5 5],'both');
    sigma0=sqrt(2);
    a=sqrt(2);
    sigma=sigma0;
    
    val=[];
    oct1=[];
    
    %octave 1-------------------------------
     for k=0:4
        %making gaussian--------------------------
            sig=sigma0.*((a)^k);
            for x=-5:5
                for y=-5:5
                    gfk(x+6,y+6)=(1/((2*pi).*(sig.^2))).*(exp(((-(x.^2+y.^2))./(2.*(sig).^2))));
                end
            end
            gfk2(:,:)=double(gfk(:,:));
            gfk2(:,:)=gfk(:,:)./sum(sum(gfk(:,:)));%normalizing gaussian
        %---------------------------------------
            %sum(sum(gfk2));
        %convolution----------------------------
            
            for i=1:r1
                for j=1:c1
                    window=Ipad(i:i+10,j:j+10);
                    window=double(window);
                    temp=window.*gfk2;
                    res(i,j,k+1)=sum(sum(temp));
                end
            end
    
        
        val=[val res(:,:,k+1)];%storing result of all convolutd image.
       
        %------------------------------------------
        
        %finding difference of images----------------
        
            if k>0
                fin_res(:,:,k+1)=(res(:,:,k)-res(:,:,k+1)); %final diff image matrix octave 1
                oct1=[oct1 res(:,:,k+1)];%storing values of all final result(diff image) of octave 1
            end
         %-------------------------------------------
        %imshow(uint8(res))
     end
    %---------------xxxxxxxoctave1 finishedxxxxxxxxx----------------------------

GI11= res(:,:,1);%gaussian convoluted image 1
GI12= res(:,:,2);%gaussian convoluted image 2
GI13= res(:,:,3);%gaussian convoluted image 3
GI14= res(:,:,4);%gaussian convoluted image 4
GI15= res(:,:,5);%gaussian convoluted image 4
    
I11=fin_res(:,:,2);%1st difference image octave 1
I12=fin_res(:,:,3);%2nd difference image octave 2
I13=fin_res(:,:,4);%3rd difference image octave 3
I14=fin_res(:,:,5);%4th difference image octave 4
f=uint8(GI12);

imshow(uint8(GI11));

%finding keypoints----------------------------------
keypoints=[];
keypoints_loc=[];
    

    %keypoints in I11-----------------------------------
         
    keypts11=keypoints_for_2(I11,I12);
    valid_keyp11=sobel_op(I11,keypts11);%keypoints found, validity not checked
    [m11,t11,u11,v11]=magtheta33(GI11,valid_keyp11,sqrt(2));  %checking validity
    [D11,d11]=sift_des2(GI11,valid_keyp11,sqrt(2));
    %keyspoints in I11 found---------------------------
    %NOTE: D11 give 16x8 descriptors.
    %NOTE2: d11 gives concatebated vectors of 128 dimensions each
    
    %keypoints in I12-----------------------------------

    keypts12=keypoints_for_4(I11,I12,I13);
    valid_keyp12=sobel_op(I12,keypts12);
    [m12,t12,u12,v12]=magtheta33(GI12,valid_keyp12,2);
    [D12,d12]=sift_des2(GI12,valid_keyp12,2);
    %keypoints in I12found-----------------------------

    %finding keypoints in I13--------------------------
   
    keypts13=keypoints_for_4(I12,I13,I14);
    valid_keyp13=sobel_op(I13,keypts13);
    [m13,t13,u13,v13]=magtheta33(GI13,valid_keyp13,sqrt(2)*2);
    [D13,d13]=sift_des2(GI13,valid_keyp13,sqrt(2)*2);
    %keyspoints in I13 found---------------------------
    
    %keypoints in I14----------------------------------
    
    keypts14=keypoints_for_2(I14,I13);
    valid_keyp14=sobel_op(I14,keypts14);
    [m14,t14,u14,v14]=magtheta33(GI14,valid_keyp14,4);
    [D14,d14]=sift_des2(GI14,valid_keyp14,4);
    %keypoints in I14 found-----------------------------
    valid_keypoints_loc=[];
    valid_keypoints_loc=[valid_keyp11 valid_keyp12 valid_keyp13 valid_keyp14];
%     u1=[u11 u12 u13 u14];
%     v1=[v11 v12 v13 v14];
%     k=uint8(I);
% imshow(k);
% hold on
% h=1; 
% for i=1:2:(length(valid_keypoints_loc)-1)
%          x(h)=valid_keypoints_loc(1,i);
%          y(h)=valid_keypoints_loc(1,i+1);
%          %viscircles([u v],3);
%          h=h+1;
%  end
%  quiver(x,y,u1,v1,4)
%  hold off

%--------------------------------------------

% k=uint8(I);
% imshow(k);
% hold on
%  for i=1:2:(length(valid_keypoints_loc)-1)
%          u=valid_keypoints_loc(1,i);
%          v=valid_keypoints_loc(1,i+1);
%          viscircles([u v],3);
%  end
% hold off
%figure,   
   %=====================1st ictave finished completely===================%
        
%parameters------------------------
    I2=orig_img(1:2:r1,1:2:c1);
    [r2 c2]=size(I2);

%imshow(I);
I2=double(I2);
orig_img=I2;

%parameters------------------------
    Ipad2=padarray(I2,[5 5],'both');
    sigma02=2*sqrt(2);
    a=sqrt(2);
    sigma=sigma02;
    
    %store1=[];
    %store2=[];
    %store3=[];
    oct2=[];
    
    %octave 1-------------------------------
     for k2=0:4
        %making gaussian--------------------------
            sig=sigma02.*((a)^k2);
            for x=-5:5
                for y=-5:5
                    gfk22(x+6,y+6)=(1/((2*pi).*(sig.^2))).*(exp(((-(x.^2+y.^2))./(2.*(sig).^2))));
                end
            end
            gfk23(:,:)=double(gfk22(:,:));
            gfk23(:,:)=gfk22(:,:)./sum(sum(gfk22(:,:)));%normalizing gaussian
        %---------------------------------------
            %sum(sum(gfk2));
        %convolution----------------------------
            
            for i=1:r2
                for j=1:c2
                    window=Ipad2(i:i+10,j:j+10);
                    window=double(window);
                    temp=window.*gfk23;
                    res2(i,j,k2+1)=sum(sum(temp));
                end
            end
    
        
        %store2=[store2 res2(:,:,k2+1)];%storing result of all convolutd image.
       
        %------------------------------------------
        
        %finding difference of images----------------
        
            if k2>0
                fin_res2(:,:,k2+1)=(res2(:,:,k2)-res2(:,:,k2+1)); %final diff image matrix octave 1
                oct2=[oct2 res2(:,:,k2+1)];%storing values of all final result(diff image) of octave 1
            end
         %-------------------------------------------
        %imshow(uint8(res))
     end
    %---------------xxxxxxxoctave1 finishedxxxxxxxxx----------------------------

GI21= res2(:,:,1);%gaussian convoluted image 1
GI22= res2(:,:,2);%gaussian convoluted image 2
GI23= res2(:,:,3);%gaussian convoluted image 3
GI24= res2(:,:,4);%gaussian convoluted image 4
GI25= res2(:,:,5);%gaussian convoluted image 4
    
I21=fin_res2(:,:,2);%1st difference inage octave 1
I22=fin_res2(:,:,3);%2nd difference inage octave 1
I23=fin_res2(:,:,4);%3rd difference inage octave 1
I24=fin_res2(:,:,5);%4th difference inage octave 1
f=uint8(GI22);

imshow(uint8(GI21));

%finding keypoints----------------------------------
keypoints2=[];
keypoints_loc2=[];
    

    %keypoints in I21-----------------------------------
         
    keypts21=keypoints_for_2(I21,I22);
    valid_keyp21=sobel_op(I21,keypts21);%keypoints found, validity not checked
    [m21,t21,u21,v21]=magtheta33(GI21,valid_keyp21,2*sqrt(2));  %checking validity
    [D21,d21]=sift_des2(GI21,valid_keyp21,2*sqrt(2));
    %keyspoints in I21 found---------------------------
    
    
    %keypoints in I22-----------------------------------

    keypts22=keypoints_for_4(I21,I22,I23);
    valid_keyp22=sobel_op(I22,keypts22);
    [m22,t22,u22,v22]=magtheta33(GI22,valid_keyp22,4);
    [D22,d22]=sift_des2(GI22,valid_keyp22,4);
    %keypoints in I22found-----------------------------

    %finding keypoints in I23--------------------------
   
    keypts23=keypoints_for_4(I22,I23,I24);
    valid_keyp23=sobel_op(I23,keypts23);
    [m23,t23,u23,v23]=magtheta33(GI23,valid_keyp23,4*sqrt(2));
    [D23,d23]=sift_des2(GI23,valid_keyp23,4*sqrt(2));
    %keyspoints in I23 found---------------------------
    
    %keypoints in I24----------------------------------
    
    keypts24=keypoints_for_2(I24,I23);
    valid_keyp24=sobel_op(I24,keypts24);
    [m24,t24,u24,v24]=magtheta33(GI24,valid_keyp24,8);
    [D24,d24]=sift_des2(GI24,valid_keyp24,8);
    %keypoints in I24 found-----------------------------
    
    valid_keypoints_loc2=[];
    valid_keypoints_loc2=[valid_keyp21 valid_keyp22 valid_keyp23 valid_keyp24];

    for i=1:length(valid_keypoints_loc2)
    scaled_valid_keypoint_loc2(1,i)=((4.*valid_keypoints_loc2(1,i))-1);
    end
% k2=uint8(I2);
% imshow(k2);
% hold on
%  for i=1:2:(length(scaled_valid_keypoint_loc2)-1)
%          u2=scaled_valid_keypoint_loc2(1,i);
%          v2=scaled_valid_keypoint_loc2(1,i+1);
%          viscircles([u2 v2],6,'color','blue');
%  end
% hold off
%figure,   
   %=====================2nd octave finished completely===================%
   I3=I2(1:2:r2,1:2:c2);
   [r3 c3]=size(I3);
%imshow(I);
I3=double(I3);
orig_img3=I3;

%parameters------------------------
    Ipad3=padarray(I3,[5 5],'both');
    sigma03=4*sqrt(2);
    a=sqrt(2);
    sigma=sigma03;
    
    %store1=[];
    %store2=[];
    %store3=[];
    oct3=[];
    
    %octave 1-------------------------------
     for k3=0:4
        %making gaussian--------------------------
            sig=sigma03.*((a)^k3);
            for x=-5:5
                
                for y=-5:5
                    gfk31(x+6,y+6)=(1/((2*pi).*(sig.^2))).*(exp(((-(x.^2+y.^2))./(2.*(sig).^2))));
                end
            end
            gfk33(:,:)=double(gfk31(:,:));
            gfk33(:,:)=gfk31(:,:)./sum(sum(gfk31(:,:)));%normalizing gaussian
        %---------------------------------------
            %sum(sum(gfk2));
        %convolution----------------------------
            
            for i=1:r3
                for j=1:c3
                    window=Ipad3(i:i+10,j:j+10);
                    window=double(window);
                    temp=window.*gfk33;
                    res3(i,j,k3+1)=sum(sum(temp));
                end
            end
    
        
        %store3=[store3 res3(:,:,k3+1)];%storing result of all convolutd image.
       
        %------------------------------------------
        
        %finding difference of images----------------
        
            if k3>0
                fin_res3(:,:,k3+1)=(res3(:,:,k3)-res3(:,:,k3+1)); %final diff image matrix octave 1
                oct3=[oct3 res3(:,:,k3+1)];%storing values of all final result(diff image) of octave 1
            end
         %-------------------------------------------
        %imshow(uint8(res))
     end
    %---------------xxxxxxxoctave1 finishedxxxxxxxxx----------------------------

GI31= res3(:,:,1);%gaussian convoluted image 1
GI32= res3(:,:,2);%gaussian convoluted image 2
GI33= res3(:,:,3);%gaussian convoluted image 3
GI34= res3(:,:,4);%gaussian convoluted image 4
GI35= res3(:,:,5);%gaussian convoluted image 4
    
I31=fin_res3(:,:,2);%1st difference inage octave 1
I32=fin_res3(:,:,3);%2nd difference inage octave 1
I33=fin_res3(:,:,4);%3rd difference inage octave 1
I34=fin_res3(:,:,5);%4th difference inage octave 1
f=uint8(GI32);

imshow(uint8(GI31));

%finding keypoints----------------------------------
keypoints3=[];
keypoints_loc3=[];
    

    %keypoints in I31-----------------------------------
         
    keypts31=keypoints_for_2(I31,I32);
    valid_keyp31=sobel_op(I31,keypts31);%keypoints found, validity not checked
    [m31,t31,u31,v31]=magtheta33(GI31,valid_keyp31,4*sqrt(2));  %checking validity
    [D31,d31]=sift_des2(GI31,valid_keyp31,4*sqrt(2));
    %keyspoints in I31 found---------------------------
    
    
    %keypoints in I32-----------------------------------

    keypts32=keypoints_for_4(I31,I32,I33);
    valid_keyp32=sobel_op(I32,keypts32);
    [m32,t32,u32,v32]=magtheta33(GI32,valid_keyp32,8);
    [D32,d32]=sift_des2(GI32,valid_keyp32,8);
    %keypoints in I32found-----------------------------

    %finding keypoints in I33--------------------------
   
    keypts33=keypoints_for_4(I32,I33,I34);
    valid_keyp33=sobel_op(I33,keypts33);
    [m33,t33,u33,v33]=magtheta33(GI33,valid_keyp33,8*sqrt(2));
    [D33,d33]=sift_des2(GI33,valid_keyp33,8*sqrt(2));
    %keyspoints in I33 found---------------------------
    
    %keypoints in I34----------------------------------
    
    keypts34=keypoints_for_2(I34,I33);
    valid_keyp34=sobel_op(I34,keypts34);
    [m34,t34,u34,v34]=magtheta33(GI34,valid_keyp34,16);
    [D34,d34]=sift_des2(GI34,valid_keyp34,16);
    %keypoints in I34 found-----------------------------
    valid_keypoints_loc3=[];
    valid_keypoints_loc3=[valid_keyp31 valid_keyp32 valid_keyp33 valid_keyp34];
    
    for i=1:length(valid_keypoints_loc3)
    scaled_valid_keypoint_loc3(1,i)=((4.*valid_keypoints_loc3(1,i))-1);
    end

% k3=uint8(I3);
% imshow(k3);
% hold on
%  for i=1:2:(length(scaled_valid_keypoint_loc3)-1)
%          u3=scaled_valid_keypoint_loc3(1,i);
%          v3=scaled_valid_keypoint_loc3(1,i+1);
%          viscircles([u3 v3],12);
%  end
% hold off
%figure,   
   %=====================3rd ictave finished completely===================%
        
figure
 subplot(3,5,1),imshow(uint8(GI11)),title('sig=sqrt (2)');
 subplot(3,5,2),imshow(uint8(GI12)),title('sig=2');
 subplot(3,5,3),imshow(uint8(GI13)),title('sig=2*sqrt(2)');
 subplot(3,5,4),imshow(uint8(GI14)),title('sig=4');
 subplot(3,5,5),imshow(uint8(GI15)),title('sig=4*sqrt(2)');
 
 subplot(3,5,6),imshow(uint8(GI21)),title('sig=2*sqrt (2)');
 subplot(3,5,7),imshow(uint8(GI22)),title('sig=4');
 subplot(3,5,8),imshow(uint8(GI23)),title('sig=4*sqrt(2)');
 subplot(3,5,9),imshow(uint8(GI24)),title('sig=8');
 subplot(3,5,10),imshow(uint8(GI25)),title('sig=8*sqrt(2)');
 
 subplot(3,5,11),imshow(uint8(GI31)),title('sig=4*sqrt (2)');
 subplot(3,5,12),imshow(uint8(GI32)),title('sig=8');
 subplot(3,5,13),imshow(uint8(GI33)),title('sig=8*sqrt(2)');
 subplot(3,5,14),imshow(uint8(GI34)),title('sig=16');
 subplot(3,5,15),imshow(uint8(GI35)),title('sig=16*sqrt(2)');

 
 
%------------plotiing combined keypoints---------------------%
figure
k=uint8(I);
imshow(k);
hold on

 for i=1:2:(length(valid_keypoints_loc)-1)
         u=valid_keypoints_loc(1,i);
         v=valid_keypoints_loc(1,i+1);
         viscircles([u v],1);         
 end
 
 for i=1:2:(length(scaled_valid_keypoint_loc2)-1)
         u2=scaled_valid_keypoint_loc2(1,i);
         v2=scaled_valid_keypoint_loc2(1,i+1);
         viscircles([u2 v2],3,'color','blue');
 end
 for i=1:2:(length(scaled_valid_keypoint_loc3)-1)
         u3=scaled_valid_keypoint_loc3(1,i);
         v3=scaled_valid_keypoint_loc3(1,i+1);
         viscircles([u3 v3],5,'color','green');
 end
hold off

  %----------- ALL KEYPOINTS SHOWN----------------%
  
  %===========PLOTTING ORIENTATION OF KEYPOINTS==========%
    u1=[u11 u12 u13 u14];
    v1=[v11 v12 v13 v14];
    u2=[u21 u22 u23 u24];
    v2=[v21 v22 v23 v24];
    u3=[u31 u32 u33 u34];
    v3=[v31 v32 v33 v34];
    k=uint8(I);
figure
imshow(k);
hold on
h=1; 
% for i=1:2:(length(valid_keypoints_loc)-1)
%          x(h)=valid_keypoints_loc(1,i);
%          y(h)=valid_keypoints_loc(1,i+1);
%          %viscircles([u v],3);
%          h=h+1;
%  end
%  quiver(x,y,u1,v1,4)
%  hold off
% 
 for i=1:2:(length(valid_keypoints_loc)-1)
         x(h)=valid_keypoints_loc(1,i);
         y(h)=valid_keypoints_loc(1,i+1);
         h=h+1;
         %viscircles([u v],3);
 end
    quiver(x,y,u1,v1,4)
    e=1;
 for i=1:2:(length(scaled_valid_keypoint_loc2)-1)
         x2(e)=scaled_valid_keypoint_loc2(1,i);
         y2(e)=scaled_valid_keypoint_loc2(1,i+1);
         %viscircles([u2 v2],5,'color','blue');
         e=e+1;
 end
    quiver(x2,y2,u2,v2,2)
 f=1;
 for i=1:2:(length(scaled_valid_keypoint_loc3)-1)
         x3(f)=scaled_valid_keypoint_loc3(1,i);
         y3(f)=scaled_valid_keypoint_loc3(1,i+1);
         %viscircles([u3 v3],7,'color','green');
           f=f+1;
 end
    quiver(x3,y3,u3,v3,2)
    hold off
 