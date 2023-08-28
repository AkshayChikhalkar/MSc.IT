clear all; close all

%% Otsu's Method 
% Example 1
I = imread('coins.png');
subplot(1,2,1)
imshow(I)
title('Original Image')

level = graythresh(I);
BW = imbinarize(I,level);

SHIFT = -0.0;
level = level+SHIFT;
BW = imbinarize(I,level);

subplot(1,2,2)
imshow(BW)
title('Otsu´s Image Segmentation')
xlabel(['SHIFT = ',num2str(SHIFT)]);

