clc
clear all
close all
    %-----------SIFT PROCEDURE---------------------
I11 = rgb2gray(imread('004.png'));
I22 = rgb2gray(imread('005.png'));

I1=imresize(I11,0.3);
I2=imresize(I22,0.3);
I1p=padarray(I1,[5 5],'both');
I2p=padarray(I2,[5 5],'both');

pts1 = detectSURFFeatures(I1);
pts2 = detectSURFFeatures(I2);

[feat1,vpts1] = extractFeatures(I1,pts1);
[feat2,vpts2] = extractFeatures(I2,pts2);

indexPairs = matchFeatures(feat1,feat2) ;

mp1 = vpts1(indexPairs(:,1));
mp2 = vpts2(indexPairs(:,2));

mp1L=mp1.Location;
mp2L=mp2.Location;
%got matched points locations--------
%-----------------------------------------
%-----coordinates exchanged ---------
    mp1Ln(:,1)=mp1L(:,2);
    mp1Ln(:,2)=mp1L(:,1);
    mp2Ln(:,1)=mp2L(:,2);
    mp2Ln(:,2)=mp2L(:,1);
%-------------------------------------
%------finding fundamental matri--------

    %[F]=estimateFundamentalMatrix(mp1L,mp2L,'NumTrials',4000);
    F = estimateFundamentalMatrix(mp1L,...
    mp2L,'Method','RANSAC',...
    'NumTrials',15000,'DistanceThreshold',1e-5);
%---------------------------------------

[r c]=size(I2);
ws=1;
k=1;
I3=zeros(size(I2p,1),size(I2p,2));  %creating empty matrix
for i=1:r
    for j=1:c
        ori=I2p(i+3:i+7,j+3:j+7);   %original patch to compare with
        xy=[i,j];                   %making coordinates
        %-------getting epipolar line and border points-------
        epiline=epipolarLine(F',xy);
        pts=lineToBorderPoints(epiline,size(I1));
        %-----------------------------------------------------
        
        if (pts(1)>0 && pts(2)>0 && pts(3)>0 && pts(4)>0)
        [y,x]=bresenham(pts(1),pts(2),pts(3),pts(4)); %getting all points on line
        
         
%         for m=1:length(x)
%              if(x(m)>0 && x(m)<=r && y(m)>0 && y(m)<=c)
%                  temp=I1p(x(m)+3:x(m)+7,y(m)+3:y(m)+7);
%                  diff=double(temp)-double(ori);
%                  nrm(m)=norm(diff);
%              end
%          end
         
         
         
%          for n=1:length(nrm)
%              if(nrm(n)==0)
%                  nrm(n)=10000;
%              end
%          end
  
%          [mn indx]=min(nrm);
%          x1=x(indx);
%          y1=y(indx);

            [x1 y1]=calcnorm(x,y,I1p,ori);  %calculating the minimum norm
         
            if (x1>0 && y1>0 && x1<r && y1<c)
         I3(i,j)=I1(x1,y1); %allocating final values to new images
         end
         %clear nrm
        end   %commented these two lines
        
        
     end
end
figure;imshow(I1);
figure;imshow(uint8(I3));
        
