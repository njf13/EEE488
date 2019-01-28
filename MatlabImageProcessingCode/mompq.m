function [moment] = mompq(inputImg, p, q)

    [maxX,maxY]=size(inputImg);
    cenX=maxX/2;
    cenY=maxY/2;
    moment=0.0;
    for x=1:maxX
        for y=1:maxY
            moment=moment+ (double((x-cenX).^p) * double((y-cenY).^q) * double(inputImg(x,y)));
        end
    end
end