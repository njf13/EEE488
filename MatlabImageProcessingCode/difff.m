function difff=difff(x_win, winsize)
    difff = pascal(x_win, winsize-2) - pascal(x_win-1, winsize-2);
end