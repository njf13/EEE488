function rValues = setR(obj,  calcMethod, inputVal) 
% setR assigns resistance values to each edge in the dendrite.
%   setR( calcMethod, inputVal)

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
                    rValues = inputVal*2.^(obj.branchOrder-1);
                    rValues(1) = 0;
                case 'e' % Input error
                    disp("Error!");
                    disp("The input must be one of the following:")
                    disp("- A vector with the same number of entries as there are nodes of the dendrite");
                    disp("- A single character from this list: 'd'");
                    rValues= [];
                case 'c' % Constant R
                    rValues = inputVal*ones(obj.nodes,1);
                case 'v' % Set R based on an input vector
                    rValues = inputVal;
                otherwise
                    disp("Error!");
                    disp("The input must be one of the following:")
                    disp("- A vector with the same number of entries as there are nodes of the dendrite");
                    disp("- A single character from this list: 'd'");
            end
            
            obj.R = rValues;
        end