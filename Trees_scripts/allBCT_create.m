% Plot all trees with a given number of nodes
clear

start_trees
nodes = 10;
branch_angle = 60;
branch_length = 10;

[BCTs all_trees] = allBCTs_tree(nodes);
X = zeros(nodes,1);
Y = zeros(nodes,1);
Z = zeros(nodes,1); %  Some functions require a Z vector

% Count the number of trees that actually are plotted
tree_count = 1;

for i = 1:length(BCTs)
    % Don't plot BCTs that have adjacent C terms
    consecutive_Cs = false;
    for j = 1:(nodes-1)
        if(BCTs(i,j) == 1 && BCTs(i,j+1) == 1)
            consecutive_Cs = true;
        end
    end
    
    %only plot if consecutive_Cs is false AND the first node is not a
    %branch
    if(~(consecutive_Cs|BCTs(i,1)==2))
        %dA_struct = BCT_tree(BCTs(i,:),'-dA');
        %trees{j}.dA = full(dA_struct.dA);
        trees{tree_count} = all_trees{i};
        
        [trees{tree_count}.X, trees{tree_count}.Y] = dA_build(trees{tree_count}.dA, branch_angle, branch_length);
        trees{tree_count}.Z = Z;
        figure
        plot_tree(trees{tree_count});
        tree_count=tree_count+1;
    end
end