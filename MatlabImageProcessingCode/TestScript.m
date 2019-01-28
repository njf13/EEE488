close all;
clear all;
home;

disp('Begin test script...')

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

figure(17)
cornerImg = gradient_corner(thresholdImg, 'NI');
imshow(cornerImg);

centers=[];
disp('Search for target image...')
centers = findMoments(WORKING_IMAGE, SUBSAMPLE_IMAGE);
figure(18)
imshow(WORKING_IMAGE);
hold on;
plot(centers(2,:),centers(1,:),'x');



return

[M,Ang, sobel_img] = detect_edges_sobel_2(thresholdImg,3);
[Ms, Angs, sobel_img_small] = detect_edges_sobel_2(thresholdSubImg,3);

figure(14)
imshow(sobel_img);

figure(15)
imshow(sobel_img_small);

sizeVec = size(sobel_img_small);
rows = sizeVec(1,1);
r_tab = invariant_r_table(180, sobel_img_small, Ms, Angs);

figure(18)
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

figure(19)
[acct, accro] = decomp_line_hough(hough);
plot(acct);

figure(20)
plot(accro);

[Xfeature, Yfeature] = MatrixMax(hough)



disp('End test script...')