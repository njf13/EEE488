function newDendrite = merge(dend1, dend2, mergeNode)
% A function to allow two dendrites to be combined into one.
% The user will define "mergeNode" which is the node of obj1 (the first
% dendrite) that will be combined with Node 1 of obj2 (the second dendrite)
    dA = zeros(dend1.nodes + dend2.nodes - 1);
    xOffset = dend1.X(mergeNode);
    yOffset = dend1.Y(mergeNode);
    zOffset = dend1.Z(mergeNode);
    
    % The second dendrite should be rotated to match the general trend of
    % the first dendrite. So I will find the angle of the branch feeding
    % the branch of the merge node, and rotate by that angle.
    parentNode = find(dend1.dA(mergeNode,:));
    grandparentNode = find(dend1.dA(parentNode,:));
    deltaY = dend1.Y(grandparentNode)-dend1.Y(parentNode);
    deltaX = dend1.X(grandparentNode)-dend1.Y(parentNode);
    rotAngle = atand(deltaY/deltaX)
    dend2 = dend2.rotate(0,0,rotAngle);
    
    newX = [dend1.X(1:mergeNode-1); dend2.X + xOffset; dend1.X(mergeNode+1:end)];
    newY = [dend1.Y(1:mergeNode-1); dend2.Y + yOffset; dend1.Y(mergeNode+1:end)];
    newZ = [dend1.Z(1:mergeNode-1); dend2.Z + zOffset; dend1.Z(mergeNode+1:end)];
    
    % Transfer over dA of dendrite 1. This has to be done in 4 parts.
    % First transfer top left quadrant
    dA(1:mergeNode,1:mergeNode) = dend1.dA(1:mergeNode,1:mergeNode);
    % Then transfer top right quadrant
    dA(1:mergeNode, mergeNode + dend2.nodes :end) = dend1.dA(1:mergeNode, mergeNode+1:end);
    % Then transfer bottom left quadrant
    dA(mergeNode + dend2.nodes :end,1:mergeNode) = dend1.dA(mergeNode+1:end,1:mergeNode);
    % Then transfer the bottom right quadrant
    dA(mergeNode + dend2.nodes :end, mergeNode + dend2.nodes:end)= dend1.dA(mergeNode+1:end,mergeNode+1:end)
    
    % Transfer over dA of dendrite 2
    dA(mergeNode:mergeNode + dend2.nodes - 1, mergeNode:mergeNode + dend2.nodes - 1) = dend2.dA;
    
    newDendrite = dendrite(dA, newX, newY, newZ);
end