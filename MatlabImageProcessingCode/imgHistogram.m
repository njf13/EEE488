function imghistogram = imgHistogram(image)

    [rows, cols]=size(image);
    
    pixels_at_level=zeros(1,256);
    
    for bright=1:256
        pixels_at_level(1,bright)=0;
    end
    
    for x=1:cols
        for y=1:rows
            level=image(y,x);
            pixels_at_level(1,level+1)=pixels_at_level(1,level+1)+1;
        end
    end
    
    imghistogram = pixels_at_level;
end