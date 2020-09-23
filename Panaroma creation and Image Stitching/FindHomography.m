function [Final_Homog,Final_inliers1,Final_inliers2]=FindHomography(mp1L,mp2L)
l=length(mp1L);

%probablity that any point is inlier-> w
w=0.5;

%probablity that at least one sample is free from outliers -> p
p=0.99;

%Number of selected points-> s
s=4;

%Number of tries -> N
N=((log(1-p))./(log((1-((w).^s)))));
inlier_max=0;

for i=1:N
    Rval=randi(l,4,1);  %random values for indexes
    p1=mp1L(Rval,:);
    p2=mp2L(Rval,:);
    A=zeros(8,9);
    %A=double(A);
    %-----------------------------Finding HOMOGRAPHY matrix---------------------------%
    for k=1:8
        if (rem(k,2)==1) 
            j=ceil(k/2);
            A(k,:)=[0, 0, 0, (-p1(j,1)), (-p1(j,2)), (-1), (p2(j,2).*p1(j,1)), (p2(j,2).*p1(j,2)), p2(j,2)];
        
        end
        
        if (rem(k,2)==0) 
            h=k/2;
            A(k,:)=[p1(h,1) p1(h,2) 1 0 0 0 -p2(h,1).*p1(h,1) -p2(h,1).*p1(h,2) -p2(h,1)];
        
        end
        
    end
        
       [U,S,V]=svd(A);
       H2=V(:,9);
       A2=[H2(1),H2(2),H2(3);H2(4),H2(5),H2(6);H2(7),H2(8),H2(9)];
       Homog=A2(:,:)/A2(3,3); %CHANGED . FOR TESTING PURPOSE
        
%----------------------homography matrixfound----------------------------%
           
%---------------------transforming points---------------------------%        
  
     %-------creating (X1,Y1,1) coordinates matrix-------------------%
       
        temp=ones(length(mp1L),3);
        temp(:,1)=mp1L(:,1);
        temp(:,2)=mp1L(:,2);
     
    %-------(X1,Y1,1) matrix created------------------%         
       %mp2L_dash=zeros
    
   %-------transforming points in x1 to x2 dash-------%    
       for i1=1:length((mp1L))
           x=Homog(1,1:3)*temp(i1,1:3)';
           y=Homog(2,1:3)*temp(i1,1:3)';
           w=Homog(3,1:3)*temp(i1,1:3)';
           x1=x/w;
           y1=y/w;
           mp2L_dash(i1,1)=x1;
           mp2L_dash(i1,2)=y1;
           diff(i1,1)=(((mp2L(i1,1)-mp2L_dash(i1,1)).^2+(mp2L(i1,2)-mp2L_dash(i1,2)).^2).^(0.5));
           
       end
       %-----------------points transformed-----------------------%
      % mean_error=sum(diff);
       %thresh=(mean_error)./4;
       %---------Deciding threshold-----
       
       thresh=0.5;
       inlier=1;
       %-------------------------------
       %inlier_max=0;
       %Final_Homog=zeros(3,3);
       c=1;
       %------assigning inlier points-----------
       for i3=1:length(diff)
           if (diff(i3)<=thresh)
               inlier=inlier+1;
               inlier_pts1(c,:)=mp1L(i3,:);
               inlier_pts2(c,:)=mp2L_dash(i3,:);
               c=c+1;
           end
       end
       %---------------------------------------
        
       %--------counting maxm inliers------------
       if (inlier>inlier_max)

           inlier_max=inlier;
           Homog;
           Final_Homog=Homog;
           inlier_max;
           Final_inliers1=inlier_pts1;
           Final_inliers2=inlier_pts2;
       end
         %----------------------------------------   
       
end
end
       



