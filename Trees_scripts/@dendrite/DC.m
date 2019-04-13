function [vNodes currents] = DC( obj, Vdd)
            terminations = find(obj.BCT==0);
            
            RMatrix = zeros(obj.nodes-1, obj.nodes);
            sumV = [];
            if(~exist('Vdd','var'))
                Vdd = 10;
            end
            
            % Check if Vdd vector is only 1 element. If so, assume that
            % this voltage is applied to all of the terminals.
            if(length(Vdd)==1)
                Vsources = zeros(obj.nodes,1);
                Vsources(obj.BCT==0) = Vdd;
            end
            
            if(isempty(obj.R))
                obj.setR;
            end
            
            conductances = zeros(obj.nodes);
            % This assumes that the first node is ground.
            conductances(1,1) = 1;
            
            % Go through each of the nodes, and fill in the conductances
            % matrix for each row. For the column of the node, add the
            % inverses of the resistances attached to that node. For the
            % columns of the attached nodes subtract the inverses of the
            % resistances connecting to those nodes.
            % For termination nodes just put a 1 in the column of the node,
            % and fill in the currents vector with the value of the
            % corresponding voltage source.
            currentsInOut = Vsources;
            
            % Also construct a Vdrops matrix to keep track of the nodes
            % which should be subtracted to find the voltage drops. After
            % finding the nodal voltage, we can multiply this matrix by the
            % vNodes, and then divide by the individual R values to find
            % the current through each branch.
            vDrops = zeros(obj.nodes);
            
            for ii = 2:obj.nodes
                parent = find(obj.dA(ii,:));
                vDrops(ii,ii) = 1;
                vDrops(ii,parent) = -1;
                
                if(obj.BCT(ii) == 0)
                    % If the node is a termination, just put a 1 in the
                    % conductances, as the voltage at this node is known.
                    conductances(ii,ii) = 1;
                else
                    children = find(obj.dA(:,ii));
                    

                    conductances(ii,ii) = conductances(ii,ii)+(1/obj.R(ii));
                    conductances(ii,parent) = conductances(ii,parent)-(1/obj.R(ii));
                    
                    
                    for jj = 1:length(children)
                        conductances(ii,ii) = conductances(ii,ii)+(1/obj.R(children(jj)));
                        conductances(ii,children(jj)) = conductances(ii,children(jj))-(1/obj.R(children(jj)));
                    end
                end
            end

            vNodes = conductances\currentsInOut;
            
            
            vDrops = vDrops*vNodes;
            currents = vDrops./obj.R;
            % This part assumes that the first node is a continuation to one
            % node. So it just sets the node as the highest current in the
            % network.
            currents(1) = max(currents);
            
        end