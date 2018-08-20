close all;
clear all;
home;

disp('Begin test script...')

WORKING_IMAGE = imread('c:\Users\sysadmin\Desktop\NeilsDendrites.png');
WORKING_IMAGE = rgb2gray(WORKING_IMAGE);


figure(1)
imshow(WORKING_IMAGE);

histo = imgHistogram(WORKING_IMAGE);

figure(2)
plot(histo);

figure(3)
plot(imgEqualize(WORKING_IMAGE))

disp('End test script...')