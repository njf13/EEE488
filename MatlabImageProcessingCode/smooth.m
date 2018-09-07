function [smooth]=smooth(winsize, x_win)
    smooth = factorial(winsize-1)./(factorial(winsize-1-x_win).*factorial(x_win));
end