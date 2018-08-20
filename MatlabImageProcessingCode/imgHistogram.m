function imghistogram = imgHistogram(image)

    [rows, cols]=size(image);
    
    pixels_at_level=zeros(256);
    
    for bright=1:255
        pixels_at_level(bright)=0;
    end
    
    for x=1:cols
        for y=1:rows
            level=image(y,x);
            pixels_at_level(level+1)=pixels_at_level(level+1)+1;
        end
    end
    
    imghistogram = pixels_at_level;
end