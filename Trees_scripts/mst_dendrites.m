clear
start_trees;

n = 100;

X = 10*rand(n,1)+1;
X = [0;X];
Y = 10*rand(n,1)+1;
Y = [0;Y];
Z = zeros(size(X));

tree = MST_tree (1, X, Y, Z, 0.5, 50, [], [], '-b')

mstDendrite = dendrite(tree.dA, tree.X, tree.Y, tree.Z);
mstDendrite.plot;
lad = mstDendrite.ladder;
lad.plot;

mstDendrite.setR('dist',100);
mstDendrite.setC('dist',100e-9);
str = mstDendrite.netlist;
str = join(str, '');
f1 = fopen('05_mstDendrite.sp', 'wt');
str2 = join(str,'\n');
fprintf(f1, str2);
fclose(f1)


lad.setR('dist',100);
lad.setC('dist',100e-9);
str = lad.netlist;
str = join(str, '');
f1 = fopen('05_ladder.sp', 'wt');
str2 = join(str,'\n');
fprintf(f1, str2);
fclose(f1)

save('05_mst_ladder.mat')