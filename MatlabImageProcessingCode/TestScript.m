close all;
clear all;
home;

disp('Begin test script...')

addpath(genpath('C:\Users\sysadmin\Downloads\TREES1.15'))

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\Nicks Tree Simple view subsample 5.png';

WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194Square.png';
SUBSAMPLE_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194SquareSample.png';

WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
WORKING_IMAGE = rgb2gray(WORKING_IMAGE);

SUBSAMPLE_IMAGE = imread(SUBSAMPLE_IMAGE_PATH);
SUBSAMPLE_IMAGE = rgb2gray(SUBSAMPLE_IMAGE);


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
figure(18)
imshow(WORKING_IMAGE);
hold on;
plot(centers(2,:),centers(1,:),'x');
centersX=centers(2,:)';
centersY=centers(1,:)';

imgSize = size(WORKING_IMAGE);
numNeighbors=3;
[adjMat, weightMat] = findNearestNeighbors(centers(2,:),centers(1,:),numNeighbors);


[w_st, ST, X_st] = kruskal(adjMat, weightMat);

edgeCount = max(size(ST));

ST

for i=1:edgeCount
    disp(['Connecting ', num2str(centersX(ST(i,1))), ',', num2str(centersY(ST(i,1))), ' to ', num2str(centersX(ST(i,2))), ',',num2str(centersY(ST(i,2))),'...'])
    line([centersX(ST(i,1)),centersX(ST(i,2))],[centersY(ST(i,1)),centersY(ST(i,2))]);
end



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