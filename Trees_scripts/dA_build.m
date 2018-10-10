function [X, Y] = dA_build(dA, branch_angle_degrees, branch_length_initial)

% Create some vectors to store data
dA_build = ones(1,length(dA));
A = dA_build*dA;
X = zeros(length(A),1);
Y = zeros(length(A),1);
node_angle = zeros(length(A),1);
branch_length = zeros(length(A),1);
branch = [0;0]; % temporarily hold the indexes of nodes that branch from a B point

% Cacluate the branch order vector
BO_calc = [1:length(A)]';
BO_vector = dA*BO_calc;

% convert the branch angle to radians
branch_angle = branch_angle_degrees*pi/180; 

% factor to scale each branch by after a node
branch_scaling = 1;

% Define starting node and angle
X(1) = 0;
Y(1) = 0;
node_angle(1) = 0;


for i = 1:length(A)
   branch_length(i) = branch_length_initial*branch_scaling^BO_vector(i);
    
   if (A(i) == 1)
       node_angle(i+1) = node_angle(i); %  Continue at same angle
       X(i+1) = branch_length(i)*cos(node_angle(i)) + X(i);
       Y(i+1) = branch_length(i)*sin(node_angle(i)) + Y(i);
   elseif (A(i) == 2)
       % Find branch indexes by finding index of non-zero elements of the
       % column corresponding to this node in the Directed Adjacency Matrix
       branch = find(dA(:,i));
       
       %I'm assuming that the first branch always turns left, and the
       %second always turns right. I think this is part of the BCT formalism
       node_angle(branch(1)) = node_angle(i) + branch_angle/2;
       node_angle(branch(2)) = node_angle(i) - branch_angle/2;
       
       for j = 1:2
           X(branch(j)) = X(i) + branch_length(i)*cos(node_angle(branch(j)));
           Y(branch(j)) = Y(i) + branch_length(i)*sin(node_angle(branch(j)));
       end
   end
end