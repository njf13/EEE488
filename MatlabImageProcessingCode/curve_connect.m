function [outImg] = curve_connect(inImg)
    [rows,cols]=size(inImg);
    outImg=zeros(rows,cols);
    [mag,ang]=detect_edges_sobel_2(inImg,3);
    %mag = max_supr(mag,ang);
    
    for x=1:cols-1
        for y=1:rows-1
            if mag(y,x) ~=0
                n=next(y,x,1);
                m=next(y,x,2);
                if(n~=-1 & m~=-1)
                    [px,py]=nextPixel(x,y,n);
                    [qx,qy]=nextPixel(x,y,m);
                end
                outImg(y,x)=abs(ang(py,py)-ang(qy,qx));
            end
        end
    end
end