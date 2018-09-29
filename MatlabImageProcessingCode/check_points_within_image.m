function [inImg] = check_points_within_image(xc, yc, pic)
    if(xc>=1)*(xc<=cols(pic)-2)*(yc>=1)*(yc<=rows(pic)-2)
        inImg= 1;
    else
        inImg= 0;
    end
end