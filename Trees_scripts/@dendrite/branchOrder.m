% A function to calculate the branch order of each node. The
% beginning will have an order of 0. The branch order of each
% subsequent node will be calculated by finding the branch order of
% the of the parent node, and adding 1 to it.
function y = branchOrder(obj)
    y = zeros(obj.nodes, 1);

    for i = 2:obj.nodes
        parentNode = find(obj.dA(i,:));
        y(i) = y(parentNode)+1;
    end            
end