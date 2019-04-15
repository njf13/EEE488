close all;
clear all;
home;

disp('Begin test script...')

addpath(genpath('C:\Users\sysadmin\Downloads\TREES1.15'))

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view subsample 5.png';

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194Square.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194Sample2.png';

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\DendriteFromNeil3.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\DendriteFromNeil3Sample.png';
SUBSAMPLE_IMAGE_PATH_2 = 'c:\Users\sysadmin\Pictures\DendriteFromNeil3Sample2.png';
SUBSAMPLE_IMAGE_PATH_3 = 'c:\Users\sysadmin\Pictures\DendriteFromNeil3Sample3.png';
%SUBSAMPLE_IMAGE_PATH_4 = 'c:\Users\sysadmin\Pictures\DendriteFromNeil2Sample4.png';


WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
WORKING_IMAGE = rgb2gray(WORKING_IMAGE);

SUBSAMPLE_IMAGE = imread(SUBSAMPLE_IMAGE_PATH);
SUBSAMPLE_IMAGE = rgb2gray(SUBSAMPLE_IMAGE);

SUBSAMPLE_IMAGE_2 = imread(SUBSAMPLE_IMAGE_PATH_2);
SUBSAMPLE_IMAGE_2 = rgb2gray(SUBSAMPLE_IMAGE_2);

SUBSAMPLE_IMAGE_3 = imread(SUBSAMPLE_IMAGE_PATH_3);
SUBSAMPLE_IMAGE_3 = rgb2gray(SUBSAMPLE_IMAGE_3);

% SUBSAMPLE_IMAGE_4 = imread(SUBSAMPLE_IMAGE_PATH_4);
% SUBSAMPLE_IMAGE_4 = rgb2gray(SUBSAMPLE_IMAGE_4);


figure(1)
imshow(WORKING_IMAGE);

histo = imgHistogram(WORKING_IMAGE);

% figure(2)
% plot(histo);
% 
% 
% normedHisto = histNormalize(histo);
% 
% figure(3)
% plot(normedHisto);

% figure(4)
% imshow(imgEqualize(WORKING_IMAGE));

figure(5)
[level, maximum]=imgThresholdOtsu(WORKING_IMAGE);
imshow(imgThreshold(WORKING_IMAGE, level/2, maximum));

% templateAveraging = zeros(3);
% for i=1:4
%     for j=1:4
%         templateAveraging(i,j)=1/16;
%     end
% end

% figure(6)
% convolved = convolve(WORKING_IMAGE, templateAveraging);
% imshow(convolved);

% templateAveraging = gaussian_template(5, 1);
% figure(7)
% convolved = convolve(WORKING_IMAGE, templateAveraging);
% imshow(convolved);

[level, maximum] = imgThresholdOtsu(WORKING_IMAGE);
thresholdImg = imgThreshold(WORKING_IMAGE, level*0.9, maximum);

[level, maximum]=imgThresholdOtsu(SUBSAMPLE_IMAGE);
thresholdSubImg = imgThreshold(SUBSAMPLE_IMAGE, level*0.9, maximum);

[level2, maximum2]=imgThresholdOtsu(SUBSAMPLE_IMAGE_2);
thresholdSubImg2 = imgThreshold(SUBSAMPLE_IMAGE_2, level2*0.9, maximum2);

[level3, maximum3]=imgThresholdOtsu(SUBSAMPLE_IMAGE_3);
thresholdSubImg3 = imgThreshold(SUBSAMPLE_IMAGE_3, level3*0.9, maximum3);

% [level4, maximum4]=imgThresholdOtsu(SUBSAMPLE_IMAGE_4);
% thresholdSubImg4 = imgThreshold(SUBSAMPLE_IMAGE_4, level2*0.9, maximum4);


% figure(8)
% convolved = convolve(thresholdImg, templateAveraging);
% imshow(convolved);

% figure(9)
% templateGaussianEven = gaussian_template(6,1);
% eroded = erosion(WORKING_IMAGE, templateGaussianEven);
% imshow(eroded);
% 
% figure(10)
% dilated = dilation(WORKING_IMAGE, templateGaussianEven);
% imshow(dilated);
% 
% figure(11)
% edgeImg=detect_edges(thresholdImg);
% imshow(edgeImg);
% 
% figure(12)
% edgeImg = detect_edges_sobel_2(thresholdImg,3);
% imshow(edgeImg);
% 
% figure(13)
% curveConnImg = curve_connect( edgeImg);
% imshow(curveConnImg);

% figure(17)
% cornerImg = gradient_corner(thresholdImg, 'NI');
% imshow(cornerImg);

centers=[];
disp('Search for target image...')
centers = findMoments(WORKING_IMAGE, SUBSAMPLE_IMAGE);
centers2 = findMoments(WORKING_IMAGE, SUBSAMPLE_IMAGE_2);
centers3 = findMoments(WORKING_IMAGE, SUBSAMPLE_IMAGE_3);
% centers4 = findMoments(WORKING_IMAGE, SUBSAMPLE_IMAGE_4);

centers=[centers, centers2, centers3];%, centers4];

figure(18)
imshow(WORKING_IMAGE);
hold on;
plot(centers(2,:),centers(1,:),'x');
centersX=centers(2,:)';
centersY=centers(1,:)';

imgSize = size(WORKING_IMAGE);

[weightMat] = findNearestNeighbors(centers(2,:),centers(1,:));


[route] = prims(weightMat, max(size(weightMat)));

routeCount = max(size(route));

for i=1:routeCount
    disp(['Connecting ', num2str(centersX(route(i,1))), ',', num2str(centersY(route(i,1))), ' to ', num2str(centersX(route(i,2))), ',',num2str(centersY(route(i,2))),'...'])
    line([centersX(route(i,1)),centersX(route(i,2))],[centersY(route(i,1)),centersY(route(i,2))]);
end

%clear adjMat for use in dendrite class
adjMat = zeros(max(size(centers)));
%load adjMat for use in dendrite class
for i=1:max(size(route))
    parent = route(i,1);
    child  = route(i,2);
    if(child<=parent)
        continue
    end
    adjMat(child,parent)=1;
end

dummyZ = [];

theDendrite = dendrite(sparse(adjMat), centersX, centersY, dummyZ);

capMatrix = ones([1,length(centersX)]);
resMatrix = ones([1,length(centersX)]);

capMatrix = 100e-6.*capMatrix;
resMatrix = 100.*resMatrix;

theDendrite.setC(capMatrix);
theDendrite.setR(resMatrix);

theDendrite.netlist();

return



[M,Ang, sobel_img] = detect_edges_sobel_2(thresholdImg,3);
[Ms, Angs, sobel_img_small] = detect_edges_sobel_2(thresholdSubImg,3);

figure(19)
imshow(sobel_img);

figure(20)
imshow(sobel_img_small);

sizeVec = size(sobel_img_small);
rows = sizeVec(1,1);
r_tab = invariant_r_table(180, sobel_img_small, Ms, Angs);

figure(21)
hough = invariant_generalized_hough( sobel_img, r_tab, M, Ang);
houghStd = std(hough,1,'all');
[rr,cc]=size(hough);
for i=1:rr
    for j=1:cc
        if hough(i,j)<3.0*houghStd
            hough(i,j)=0;
        end
    end
end

surf(hough);

% tempMatch = template_matching(sobel_img, sobel_img_small);
% figure(17)
% imshow(tempMatch);

figure(22)
[acct, accro] = decomp_line_hough(hough);
plot(acct);

figure(20)
plot(accro);

% [Xfeature, Yfeature] = MatrixMax(hough)



disp('End test script...')