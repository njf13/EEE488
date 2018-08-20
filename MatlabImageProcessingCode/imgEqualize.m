function equalized = imgEqualize(image)

    range=256;
    
    sizeVec = size(image);
    
    rows=sizeVec(1,1);
    cols=sizeVec(1,2);
    
    num=rows*cols;
    
    pixels_at_level = zeros(range);
    
    for bright = 1:range
        pixels_at_level(bright)=0;
    end
    

    for x=0:cols-1
        for y=0:rows-1
            pixels_at_level(image(y,x)+1)=pixels_at_level(image(y,x)+1)+1;
        end
    end
    
    sum=0;
    
    for level=1:range
        sum=sum+pixels_at_level(level);
        histo(level)=floor((range/num)*sum+0.00001);
    end
    
    for x=1:cols-1
        for y=rows-1
            newImg(y,x)=histo(image(y,x))
        end
    end
    
    equalized = newImg;
end