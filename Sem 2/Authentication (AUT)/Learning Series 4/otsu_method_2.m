clear all; close all

%% Otsu's Method 
% Example 2
IM = imread('Ultraschall-Lendenwirbelsaeule.png');
IM = rgb2gray(IM);

figure
imshow(IM);title('Lumbar spine: Computer Tomography(left); Ultrasound (right)')

figure
PART1 = IM(500:870,1:300);
subplot(2,2,1);
imshow(PART1);title('Original Region (CT)')
SHIFT = 0.0;
level = graythresh(PART1)+SHIFT; % try SHIFT=0.4;
BW = imbinarize(PART1,level);

subplot(2,2,2)
imshow(BW)
title('Otsu´s Image Segmentation')


PART2 = IM(600:800,1:200);
subplot(2,2,3);
imshow(PART2);
SHIFT = 0.0;
level = graythresh(PART2)+SHIFT; % try other SHIFTs;
BW = imbinarize(PART2,level);

subplot(2,2,4)
imshow(BW)
PART3 = IM(590:770,465:730);
figure
subplot(1,2,1)
imshow(PART3);title('Original Region (US)')
SHIFT = 0.0;
level = graythresh(PART3)+SHIFT; % try SHIFT=-0.001;
BW = imbinarize(PART3,level);

subplot(1,2,2)
imshow(BW)
title('Otsu´s Image Segmentation')

