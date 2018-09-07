function [sobel_y]=sobel_y(pic,  winsz, smooth, difff)
    output=0;
   
    for x_win=1:winsz
        for y_win=1:winsz
            output= output+ smooth(x_win).*difff(y_win).*double(pic(y_win,x_win));
        end
    end
    sobel_y=output;
end