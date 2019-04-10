%A function to print the geometry in a format that can be input to
%a 4nec2 simulation
function y = necGeometry(obj, length, radius)
    %To convert my XY dendrites to upright antennas, I'll map the
    %initial X to necZ, the intitial Y to necX, and initial Z to necY.
    necY = zeros(obj.nodes, 1);
    necZ = obj.X * length;
    necX = obj.Y * length;
    wireCount = 1;
    y = [];

    for i = 1:obj.nodes
        if(obj.BCT(i) > 0) %check if it's a termination point
            % figure out where the next nodes are, if any.
            branchNodes = find(obj.dA(:,i));

            for j = 1:obj.BCT(i)
                %determine coordinates of next point
                endX = necX(branchNodes(j));
                endY = necY(branchNodes(j));
                endZ = necZ(branchNodes(j));

                str = ["GW", wireCount, "1",necX(i), necY(i), necZ(i), endX, endY, endZ, radius];

                wireCount = wireCount+1;
                disp(join(str, " "));
                y = [y;str];
            end
        end 
    end           
end