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
                    labelText(i)= "n"+i;
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