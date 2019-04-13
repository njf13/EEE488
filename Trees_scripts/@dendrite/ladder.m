% Create a function to generate the Ladder network that corresponds
% to a given dendrite. This is a network that takes one point as an
% anchor or ground point, and extends a large trunk in one
% direction from this point. All of the other nodes in the set will
% be connected to the trunk by a perpendicular line.
function y = ladder( obj)
    X = obj.X;
    Y = obj.Y;
    Z = obj.Z;
    BCT = obj.BCT;

    % Use this line to remove all branching points
    removeCount = 0;
    for i = 1:length(X)
        if(BCT(i)==2)
            X(i-removeCount)=[];
            Y(i-removeCount)=[];
            Z(i-removeCount)=[];
            removeCount = removeCount+1;
        end
    end

    minDist = inf;

    minAngle = 0;
    GND = [X(1), Y(1), 0];
    initialNodes = length(X);
    dA = zeros(initialNodes*2-1);

    for theta = 0:0.1:pi
        distSum = 0;

        linePt = [cos(theta), sin(theta), 0]; % find another point on line
        a = linePt - GND;
        a_norm = norm(a);

        for i = 2:length(X)
            pt = [X(i), Y(i), 0];
            b = pt - linePt;
            d = norm(cross(a,b))/a_norm;
            distSum = distSum + d;
        end

        if(distSum < minDist)
            minDist = distSum;
            minAngle = theta;
        end
    end

    trunkBranchesX = zeros(length(X)-1,1);
    trunkBranchesY = trunkBranchesX;

    a = [cos(minAngle), sin(minAngle), 0];

    for i = 2:length(X)
        b = [X(i), Y(i), 0] - GND;
        l = dot(a,b);
        trunkPoint = (l*a)+GND;
        trunkBranchesX(i-1) = trunkPoint(1);
        trunkBranchesY(i-1) = trunkPoint(2);
    end

    % Fill directed adjacency matrix
    for i = 1:length(trunkBranchesX)
        dA(i+1, i+initialNodes) = 1;
    end

    % This assumes that the GND point is the leftmost point. 
    % This contradicts the entire purpose. I need to include 
    % the GND point in the list of Trunk Nodes when I find the 
    % index of the points.
    [~, ind] = sort(trunkBranchesX);


    % Now place an entry in the dA connecting each of the trunk points in this order.
    dA(find(ind==1)+initialNodes,1) = 1;

    for i = 2:length(ind)
        dA(find(ind==i)+initialNodes, find(ind==i-1)+initialNodes)=1;
    end

    % The dendrite is created at the end of the function so that
    % all of the constructor operations are performed on the
    % complete data.
    y = dendrite(dA, [X; trunkBranchesX], [Y; trunkBranchesY], []);
    y.setR('dist',100);
end