function capValues = setC(obj,  calcMethod, inputVal) 
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
        inputVal = 100e-6;
    end


    switch calcMethod

        case 'd' % C halves at each branch.
            capValues = inputVal*0.5.^(obj.branchOrder-1);
            capValues(1) = 0;
        case 'e' % Input error
            disp("Error!");
            disp("The input must be one of the following:")
            disp("- A vector with the same number of entries as there are nodes of the dendrite");
            disp("- A single character from this list: 'd'");
            capValues= [];

        case 'c' % Constant C
            capValues = inputVal*ones(obj.nodes,1);
        case 'v' % Set C based on an input vector
            capValues = inputVal;
        case 'dist' % Calculate the R based on the distance between points
                    capValues = zeros(obj.nodes,1);

                    for ii = 2:obj.nodes
                        % Find parent node
                        parent = find(obj.dA(ii,:));
                        % Find distance beween the points.
                        deltaX = obj.X(ii)-obj.X(parent);
                        deltaY = obj.Y(ii)-obj.Y(parent);
                        distance = norm([deltaX deltaY]);
                        
                        if(distance == 0)
                            
                            capValues(ii) = inputVal/1000;
                        else
                            % dividing by 10 is really arbitrary. I used
                            % that to allign better with the other methods.
                            % If you have an input value of 100, then a ten
                            % unit long branch will be 100 ohms.
                            capValues(ii) = (inputVal/10)*norm([deltaX deltaY]);
                        end
                    end

        otherwise
            disp("Error!");
            disp("The input must be one of the following:")
            disp("- A vector with the same number of entries as there are nodes of the dendrite");
            disp("- A single character from this list: 'd'");
    end

    obj.C = capValues;
end