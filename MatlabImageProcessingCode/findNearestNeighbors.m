function [weightMat] = findNearestNeighbors(xvals, yvals)

    weightMat = zeros(length(xvals));
    
    dendriteMedian = [median(xvals),median(yvals)];
    dendriteMean = [mean(xvals), mean(yvals)];
    
    for i=1:length(xvals) 
            xUT = xvals(i);
            yUT = yvals(i);
            phi = atan2(  (dendriteMedian(1,1) - xUT),(dendriteMedian(1,2) - yUT) );
            gamma = atan2( (dendriteMean(1,1) - xUT),(dendriteMean(1,2) - yUT)  );
            for ii=i:length(xvals)
                if ii==i
                    continue
                end
                dist = sqrt((xUT - xvals(ii)).^2 + (yUT - yvals(ii)).^2);
                neighborDistToMean = sqrt((xvals(ii) - dendriteMean(1,1)).^2 + (yvals(ii) - dendriteMean(1,2)).^2);
                theta = atan2(  (xvals(ii) - xUT), (yvals(ii) - yUT));
                
                dist = 2*dist + neighborDistToMean;
                
                weightMat(i,ii)=dist;
                weightMat(ii,i)=dist;
            end 
    end
end