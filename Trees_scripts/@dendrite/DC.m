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