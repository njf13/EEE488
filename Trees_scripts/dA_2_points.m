function [X, Y] = dA_2_points(dA, branch_angle_degrees, branch_length)

% Create some vectors to store data
dA_2_BCT = ones(1,length(dA));
A = dA_2_BCT*dA;
X = zeros(length(A),1);
Y = zeros(length(A),1);
node_angle = zeros(length(A),1);
branch = [0;0]; % temporarily hold the indexes of nodes that branch from a B point

%define dendrite properties
branch_angle = branch_angle_degrees*pi/180; 


% Define starting node and angle
X(1) = 0;
Y(1) = 0;
node_angle(1) = 0;


for i = 1:length(A)
   if (A(i) == 1)
       node_angle(i+1) = node_angle(i); %  Continue at same angle
       X(i+1) = branch_length*cos(node_angle(i)) + X(i);
       Y(i+1) = branch_length*sin(node_angle(i)) + Y(i);
   elseif (A(i) == 2)
       % Find branch indexes by finding index of non-zero elements of the
       % column corresponding to this node in the Directed Adjacency Matrix
       branch = find(dA(:,i));
       
       %I'm assuming that the first branch always turns left, and the
       %second always turns right. I think this is part of the BCT formalism
       node_angle(branch(1)) = node_angle(i) + branch_angle/2;
       node_angle(branch(2)) = node_angle(i) - branch_angle/2;
       
       for j = 1:2
           X(branch(j)) = X(i) + branch_length*cos(node_angle(branch(j)));
           Y(branch(j)) = Y(i) + branch_length*sin(node_angle(branch(j)));
       end
       % reduce branch lenght by factor of 2
       branch_length = branch_length/2;
   end
    
end
