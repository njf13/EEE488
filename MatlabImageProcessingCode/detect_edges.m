function [edgeImg] = detect_edges(image)

    template = [2 -1; -1 0];
    
    edgeImg = convolve(image, template);
end