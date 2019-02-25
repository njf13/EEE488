close all;
clear all;
home;

disp('Begin test script... TestBoxcount...')

% WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Desktop\NeilsDendrites.png';
%WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\serveimage.png';
%  WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194Square.png';
%  SUBSAMPLE_IMAGE_PATH =  'c:\Users\sysadmin\Pictures\Subsample194.png';

%WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\simpleTestImage.jpg';
%SUBSAMPLE_IMAGE_PATH =  'c:\Users\sysadmin\Pictures\simpleTestImageSubsample.jpg';

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view subsample 5.png';

WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
WORKING_IMAGE = rgb2gray(WORKING_IMAGE);

SUBSAMPLE_IMAGE = imread(SUBSAMPLE_IMAGE_PATH);
SUBSAMPLE_IMAGE = rgb2gray(SUBSAMPLE_IMAGE);

[n,r]=boxcount(WORKING_IMAGE, 'slope');

disp('End test script... TestBoxcount...')