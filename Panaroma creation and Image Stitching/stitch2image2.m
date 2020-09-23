function [I3]=stitch2image2(I11,I22)
%---------------Reading image------------
I1 = rgb2gray(I11);
I2 = rgb2gray(I22);
%---------------------------------------

%------getting SURF features------------
pts1 = detectSURFFeatures(I1);
pts2 = detectSURFFeatures(I2);
[feat1,vpts1] = extractFeatures(I1,pts1);
[feat2,vpts2] = extractFeatures(I2,pts2);
indexPairs = matchFeatures(feat1,feat2) ;
mp1 = vpts1(indexPairs(:,1));
mp2 = vpts2(indexPairs(:,2));
figure; showMatchedFeatures(I1,I2,mp1,mp2,'montage');
legend('matched points 1','matched points 2');
%-----------------------------------------

%------getting SURF locations------------
mp1L=mp1.Location;
mp2L=mp2.Location;
temp=mp1L(:,1);
mp1L(:,1)=mp1L(:,2);
mp1L(:,2)=temp;

temp=mp2L(:,1);
mp2L(:,1)=mp2L(:,2);
mp2L(:,2)=temp;

%------------------------------------------

[HM,P1,P2]=FindHomography(mp1L,mp2L);   %Finding Homography matrixx
figure; showMatchedFeatures(I1,I2,P1,P2,'montage');
legend('matched points 1','matched points 2');

%---------Finding inverse Homography Matrix-------
invHM=inv(HM);
invHM
%invHM=invHM1/invHM1(3,3);

%I2=imtransform(I1,HM);

%---------transforming corner points---------
[r c]=size(I2);
A=[1 1;1 c;r 1;r c];
[xnew,ynew]=Transformpoints(A,invHM);
CP=[xnew ynew];
%------------------------------------------

%------Transforming every point----------------
for i=1:r
    for j=1:c
        Q=[i,j];
        %[x1(i,j),y1(i,j)]=simpletransform(Q,HM);
        [x2(i,j),y2(i,j)]=simpletransform(Q,invHM);  %Tform for 2nd image
    end
end
%----------------------------------------------

%REMOVED LOOP FROM HERE==============

 %  I1=imwarp(I2,invHM);
 %-------readjusting values of coordinates-------- 
 
 [r1 c1 col]=size(I11);
   %t1=floor(abs((x2-xnew(1))));
   %t2=floor(abs(min(xnew)+(y2-ynew(1))));  %t2=floor(abs(r1+(y2-ynew(1))));%NOTE XNEW1
%-------------------------------------------------
   
   I3=I11;
  %------assigning intensity values to each coordinates-----%
   for k=1:col
   for i=1:r
      for j=1:c
          if ( x2(i,j)>0 && y2(i,j)>0)
                I3(x2(i,j),y2(i,j),k)=I22(i,j,k);
          end     
      end
   end
   end
  %------------------------------------------------------
  figure;imshow(uint8(I3));

  
  %     I4=zeros(max(max(t1)),max(max(t2)));
%     for i=1:max(max(t1))
%       for j=1:max(max(t2))
%           if (I3(i,j)==0) && i<xnew(1) &&j<(min(xnew)+ynew(1))
%               I4(i,j)=I1(i,j);
%           else
%               I4(i,j)=I3(i,j);
%           end
%       end
%     end
%           
         
     
%  figure;imshow(uint8(I4));
% I4=zeros(200,200);
%   for i=1:xnew(1)
%     for j=1:ynew(1)
%         I4(i,j)=I1(i,j);
%     end
%   end

%figure;imshow(uint8(I4));
end