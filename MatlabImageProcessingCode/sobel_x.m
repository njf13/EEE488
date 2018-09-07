function [sobel_x]=sobel_x(pic, winsz, smooth, difff)
    output=0;
    
    for x_win=1:winsz
        for y_win=1:winsz
            output=output+smooth(y_win).*difff(x_win).*double(pic(y_win,x_win));
        end
    end
    sobel_x=output;
end