clear all
close all

orImage = imread('GEN1.bmp');  
orImage = rgb2gray(orImage); % grayscale image

figure
imshow(orImage);title('Originally taken grayscale image')

orImage = double(orImage); % for further calculations: 'double' precision needs to be taken into account 

%% Wavelet Transformation

tran = red_wt(orImage, 'db2', 1, 1);  
trImage = tran{2} + tran{3} + tran{4}; % Wavelet transformed image

figure
imshow(trImage);title('Wavelet transformed image')

trImage = double(trImage); % for further calculations: 'double' precision needs to be taken into accoun 

