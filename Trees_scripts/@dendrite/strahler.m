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