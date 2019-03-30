
disp('starting trees test...')

A = [1 2 0 2 2 0 0 2 0 0];

trees{1} = BCT_tree(A);
plot_tree(1, [1 0 0]);