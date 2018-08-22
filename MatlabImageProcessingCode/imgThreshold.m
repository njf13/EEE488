function [newImg]=imgThreshold(image, level, maximum)

sizeVec=size(image);
newImg=zeros(sizeVec);

imageMax =max( max(max(image)));

for i=1:sizeVec(1,1)
    for j=1:sizeVec(1,2)
        if(image(i,j)<level)
            newImg(i,j) = 0;
            continue;
        end
        if(image(i,j)>level)
            newImg(i,j)=maximum;
            continue;
        end
        
        newImg(i,j) = double(image(i,j)+level)*double(maximum)/double(imageMax);
        
    end
end
        


end