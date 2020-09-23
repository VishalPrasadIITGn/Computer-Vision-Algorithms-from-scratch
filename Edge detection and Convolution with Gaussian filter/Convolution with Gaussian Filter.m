clc
clear all

%--Making three empty matrices--%

Gauss_Filter=zeros(9);
Gauss_Filter2=zeros(9);
Gauss_Filter3=zeros(9);

%------------x--------------%


%--Making precision type double--%

Gauss_Filter=double(Gauss_Filter);
Gauss_Filter2=double(Gauss_Filter2);
Gauss_Filter3=double(Gauss_Filter3);

%---------------x-----------------%


%------Defining values of sigma---------%

sigma1=1;%-change it to desired value-%
sigma2=3;%-change it to desired value-%
sigma3=20;%-change it to desired value-%

%--------------x--------------%


%------Squaring all three values of Sigma------%

sig_sq=sigma1*sigma1;
sig2_sq=sigma2*sigma2;
sig3_sq=sigma3*sigma3;

%--------------x----------------%

%k=1/(sqrt(2*pi)*sigma1);
% NF=0;
 
%---------Calculating Gaussian Values---------%

for i=1:9
   for j=1:9
   
      expo_value1=(((i-5).^2+(j-5).^2)./(2*sig_sq));
      Gauss_Filter(i,j)= (exp((-1)*(expo_value1)));

      expo_value2=(((i-5).^2+(j-5).^2)./(2*sig2_sq));
      Gauss_Filter2(i,j)= (exp((-1)*(expo_value2)));
      
      expo_value3=(((i-5).^2+(j-5).^2)./(2*sig3_sq));
      Gauss_Filter3(i,j)= (exp((-1)*(expo_value3)));
   
   
   end
end
%----------------------x-----------------------%


%------------Normalising Gaussian---------------%

GFK1=Gauss_Filter/sum(sum(Gauss_Filter));
GFK2=Gauss_Filter2/sum(sum(Gauss_Filter2));
GFK3=Gauss_Filter3/sum(sum(Gauss_Filter3));

%---------------------x----------------------%


%-------Reading and padding image-------%

I1=imread('CV_image3.jpg');
I=double(I1);
IPad = padarray(I,[4 4],'both');
[m n c]=size(I);

%-------------------x--------------------%

%--creating empty matrices--%

result1=zeros(m,n,c);
result2=zeros(m,n,c);
result3=zeros(m,n,c);

%------x------%

%------convoluting------%
for k=1:c         %three color layes
    for i=1:m     %all rows        
        for j=1:n %all columns
            window=IPad(i:i+8,j:j+8,k); %creating temporary window of values
            window2=double(window);      %from IPad to be multiplied with GFK
        
            new_value1=window2.*GFK1;      %covolution for 1st sigma=1
            result1(i,j,k)= sum(sum(new_value1)); %adding values to get            
                                                    %final value for
                                                    %(i,j)pixel
            
            new_value2=window2.*GFK2;       %covolution for 2nd sigma=3
            result2(i,j,k)= sum(sum(new_value2));
        
            new_value3=window2.*GFK3;       %covolution for 3rd sigma=20
            result3(i,j,k)= sum(sum(new_value3));
        end
    end
end
%----------x---------------%


R1=uint8(result1);
R2=uint8(result2);
R3=uint8(result3);
%imshow(R)

%--showing individual image--%
 

 figure,imshow(R1);
 figure,imshow(R2);
 figure,imshow(R3);

 %-----------x-------------%


 %---Showing image for comparison---%
 figure
 subplot(2,2,1),imshow(I1),title('original image');
 subplot(2,2,2),imshow(R1),title('sigma=1');
 subplot(2,2,3),imshow(R2),title('sigma=3');
 subplot(2,2,4),imshow(R3),title('sigma=20');

%------------x-----------------%