close all;
clear all;
home;

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194Square.png';
SUBSAMPLE_IMAGE_PATH =  'c:\Users\sysadmin\Pictures\Subsample194.png';

WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
WORKING_IMAGE = rgb2gray(WORKING_IMAGE);

SUBSAMPLE_IMAGE = imread(SUBSAMPLE_IMAGE_PATH);
SUBSAMPLE_IMAGE = rgb2gray(SUBSAMPLE_IMAGE);

[level, maximum] = imgThresholdOtsu(WORKING_IMAGE);
thresholdImg = imgThreshold(WORKING_IMAGE, level*0.9, maximum);

[level, maximum]=imgThresholdOtsu(SUBSAMPLE_IMAGE);
thresholdSubImg = imgThreshold(SUBSAMPLE_IMAGE, level*0.9, maximum);

cx = thresholdImg;

[m,n]=size(cx);

cxcols = zeros([m,n]);

covX = cov(cx);

for j=1:n
    meanX = mean(cx(:,j));
    cxcols(:,j) = cx(:,j)-meanX;
end


Mcx = cxcols;
covX=Mcx'*Mcx/(m-1);

[W,L]=eig(covX);

cy=cx*W';

meanY=mean(cy);

cy(:,1)= zeros;
xr=(W'*cy')';
