function [nedg] = connectivity_analysis(x,y,nedge,low)
    for x1 = x-1:x+1
        for y1=y-1:y+1
            if (nedg(y1,x1)>=low)&(nedg(y1,x1)~=255) & check_points_within_image(x1,y1,nedg)
                nedg(y1,x1)=255;
                nedg = connectivity_analysis(x1,y1,nedg,low);
            end
        end
    end
                
end