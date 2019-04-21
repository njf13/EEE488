% This script will comare the total power required to maintain 10V at the
% leaf nodes of a dendrite with various configurations. One will be a
% dendrite with the R value doubling at each branch, another will keep the
% resistance values constant for all branches, another will base it on the
% length of the branch (for the Trees dendrites I created these two will
% be the same), and another will be the ladder network with each R value
% set by the length of the branch.

clear

load dendrites10.mat;
n = 16;
d1 = dendrite(trees{n}.dA, trees{n}.X, trees{n}.Y, []);

lad1 = d1.ladder;
d1.