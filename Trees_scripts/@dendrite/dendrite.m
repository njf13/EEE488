classdef dendrite < handle
    properties
        %X, Y, and Z coordinates. I will leave Z empty for now. 
        %I'll probably create an overloaded constructor if we want
        %non-planar dendrites.
        X = [];
        Y = [];
        Z = [];
        %Directed Adjacency Matrix
        dA = [];
        %BCT string where 0=T (Termination), 1=C (Continuation), and 2=B (Branch);
        BCT = [];
        %Store the number of nodes. Not sure if it's useful but whatever.
        nodes = 0;
        
        % Store a vector indicating the resistance of each branch.
        R = [];
    end
    methods
        %Constructor Function
        function obj = dendrite(dA_, X_, Y_, Z_)
            obj.dA = full(dA_);
            obj.X = X_;
            obj.Y = Y_;
            if( isempty(Z_))
                obj.Z = zeros(length(X_),1);
            else
                obj.Z = Z_;
            end
            obj.nodes = length(obj.X);
            obj.BCT = ones(1,obj.nodes)*obj.dA;
            obj.R = obj.setR;
        end
        
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
        
        % A function to plot a dendrite
        function y = plot( obj, overlay, nodeLabels)
                       
            fig = figure;
            hold;
            for i = 1:length(obj.dA)
                connections = find(obj.dA(:,i));

                for j = 1:length(connections)
                    plot([obj.X(i) obj.X(connections(j))], [obj.Y(i) obj.Y(connections(j))],'-k','LineWidth',1);
                end
            end
            
            % Check if the overlay vector exists and if so, plot the points
            % representing the values.
            % That way the user can still call the plot
            % function with no arguments if they just want a normal plot.
            if(exist('overlay', 'var'))
                % Find max and min values of the vector.
                high = max(overlay);
                low  = min(overlay);
                
                % Now normalize all of the overlay values to a range of 0
                % to 1.
                overlayNormalized = (1/(high-low))*(overlay - low);
                
                % Map these normalized values to rbg by finding the
                % distance of each value from 1 (r), 0.5 (g), and 0 (b).
                % This approach is from https://codereview.stackexchange.com/questions/64708/calculation-of-rgb-values-given-min-and-max-values
                               
                % Plot values
                for i = 1:obj.nodes
                    rgb = [overlayNormalized(i) norm(overlayNormalized(i)-0.5) norm(overlayNormalized(i)-1)];
                    plot(obj.X(i), obj.Y(i), 'o', 'MarkerFaceColor', rgb,'MarkerEdgeColor', rgb)
                end
            end
            
            % The second optional parameter is a label for each of the
            % nodes. You may want to label each node with the values in the
            % overlay vector, or you may want to just label the number of
            % the nodes.
            if(exist('nodeLabels', 'var'))
                switch nodeLabels
                    case 'n' % n for nodes
                        for i = 1:obj.nodes
                            labelText(i)= 'n'+i;
                        end
                        
                    case 'o' % o for overlay
                        labelText = overlay;
                    otherwise
                        labelText = [1:obj.nodes]';
                end
                
                for i = 1:obj.nodes
                    text(obj.X(i)+1, obj.Y(i)+1, num2str(labelText(i),4));
                end
                    
            end
            
            xlim([min(obj.X)-1 max(obj.X)+1]);
            ylim([min(obj.Y)-1 max(obj.Y)+1]);            
            axis equal;
            axis off;
            hold off;
            y = fig;
        end
        
        % A function to rotate the dendite in X, Y, and Z. 
        function y = rotate( obj, X_degrees, Y_degrees, Z_degrees)
            % Will rotate X then Y then Z. If you want to rotate in a
            % different order, you'll need to run the function more than
            % one time.
            startXYZ = [obj.X, obj.Y, obj.Z]
            RX = [1 0 0;
                0 cosd(X_degrees) sind(X_degrees);
                0 -sind(X_degrees) cosd(X_degrees);];
            
            RY = [cosd(Y_degrees) 0 -sind(Y_degrees);
                0 1 0;
                sind(Y_degrees) 0 cosd(Y_degrees);];
            
            RZ = [cosd(Z_degrees) sind(Z_degrees) 0;
                -sind(Z_degrees) cosd(Z_degrees) 0;
                0 0 1];
            
            endX  = zeros(length(obj.X),1);
            endY = endX;
            endZ = endX;
            
            for i = 1:length(endX)
                size(RX)
                size(RY)
                size(RZ)
                size(startXYZ)
                startXYZ'
                endXYZ = RZ*RY*RX*startXYZ( i,:)';
                endX(i) = endXYZ(1);
                endY(i) = endXYZ(2);
                endZ(i) = endXYZ(3);
            end
            obj.X = endX;
            obj.Y = endY;
            obj.Z = endZ;
        end
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
        
        % A function to construct a netlist compatible with HSPICE
        % There are currently no arguments. Future versions may have
        % arguments for the beginn
        function y = netlist( obj)
            y = [];
            branchCount = 1;
            BO = obj.branchOrder;
            r0 = 100; % start with a resistance of 100?
            c0 = 100; % µF
            
            str = ["* Netlist for Tree","","","","","","",""];
            
            disp(join(str,''));
            y = [y; str];
           
            str = ['* Netlist created on ' , date(),"","","","",""];
            disp(join(str,''));
            y = [y; [str, "\n"]];
           
            str = [".param maxV = 10","","","","","", ""];
            disp(join(str,''));
            y = [y; [str, "\n"]];
            
            % Add analysis commands here
            % All analysis commands except DC op will have an asterisk at
            % the beginning to "comment" them out. That way the person
            % doing the analysis can remove the asterisk for the desired
            % analysis.
            str = [".op", "","","","","",""];
            disp(join(str,''));
            y = [y;["\n", str]];
            
            % Place sources at all of the termination nodes.
            str = ["Vsource ", "Vsource ", "gnd ", "{maxV} AC 1", "", "", "", ""];
            disp(join(str,''));
            y = [y;str];
            
            str = ["*.AC dec 10 10 1G", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
            
            str = ["*.tran 1ns 1", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
            
            % Create a source for the transisent analysis.
            str = ["*Vsource ", "Vsource ", "gnd ", "PULSE (0 {maxV} 0 1n 1n 99m 200m)", "", "", "", ""];
            disp(join(str,''));
            y = [y;str];
            
            % Place sources at all of the termination nodes.
            str = ["*.measure tran tdlay TRIG V(Vsource) VAL = 0.5*maxV RISE=3 TARG V(*) VAL = 0.5*maxV RISE=3", "", "", "", "","","",""];
            disp(join(str,''));
            y = [y;str];
            
            
            
            
            % Place a 0V source from the beginning node to GND. Probably an
            % inefficent way to do this, but it simplifies the code for
            % now.
            str = ["Vgnd ", "n1 ", "gnd ", "0", "" ,"", "" ];
            disp(join(str,''));
            y = [y;[str, "\n\n"]];            
            
            for i = 1:obj.nodes
                daughterNodes = find(obj.dA(:, i));
                for j = 1:length(daughterNodes)
                    % If the other node is a termination point, it should
                    % connect to Vsource, instead of a n# node.
                    if(obj.BCT(daughterNodes(j))== 0)
                        node2 = " Vsource";
                    else
                        node2 = " n" + daughterNodes(j);
                        node2 = join(node2,'');
                    end
                    
                    str = ["r", branchCount, " n" , i, node2, " ", r0*2^BO(i), ""];
                    disp(join(str,''));
                    y = [y;str];
                    
                    str = ["c", branchCount, node2, " gnd ",c0*0.5^BO(i),"u", "",""];
                    disp(join(str,''));
                    y = [y;str];
                    
                    branchCount = branchCount+1;
                end
            end
            
            
            
            % Add .end here
            str = [".end", "","","","","",""];
            disp(join(str,''));
            y = [y;["\n", str]];
        end
        

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
        end
        
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
        
        function y = voronoi(obj)
            obj.plot;
            hold
            voronoi(obj.X, obj.Y);
        end
        
        function y = strahler(obj)
            % Create a strahler vector with the same number of elements as the dendrite has nodes. 
            % Start this vector with all zeros, because a strahler number 
            % cannot be zero. So if any zeros remain at the end, it means 
            % there was an error. It could also be a node that is not attached to anything.
            
            strahler = zeros(obj.nodes, 1);
            % Set all of the strahler values of the termination (BCT==0) nodes to 1.
            strahler(obj.BCT==0) = 1;
            % Now I want to scroll through all of the other nodes until 
            % they are all filled. In a properly constructed dendrite, 
            % the nodes near the termination points will be closer to the end. 
            % So I'll scroll backwards through the nodes.
            while(sum(strahler==0)>0)
                for i = obj.nodes:-1:1
                    if(strahler(i)==0)
                        branchStrahlers = strahler(find(obj.dA(:,i)));

                        % First check if there's only one element of the branchStrahlers vector
                        % If so, just make the ith strahler equal to the branchStrahler value.
                        if(length(branchStrahlers)==1)
                            strahler(i) = branchStrahlers(1);
                        %Check if each of the branches has the same strahler number.
                            % If so then the ith strahler number is one greater.
                            % Unless it's zero, in which case, just keep it zero for now.
                        elseif( branchStrahlers(1) == branchStrahlers(2))
                                strahler(i) = branchStrahlers(1);
                                if(strahler(i)>0)
                                    strahler(i) = strahler(i)+1;
                                end

                        else
                            % IF the strahlers of the branch don't match, but aren't zero, then set the ith strahler to the 
                            % max strahler of the branches.
                            if(sum(branchStrahlers==0)>0)
                                strahler(i) = 0;
                            else
                                strahler(i) = max(branchStrahlers);
                            end
                        end
                    end
                end
            end
            
            y = strahler;
        end
        
        function y = setR(obj,  calcMethod, inputVal) 
            
            if(~exist('calcMethod', 'var'))
                calcMethod = 'd';
            elseif(~ischar(calcMethod))
                if(length(calcMethod)~=obj.nodes)
                    calcMethod = 'e';
                else
                    inputVal = calcMethod;
                    calcMethod = 'v';
                end
            end
            
            if(~exist('inputVal','var'))
                inputVal = 100;
            end
            
            
            switch calcMethod
                case 'd' % R doubles at each branch.
                    y = inputVal*2.^(obj.branchOrder-1);
                    y(1) = 0;
                case 'e' % Input error
                    disp("Error!");
                    disp("The input must be one of the following:")
                    disp("- A vector with the same number of entries as there are nodes of the dendrite");
                    disp("- A single character from this list: 'd'");
                    y= [];
                case 'c' % Constant R
                    y = inputVal*ones(obj.nodes,1);
                case 'v' % Set R based on an input vector
                    y = inputVal;
                otherwise
                    disp("Error!");
                    disp("The input must be one of the following:")
                    disp("- A vector with the same number of entries as there are nodes of the dendrite");
                    disp("- A single character from this list: 'd'");
            end
            
            obj.R = y;
        end
        
        function y = DC( obj, Vdd)
            terminations = find(obj.BCT==0);
            
            RMatrix = zeros(obj.nodes-1, obj.nodes);
            sumV = [];
            if(~exist('Vdd','var'))
                Vdd = 10;
            end
            
            if(isempty(obj.R))
                obj.setR;
            end

            for i =1:length(terminations)
                startNode= terminations(i);
                currentNode = startNode;
                drops = zeros(1,obj.nodes);

                while(currentNode ~= 1)
                    nextNode= find(obj.dA(currentNode,:)); %Find the node that feeds the current node.
                    drops(currentNode) = obj.R(currentNode);
                    currentNode = nextNode;
                end

                RMatrix(i,:) = drops;
                sumV =[sumV;Vdd];
            end
            
            branches = find(obj.BCT==2|obj.BCT==1);

            for j = 1:length(branches)
                RMatrix(i+j,:) = obj.dA(:,branches(j))';
                RMatrix(i+j,branches(j)) = -1;
                sumV = [sumV; 0];
            end
            
            currents = RMatrix\sumV;

            Vdrops = currents.*obj.R;
            
            
            dropMat = zeros(obj.nodes);

            for i = 1:obj.nodes
                currentNode = i;
                drops = zeros(1,obj.nodes);

                while(currentNode ~= 1)
                    nextNode= find(obj.dA(currentNode,:)); %Find the node that feeds the current node.
                    drops(currentNode) = 1;


                    currentNode = nextNode;
                end

                dropMat(i,:) = drops;
            end

            nodeV = dropMat*Vdrops;
            
            y =nodeV;

        end
    end
end
 