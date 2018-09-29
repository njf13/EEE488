function [edge_mag, edge_dir] = Edges(img)

%     close all;
%     clear all;
%     home;
%     WORKING_IMAGE_PATH = 'c:\Users\sysadmin\Pictures\CAM00194.jpg';
%     WORKING_IMAGE = imread(WORKING_IMAGE_PATH);
%     WORKING_IMAGE = rgb2gray(WORKING_IMAGE);
%     img=WORKING_IMAGE;
     winsz=3;
    
    
  
    sizeVec = size(img);
    w2=floor(min(sizeVec)/2);
    
    edge_mag = zeros(sizeVec);
    
    edge_dir = zeros(sizeVec);
    
    
    smooth=[];
    for x_win = 0:winsz-1
        smooth(x_win+1) = factorial(winsz-1)./(factorial(winsz-1-x_win)*factorial(x_win));
    end
    
    difff=[];
    for x_win=0:winsz-1
        difff(x_win+1)=pascal_coefficient(x_win,winsz-2)-pascal_coefficient(x_win-1,winsz-2);
    end
    
% 
%     sobel_x = 0;
%     for x_win=1:winsz
%         for y_win=1:winsz
%             sobel_x(y_win,x_win) =  smooth(y_win)*difff(x_win);
%         end
%     end
%       
%     sobel_y=0;
%     for x_win=1:winsz
%         for y_win=1:winsz
%             sobel_y(y_win,x_win) = smooth(x_win)*difff(y_win);
%         end
%     end
    
    sobel_img=zeros(sizeVec);
    
    for x=w2:sizeVec(1,2)-1-w2
        for y=w2:sizeVec(1,1)-1-w2
            x_mag = sobel_x(img(y-w2+1:y+w2+1,x-w2+1:x+w2+1), winsz, smooth, difff);
            y_mag = sobel_y(img(y-w2+1:y+w2+1,x-w2+1:x+w2+1), winsz, smooth, difff);
            
            edge_mag(y,x) = sqrt( x_mag.^2 + y_mag.^2 );
            edge_dir(y,x) = atan2( y_mag, x_mag);
            
        end
    end
%     edge_mag=edge_mag';
%     edge_dir=edge_dir';
end