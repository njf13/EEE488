function [newpic]=zero_crossing_detector(pic)
    sizeVec=size(pic);
    int=[];
    for x=1:sizeVec(1,2)-2
        for y=1:sizeVec(1,1)-2
            for x1=x-1:x
                for y1 =y-1:y
                    int(0)=int(0)+pic(y1,x1);
                end
            end
            
            for x1=x-1:x
                for y1=y:y+1
                    int(1)=int(1)+pic(y1,x1);
                end
            end
            
            for x1=x:x+1
                for y1=y-1:y
                    int(2)=int(2)+pic(y1,x1);
                end
            end
            
            for x1=x:x+1
                for y1=y:y+1
                    int(3)=int(3)+pic(y1,x1);
                end
            end
            
            maxval = max(int);
            minval = min(int);
            
            if maxval>0 & minval<0
                newpic(y,x)=255;
            else
                newpic(y,x)=0;
            end
        end
    end
    
end