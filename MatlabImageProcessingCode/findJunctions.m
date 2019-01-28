function [junctions] = findJunctions(inputImage, radius)

    junctions=zeros(size(inputImage));
    
    circ = ceil(2*pi*radius);
    
    chainFunction = zeros([1,circ]);
    
    [imageMaxX, imageMaxY] = size(inputImage);
    
    for cenX=2:imageMaxX-1
        for cenY =2:imageMaxY-1
            
            for i=1:circ
                theta = (i/circ)*2*pi;
                xoff = floor(radius*sin(theta));
                yoff = floor(radius*cos(theta));
                
                if(cenX+xoff>0 && cenX+xoff<imageMaxX && cenY+yoff>0 && cenY+yoff<imageMaxY)
                    chainFunction(i) = inputImage(cenX+xoff,cenY+yoff);
                end
                
            end
            
            maxCount = 0;
            
            if(chainFunction(1)>=chainFunction(2) && chainFunction(1)>=chainFunction(8)&& chainFunction(1)>0)
                maxCount = maxCount + 1;
            end
            
            for i=2:circ-1
                if(chainFunction(i)>=chainFunction(i-1) && chainFunction(i)>=chainFunction(i+1) && chainFunction(i)>0)
                    maxCount = maxCount+1;
                end
            end
            
            if(chainFunction(circ)>=chainFunction(circ-1) && chainFunction(circ)>=chainFunction(1) && chainFunction(circ)>0)
                maxCount = maxCount + 1;
            end
            
            if(maxCount==3)
                junctions(cenX,cenY)=255;
            end
            
        end
    end
end