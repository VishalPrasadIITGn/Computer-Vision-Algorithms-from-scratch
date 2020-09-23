clc
clear all
%---Making empty matrices----%

Gauss_Filter=zeros(11);
Gauss_Filter2=zeros(11);

%------------x------------%


%-----Making precision double-----%

Gauss_Filter=double(Gauss_Filter);
Gauss_Filter2=double(Gauss_Filter2);

%----------------x-----------------%

%---------Deciding values of sigma----------%

sigma1=1;%-change it to desired value-%
sigma2=9;%-change it to desired value-%

%----------------x-----------------%

%----------Calculating sigma square----------%

sig_sq=sigma1*sigma1;
sig2_sq=sigma2*sigma2;

%----------------x-----------------%

%-----Making Gaussian Filter Matrix-----%
for i=1:11
   for j=1:11
   
      expo_value1=(((i-6).^2+(j-6).^2)./(2*sig_sq));
      Gauss_Filter(i,j)= (exp((-1)*(expo_value1)));
      
      expo_value2=(((i-6).^2+(j-6).^2)./(2*sig2_sq));
      Gauss_Filter2(i,j)= (exp((-1)*(expo_value2)));
   end
end

%----------------x-----------------%


%------Normalising Matrix----------%

GFK1=Gauss_Filter/sum(sum(Gauss_Filter));
GFK2=Gauss_Filter2/sum(sum(Gauss_Filter2));

%----------------x-----------------%


%-----Taking Difference of Gaussian----%

GFK = GFK2-GFK1;
%GFK=GFK/sum(sum(GFK));
%--------------x--------------%
%NF=sum(sum(GFK));

%-----Reading and padding image----%

I1=imread('CV_image3.jpg');
I=double(rgb2gray(I1));
% I=double(I);
IPad = padarray(I,[5 5],'both');

%----------------x-----------------%

%-------Creating Empty Matrix for Output---%
[m n]=size(I);
result=zeros(m,n);

%----------------x-----------------%

%----Covoluting Padded Image with DoG Filter----%

for i=1:m
    for j=1:n
        window=IPad(i:i+10,j:j+10);
        window2=double(window);
        new_value=window2.*GFK;
        result(i,j)= sum(sum(new_value));
        
    end
end

%----------------x-----------------%
%result=unit8(result);

R=uint8(result);
imshow(R)
%imshow('CV_image3.jpg');
