function [n_edg] = hysteresis_threshold(n_edg, upp, low)
    for x=1:cols(n_edg)-2
        for y=1:rows(n_edg)-2
            if((n_edg(y,x)>=upp)&(n_edg(y,x)~=255)):
                n_edg(y,x)=255;
                n_edg = connectivity_analysis(x,y,n_edg,low);
            end
        end
    end
    
end