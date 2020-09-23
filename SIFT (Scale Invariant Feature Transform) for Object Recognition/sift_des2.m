function [desc12,desc41]=sift_des2(I1,B1,sigma)
%I1=imread('cameraman.tif');
I1=double(I1);
[r1 c1]=size(I1);       %size of input image
I=zeros(r1+16,c1+16);  %creating zero matrix for new padded image
    
    %=======Padding image on both sides by 8======%
    for i=1:r1
        for j=1:c1
            I(i+8,j+8)=I1(i,j); %shifting values
        end
    end
    %===============Padding done=====================%
    
    [r c]=size(I);
   [rb1 cb1]=size(B1);


   %==========SHIFTING KEYPOINTS BY (8,8)=========%
    for i=1:cb1
        B(i)=B1(i)+8;
    end
    %==============xxxxxxxxxx======================%
    
    %DEFINE SIGMA---------------
        sig=1.5*sigma;
    %-----------------------------

%calculating magnitude and angle for every point on image-----
    for i=2:r-1
        for j=2:c-1
            magnitd(i,j)=sqrt(((I(i+1,j)-I(i-1,j)).^2)+((I(i,j+1)-I(i,j-1))^2));
            angle(i,j)=atan2(((I(i,j+1)-I(i,j-1))),(I(i+1,j)-I(i-1,j)))*(180/pi);
        end
    end
   %readjusting -ve values-----------------------------------
  
   for i=2:r-1
        for j=2:c-1
            if angle(i,j)<0
                angle(i,j)=angle(i,j)+360;
            end
        end
    end
%---------------------------------------------------------------    
[ri ci]=size(B);

%======================MAKING GAUSSIAN==========================%
            for x=-7:8
                for y=-7:8
                    gfk_d(x+8,y+8)=(1/((2*pi).*(sig.^2))).*(exp(((-(x.^2+y.^2))./(2.*(sig).^2))));
                end
            end
            gfk2_d(:,:)=double(gfk_d(:,:));
            gfk2_d(:,:)=gfk_d(:,:)./sum(sum(gfk_d(:,:)));
%========================================================%

%=============CALCULATING DOMINANT ORIENTATION=================%
     store_des=[];
    for i=1:2:(length(B)-1)     %for every key point of image
        temp_mag=zeros(16,8);
        x=B(i);
        y=B(i+1);   %extracted co-ordinates of keypoints 
        mag_window2=magnitd(x-7:x+8,y-7:y+8);%formed window of 1
        mag_window=mag_window2.*gfk2_d;
        ang_window=angle(x-7:x+8,y-7:y+8);
       % [rw cw]=size(window);
        l=1;
        for r=0:3
            for s=0:3
                mw=mag_window((4*r)+1:(4*r)+4,(4*s)+1:(4*s)+4);%making window of magnitude
                aw=ang_window((4*r)+1:(4*r)+4,(4*s)+1:(4*s)+4);%angle window
                [rmw cmw]=size(mw);
                
                for p=1:rmw
                    for q=1:cmw
                        test=(floor(aw(p,q)./45))+1; %making bin of 45 degrees
                        temp_mag(l,test)=temp_mag(l,test)+mw(p,q);%adding to particular bin
                    end
                end
                 l=l+1;
            end
            
        end
        store_des=[store_des temp_mag]; %storing the output in store_des matrix
        
    end
    %====REARRANGING DESCRIPTORS=========%
    [rd cd]=size(store_des);
    we=1;
    for i=1:8:cd
        desc41(we:we+15,1:8)=store_des(1:16,i:i+7);
        we=we+16;
    end
    desc12=[];
    [r123 c123]=size(desc41);
    for i=1:r123
        desc12=[desc12 desc41(i,:)];
    end
end
    