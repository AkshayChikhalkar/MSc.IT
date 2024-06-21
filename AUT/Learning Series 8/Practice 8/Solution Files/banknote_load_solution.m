clear all
close all

i = 5;
orImage = imread(['GEN',num2str(i),'.bmp']);  
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

%% a) histograms for original images and for Wavelet transformed (WT) images

% for i=1:5
%     
%     orImage = imread(['GEN',num2str(i),'.bmp']);  
%     orImage = rgb2gray(orImage); % grayscale image
%     orImage = double(orImage); % for further calculations: 'double' precision needs to be taken into account 
%     
%     % bringing image in vector form; image size = 400
%     orVec = [];
%     for j=1:400
%         orVec = [orVec orImage(j,:)];
%     end
%     
%     tran = red_wt(orImage, 'db2', 1, 1);  
%     trImage = tran{2} + tran{3} + tran{4}; % Wavelet transformed image
%     trImage = double(trImage); % for further calculations: 'double' precision needs to be taken into account 
%     
%     trVec = [];
%     for j=1:400
%         trVec = [trVec trImage(j,:)];
%     end
%     
%     figure
%     subplot(2,1,1)
%     % number of bins
%     bins = 50;
%     hist(orVec,bins);hold on
%     %imhist(orImage);hold on
%     grid
%     title(['Image ',num2str(i),' : Histogram in original space'])
%     subplot(2,1,2)
%     hist(trVec,bins);hold on
%     %imhist(trImage)
%     grid
%     title('Histogram in Wavelet space')
%     
% end

%% b) and c) statistical moments: variance, skewness and curtosis

Moments = []; Moments_WT = [];
for i=1:5
    
    orImage = imread(['GEN',num2str(i),'.bmp']);  
    orImage = rgb2gray(orImage); % grayscale image
    orImage = double(orImage); % for further calculations: 'double' precision needs to be taken into account 
    
    % bringing image in vector form; image size = 400
    orVec = [];
    for j=1:400
        orVec = [orVec orImage(j,:)];
    end
    
    Moments = [Moments;std(orVec) skewness(orVec) kurtosis(orVec)];
    
    tran = red_wt(orImage, 'db2', 1, 1);  
    trImage = tran{2} + tran{3} + tran{4}; % Wavelet transformed image
    trImage = double(trImage); % for further calculations: 'double' precision needs to be taken into account 
    
    trVec = [];
    for j=1:400
        trVec = [trVec trImage(j,:)];
    end
    
    Moments_WT = [Moments_WT;std(trVec) skewness(trVec) kurtosis(trVec)];
    
end

disp('Speadness in WT space is lower!')
[std(Moments(:,3)) std(Moments_WT(:,3))]

%% Visualisation
figure
plot3(Moments(:,1),Moments(:,2),Moments(:,3),'ro');hold on
plot3(Moments_WT(:,1),Moments_WT(:,2),Moments_WT(:,3),'ko');hold on
legend(' - features in original space',' - features in Wavelet space');hold on
grid

