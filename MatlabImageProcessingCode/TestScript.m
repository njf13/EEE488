close all;
clear all;
home;

disp('Begin test script...')

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Desktop\NeilsDendrites.png';
WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\serveimage.png';
%WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00193.jpg';
WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
%WORKING_IMAGE = rgb2gray(WORKING_IMAGE);


figure(1)
imshow(WORKING_IMAGE);

% histo = imgHistogram(WORKING_IMAGE);
% 
% figure(2)
% plot(histo);
% 
% 
% normedHisto = histNormalize(histo);
% 
% figure(3)
% plot(normedHisto);
% 
% figure(4)
% imshow(imgEqualize(WORKING_IMAGE))
% 
% figure(5)
% [level, maximum]=imgThresholdOtsu(WORKING_IMAGE)
% imshow(imgThreshold(WORKING_IMAGE, level, maximum));

templateAveraging = zeros(3);
for i=1:4
    for j=1:4
        templateAveraging(i,j)=1/16;
    end
end

figure(6)
convolved = convolve(WORKING_IMAGE, templateAveraging);
imshow(convolved);

disp('End test script...')