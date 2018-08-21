function equalized = imgEqualize(image)

    histo = imgHistogram(image);
    normedHisto = histNormalize(histo);
    
    [rows,cols, channels] = size(image);
    
    for x=1:cols
        for y=1:rows
            newImg(y,x)=normedHisto(max(image(y,x),1));
        end
    end
    
    equalized = newImg;
end