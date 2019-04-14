function [weightMat] = findNearestNeighbors(xvals, yvals)

    weightMat = zeros(length(xvals));
    
    for i=1:length(xvals) 
            xUT = xvals(i);
            yUT = yvals(i);
            for ii=1:length(xvals)
                if ii==i
                    continue
                end
                dist = sqrt((xUT - xvals(ii)).^2 + (yUT - yvals(ii)).^2);
                weightMat(i,ii)=dist;
                
            end 
    end
end