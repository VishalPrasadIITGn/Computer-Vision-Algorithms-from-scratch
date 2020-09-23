%-----this block is just for reference---------%
%   In this block we perform DCT, Hard thresholding and Inverse DCT for
%   De-noising from gaussian noise as proposed in research paper.
%   since, it is a 2D image , aggregation step is not done.
%   it just shows how DCT,HT,and IDCT work on an image.
%     I1=(imread('cameraman.tif'));
%     I1=imnoise(I1,'gaussian',0,((0.005)));
%     J = dct2(I1);
%     Y = wthresh(J,'h',15);
%     K = idct2(Y);
%     %figure;
%     imshowpair(I1,K,'montage');
%     title('Image with noise (Left) and Processed Image with dct,HT, and IDCT (Right)');
    %------------------------------------------------------------------
 
%=========ORIGINAL CODE STARTS HERE==============================%
I=imread('house.png'); %NOTE:USE B;LACK AND WHITE IMAGE ONLY
%I=imread('cameraman.tif');

%I=rgb2gray(I);
 
%I=imresize(I,0.4);
sigma=0.05;           %it is normalized
%sigma=0.08
%sigma=0.1
Rnext=3;            %window sliding factor for next reference block

S_width=18;   %%% length of the side of the search neighborhood for full-search block-matching (BM)
                    %must be even
                    %dimension of search window becomes 39x39
N1=8;              %block size for image patches and HT
lambda_T2D=0;     %%threshold parameter for the coarse initial denoising used in the d-distance measure
lambda_T3D=2.7;   %% threshold parameter for the hard-thresholding in 3D transform domain
noise_mean=0;
I=padarray(I,[(2*S_width+1) (2*S_width+1)],'symmetric','post');
I_N=imnoise(I,'gaussian',noise_mean,((sigma).^2)); %creating noisy image
[r c]=size(I_N); %calculating size of noisy image
%array3D2=[];
U11=zeros(size(I_N));
L11=zeros(size(I_N));
U22=zeros(size(I_N));
L22=zeros(size(I_N));

 
%%%%%%%%%%%%%============DOING BLOCK MATCHING======%%%%%%%%%%%%%%%%%%
for i=1:r-2*S_width
   for j=1:c-2*S_width 
 
     %----taking a area to search for our reference patch 
       temp=I_N(i:i+2*S_width,j:j+2*S_width); %temp is cropped image, 39x39 is window size
     %--------------------------------------------------
 
     %----------taking 8x8 patches and converting them to columns 
         B=im2col(temp,[N1 N1],'sliding');       
         B=double(B);    %each patch is converted into a column
        [rb, cb]=size(B);
     %-----------------------------------------------------------   
 
        distance=zeros(cb,1); %creating empty mattrix to store distance 
 
    %------------creating reference block and doing HT on it-----------------%
 
            ref_window=wthresh(B(:,1),'h',6*sigma);%taking 1st 8x8 patch as a reference and performing HT on it
 
    %--------------------------------------------------------
 
    %------searching for patch closest  to ref patch------------%
 
        for k=1:cb
            temp3=wthresh(B(:,k),'h',6*sigma);   %transforming next 8x8 block   
            temp4=ref_window-temp3;              %getting diff in transformed domain
            temp5=reshape(temp4,[8 8]);          %reshaping it as 8x8 block
            temp6=(norm(temp5,2))./64;           %getting norm 2 distance
            distance(k)=temp6;                   %storing the values of distance
        end
 
    %--------------------------------------------------------------%
 
    %--------------Creating 3D MATRIX and sorting blocks according to distance------------%
 
        [sortedDist, indx]=sort(distance); 
        cl=8;                %number of closest 8x8 patch we want to store
        closest_8=indx(1:cl); %getting index of closest 8x8 patch
        B2=B(:,closest_8);   %storing closest 8 blocks 
        array3D=zeros(N1,N1,cl); %CREATING 3D MATRIX
 
        for m=1:size(B2,2)
            t=B2(:,m);
            array3D(:,:,m)=reshape(t,[N1,N1]);  %STACKING 8x8 PATCHES ONE OVER THE OTHER
        end
     %-----------------------------------------------------------------       
 
 
    %%%%%%%%%%%%%%%%%BLOCK MATCHING DONE-3D MATRIX OBTAINED%%%%%%%%%%%%%%%%%%%%%    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%=====PERFORMING COLLABORATIVE FILTERING=======%%%
 
        %-----------applying DCT across three dimension matrix--------%
        for h=1:size(array3D,3) %changed it from 2 to 3
            Tform(:,:,h)=dct2(array3D(:,:,h));
        end
        %---------------------------------------------------%  
 
        %--------applying hard thresholding-----------%
 
            midtemp=wthresh(Tform,'h',sigma*6);
        %-----------------------------------------------
        %-------aggregation cofficient------%
        x=sum(midtemp(:)>0);%replace this
        y=max(1,x);
        w=(1/y);
        %---------------------------------------
 
        %--------applying inverse DCT -------------%
        for g = 1:size(midtemp,3)
            new_array3D(:,:,g)=idct2(midtemp(:,:,g));
        end
        %-------------------------------------------%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        %%%%%==============AGGREGATION OF PIXELS=========%
               for k=1:8
                   U11(i:i+7,j:j+7)=U11(i:i+7,j:j+7)+w*(new_array3D(:,:,k));
                   L11(i:i+7,j:j+7)=L11(i:i+7,j:j+7)+w;
               end
        %               NOT PERFORMED YET
        %==================================================
        end
   end 
    basic_im=U11./L11;
    
  
%===============================================================================
%SECOND STEP
 
 
IB=basic_im;
[r2 c2]=size(IB);
N2=zeros(r2,c2);
D2=zeros(r2,c2);
%%%%%%%%%%%%%============DOING BLOCK MATCHING======%%%%%%%%%%%%%%%%%%
for i=1:r2-2*S_width
   for j=1:c2-2*S_width %NOTE: changed from r to c
 
     %----taking a area to search for our reference patch 
        temp=I_N(i:i+2*S_width,j:j+2*S_width); %temp is cropped image, 39x39 is window size
        temp2=IB(i:i+2*S_width,j:j+2*S_width);
     %--------------------------------------------------
 
     %----------taking 8x8 patches and converting them to columns 
         B=im2col(temp,[N1 N1],'sliding');       
         B=double(B);    %each patch is converted into a column
         B2=im2col(temp2,[N1 N1],'sliding');
         B2=double(B2);
         [rb2, cb2]=size(B2);
     %-----------------------------------------------------------   
 
         distance2=zeros(cb2,1); %creating empty mattrix to store distance 
 
    %------------creating reference block and taking NORM DISTANCE on it-----------------%
 
         %ref_window=wthresh(B2(:,1),'h',6*sigma);%taking 1st 8x8 patch as a reference and performing HT on it
        ref_window=B2(:,1);
         ref_window=B2(:,1);
    %--------------------------------------------------------
 
    %------searching for patch closest  to ref patch (BASIC)------------%
 
          for k=1:cb2
            t3=B2(:,k);   %transforming next 8x8 block   
            t4=ref_window-t3;              %getting diff in transformed domain
            t5=reshape(t4,[8 8]);          %reshaping it as 8x8 block
            t6=(norm(t5,2))./64;             %getting norm 2 distance
            distance2(k)=t6;                   %storing the values of distance
         end
 
    %--------------------------------------------------------------%
 
    %--------------Creating 3D MATRIX and sorting blocks according to distance------------%
 
        [sortDist, in]=sort(distance2); 
        cl=8;                %number of closest 8x8 patch we want to store
        closest_8=in(1:cl); %getting index of closest 8x8 patch
        B22=B2(:,closest_8);%storing closest 8 blocks
        B11=B(:,closest_8);
        array3Db=zeros(N1,N1,cl); %CREATING 3D MATRIX
        array3Dn=zeros(N1,N1,cl);
 
        for m=1:size(B22,2)
            tb=B22(:,m);
            tn=B11(:,m);
 
            array3Db(:,:,m)=reshape(tb,[N1,N1]);  %STACKING basic 8x8 PATCHES ONE OVER THE OTHER
            array3Dn(:,:,m)=reshape(tn,[N1,N1]);    %noisy
        end
     %-----------------------------------------------------------------       
 
     
 
    %%%%%%%%%%%%%%%%%BLOCK MATCHING DONE-3D MATRIX OBTAINED%%%%%%%%%%%%%%%%%%%%%    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
 
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%=====PERFORMING COLLABORATIVE FILTERING=======%%%
 
        %-----------applying DCT in three dimensions BASIC--------%
        for h=1:size(array3Db,3) %changed it from 2 to 3
            Tform(:,:,h)=dct2(array3Db(:,:,h));
        end
        %---------------------------------------------------%  
        wien_coff=zeros(8,1);
        for k=1:8   %NOTE CHANGE
            tn=Tform(:,:,k);
            tn=norm(tn,1).^2;   %NORM 2ND
            wien_coff(k)=tn/(tn+(sigma.^2));
        end   
 
 
            %-----------applying DCT in three dimensions BASIC--------%
            %this is for performing wiener filtering
 
        for h=1:size(array3Dn,3) %changed it from 2 to 3
            Tform(:,:,h)=dct2(array3Dn(:,:,h));
        end
        %---------------------------------------------------% 
        %multiplying cofficients-----------------
 
        for h=1:size(array3Dn,3) %changed it from 2 to 3
            Tform(:,:,h)=Tform(:,:,h).*wien_coff(h);%dct2(array3Dn(:,:,h));
        end
        %--------------------------------------------
        
 
        %--------applying inverse DCT -------------%
        for g = 1:size(Tform,3)
            new_array3Dn(:,:,g)=idct2(Tform(:,:,g));
        end
        %-------------------------------------------%
 
        %coff for aggregation
        awt=sum(wien_coff(:));
        awt=1/(awt.^2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        %%%%%==============AGGREGATION OF PIXELS=========%
               for k=1:8
                   U22(i:i+7,j:j+7)=U22(i:i+7,j:j+7)+awt*(new_array3Dn(:,:,k));
                   L22(i:i+7,j:j+7)=L22(i:i+7,j:j+7)+awt;
               end
                      
        %==================================================
        end
   end 
FR=(U22./L22);

IO=I(1:r-2*S_width,1:c-2*S_width);
figure;imshow(uint8(IO));
title('ORIGINAL IMAGE');

I_N=I_N(1:r-2*S_width,1:c-2*S_width);
figure;imshow(uint8(I_N));
title('NOISY IMAGE');


IB=IB(1:r-2*S_width,1:c-2*S_width);
figure;imshow(uint8(IB));
title('BASIC IMAGE');


FR=FR(1:r-2*S_width,1:c-2*S_width);
figure;imshow(uint8(FR));
title('FINAL IMAGE');


 