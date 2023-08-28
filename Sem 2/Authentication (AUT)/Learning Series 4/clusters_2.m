clear all;close all
IM = imread('Ultraschall-Lendenwirbelsaeule.png');
IM = rgb2gray(IM);

figure
imshow(IM);title('Lumbar spine: Computer Tomography(left); Ultrasound (right)')

figure
subplot(1,3,1)
PART1 = IM(600:800,1:200);
imshow(PART1);title('CT Region')
xlabel('PART1')

subplot(1,3,2)
PART2 = IM(570:820,1:260);
imshow(PART2);title('CT Region')
xlabel('PART2')

subplot(1,3,3)
PART3 = IM(590:770,465:730);
imshow(PART3);title('US Region')
xlabel('PART3')



