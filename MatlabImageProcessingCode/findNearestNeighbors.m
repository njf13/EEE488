function [adjMat, weightMat] = findNearestNeighbors(xvals, yvals, numNeighbors)

    dataStruct = struct();
    dataStruct.neighbors = zeros(length(xvals), numNeighbors);
    adjMat = zeros(length(xvals));
    weightMat = zeros(length(xvals));
    
    for i=1:length(xvals)
        
            xUT = xvals(i);
            yUT = yvals(i);
            dataStruct.point(i,:)=[xUT,yUT];
            for n=1:numNeighbors
                bestDist = 1.0e100;
                for ii=1:length(xvals)
                    if ii==i
                        continue
                    end
                    dist = sqrt((xUT - xvals(ii)).^2 + (yUT - yvals(ii)).^2);
                    if(dist<bestDist)
                        doAdd=1;
                        for iii=1:numNeighbors
                            if dataStruct.neighbors(i,iii)==ii
                                doAdd=0;
                            end
                        end

                        if doAdd==1
                            bestDist = dist;
                            dataStruct.neighbors(i,n)=ii;
                        end
                    end
                    weightMat(i,ii)=dist;
                    adjMat(i,ii)=dist./dist;
                end
            end
        
    end

end