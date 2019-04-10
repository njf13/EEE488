% A function to create the nearest-neighbor directed adjacency
% matrix from a set of 2-D locations where the second row of
% locations is the x-coordinate and the first row of locations is
% the y-coordinate
function dA = nearestNeighborDA( locations)
    dASize = max(size(locations)); %use maximum size to find size of dA

    dA = zeros(dASize);

    for i=1:2
        for j=1:dASize
            for ii=1:2
                for jj=1:dASize
                end
            end
        end
    end
end