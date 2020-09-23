clc
clear all
close all
I1 = (imread('im_0.jpg'));
I2 = (imread('im_1.jpg'));
[I3]=stitch2image2(I1,I2); %calling function stitch2image2
imshow(uint8(I3));
I4 = (imread('im_2.jpg'));
[SI1]=stitch2image2(I3,I4);%calling function stitch2image2
imshow(uint8(SI1));
I5 = (imread('im_3.jpg'));
[SI2]=stitch2image2(SI1,I5);%calling function stitch2image2
imshow(uint8(SI1));