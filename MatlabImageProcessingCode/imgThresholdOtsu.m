function thresholded = imgThresholdOtsu(image)

    
    [rows, cols]=size(image);
    
    histo = imgHistogram(image);
    
    for i=1:max(size(histo))
        
        total = total + histo(i)
        
    end


    sumB=0;
    
    omegaB=0;
    
    maximum = 0;
    
    sum1= dot( (0:max(size(histo)), histo));
    
    for ii=1:max(size(histo))
        omegaB=omegaB+histo(ii);
        omegaF=total-omegaB;
        if(omegaB==0||omegaF==0)
            continue;
        end
        
        sumB=sumB + (ii-1)*histo(ii);
        mF = (sum1 - sumB) / omegaF;
        between = omegaB * omegaF * ((sumB/omegaB) - mF) * ((sumB/omegaB) - mF);
        if(between>=maximum)
            level = ii;
            maximum = between;
        end
    end

end