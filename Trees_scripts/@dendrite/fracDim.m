% A function to find the fractal dimension of a dendrite using a
% boxcounting algorithm of the plot of the dendrite. To use this,
% you must install the Add-On titled "Hausdorff (Box-Counting)
% Fractal Dimension with multi-resolution calculation". This can be
% found in the MATLAB addon menu.
% It also saves a figure titled "figure.bmp". So if you have
% another file with this title in the operating directory, it will
% save over it.
function y = fracDim(obj)
    figure;
    obj.plot
    axis off;
    saveas(gcf, 'figure.bmp', 'bmp')
    close
    I = imread('figure.bmp');
    close;

    Ibw = ~im2bw(I); %Note that the background need to be 0
    %figure(1);
    imagesc(Ibw);
    colormap gray;


    y = BoxCountfracDim(Ibw) %Compute the box-count dimension
end