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
        function y = plot( obj)
            fig = figure;
            hold;
            for i = 1:length(obj.dA)
                connections = find(obj.dA(:,i));

                for j = 1:length(connections)

                    plot([obj.X(i) obj.X(connections(j))], [obj.Y(i) obj.Y(connections(j))],'-k','LineWidth',1)
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
            startXYZ = [obj.X, obj.Y, obj.Z];

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
            y = zeros(1,obj.nodes);
            
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
            
            disp(str);
            y = [y; str];
            str = ['* Netlist created on ' , date(),"","","","","",""];
           
            disp(str);
            y = [y; str];
            fprintf('\n')
            
            % Place sources at all of the termination nodes.
            str = ["Vsource ", "Vsource ", "gnd ", "PULSE (0 10 0 1n 1n 49n 100n)", "", "", "", ""];
            disp(join(str,''));
            y = [y;str];
            
            % Place a 0V source from the beginning node to GND. Probably an
            % inefficent way to do this, but it simplifies the code for
            % now.
            str = ["Vgnd ", "n1 ", "gnd ", "0", "", "" ,"", "" ];
            disp(join(str,''));
            y = [y;str];            
            
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
                    
                    str = ["c", branchCount, " n" , daughterNodes(j), " gnd ",c0*0.5^BO(i),"u",""];
                    disp(join(str,''));
                    y = [y;str];
                    
                    branchCount = branchCount+1;
                end
            end

            
            % Add analysis commands here
            % All analysis commands except DC op will have an asterisk at
            % the beginning to "comment" them out. That way the person
            % doing the analysis can remove the asterisk for the desired
            % analysis.
            str = ["\n.op", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
            
            str = ["*.tran 1ns 1u", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
            
            str = ["*.AC dec 10 10 1G", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
            
            % Add .end here
            str = ["\n.end", "","","","","","",""];
            disp(join(str,''));
            y = [y;str];
        end
        
<<<<<<< HEAD
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
    end
end
=======
        % Create a function to generate the Ladder network that corresponds
        % to a given dendrite. This is a network that takes one point as an
        % anchor or ground point, and extends a large trunk in one
        % direction from this point. All of the other nodes in the set will
        % be connected to the trunk by a perpendicular line.
        function y = ladder( obj)
            % Start by copying the X, Y, Z coordinates. Create extra points
            % to represent the points where each of the branch nodes
            % connects to the main trunk.
            X = [obj.X; zeros(obj.nodes - 1, 1)];
            Y = [obj.Y; zeros(obj.nodes - 1, 1)];
            Z = [obj.Z; zeros(obj.nodes - 1, 1)];
            
            % Each of the 
            dA = zeros(length(X));
            
            % The dendrite is created at the end of the function so that
            % all of the constructor operations are performed on the
            % complete data.
            y = dendrite(dA, X, Y, Z);
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
>>>>>>> dc49fb6d96ce05cb27d4902db5b584de1567bd12

            Ibw = ~im2bw(I); %Note that the background need to be 0
            %figure(1);
            imagesc(Ibw);
            colormap gray;
            

            y = BoxCountfracDim(Ibw) %Compute the box-count dimension
        end
    end
end