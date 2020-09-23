
function [magnitude_kp2,orientat2,u,v]=magtheta33(I1,B1,sigma_not)
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
       sig=1.5*sigma_not;
    %-----------------------------
%===========AGAIN SMOOTHING THE IMAGE BY 1.5*SIGMA=====%
        
        %------finding gaussian-----------%
        for x=-7:8
            for y=-7:8
                 gfk(x+8,y+8)=(1/((2*pi).*(sig.^2))).*(exp(((-(x.^2+y.^2))./(2.*(sig).^2))));
            end
        end
            gfk2(:,:)=double(gfk(:,:));
            gfk2(:,:)=gfk(:,:)./sum(sum(gfk(:,:)));%normalizing gaussian
        %---------------------------------------
          
%========================xxxxxxxxxxxxxxx==============================%

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

%=============CALCULATING DOMINANT ORIENTATION=================%

    for i=1:2:(length(B)-1)
        temp_mag=zeros(37,1);
        x=B(i);
        y=B(i+1);%extracted co-ordinates of keypoints 
        window=I(x-7:x+8,y-7:y+8); %formed window of 4x4
        mag_window=magnitd(x-7:x+8,y-7:y+8).*gfk2;%weighting by gaussian
        ang_window=angle(x-7:x+8,y-7:y+8);
        [rw cw]=size(window);
    
    
        for j=1:rw
            for k=1:cw
                test=int8(ang_window(j,k)./10); %forming bin of 10 degrees
                temp_mag(test+1)=temp_mag(test+1)+mag_window(j,k);%adding values to bin
                temp_mag;
            end
        end
        A=max(max(temp_mag)); %searching for max magnitude
        for l=1:37              
        if temp_mag(l)==A
        orientat(i)=((l-1)*10)+5;%converting it to angle
        magnitude_kp(i)=A;  %magnitude of angle
        break
        end
    end
end

%=========ALLOTING FINAL VALUES OF MAG AND THETA=========%
    c=1;
      for i=1:2:length(orientat)
          orientat2(c)=orientat(i);
          magnitude_kp2(c)=magnitude_kp(i);
          u(c)=magnitude_kp2(c).*cos(orientat(c)); %calculating x component for quiver
          v(c)=magnitude_kp2(c).*sin(orientat(c));  %calculating y component for quiver

          c=c+1;
      end
 %==================XXXXXXXXXXXXXXXXX=====================%
end