
%Minimum Spanning Tree using Prims Algorithm
%Ashim Gautam
%gautamashim142@gmail.com
%usage
%[route]=prims(cost_matrix,start_vertex)
%example
%A= [0   192   344     0     0     0     0     0     0     0     0;
%   192     0   309     0   555     0     0     0     0     0     0;
%   344   309     0   499     0     0     0     0     0     0     0;
%     0     0   499     0   840     0   229   286     0     0     0;
%     0   555     0   840     0   237     0     0     0     0     0;
%     0     0     0     0   237     0   729     0     0   793     0;
%     0     0     0   229     0   729     0   383     0     0     0;
%     0     0     0   286     0     0   383     0   929     0     0;
%     0     0     0     0     0     0     0   929     0   934   581;
%     0     0     0     0     0   793     0     0   934     0   633;
%     0     0     0     0     0     0     0     0   581   633     0]
% cost=prims(A,1);
%output %start_node end_node Cost
%     1     2   192
%     2     3   309
%    3     4   499
%     4     7   229
%     4     8   286
%     2     5   555
%     5     6   237
%     6    10   793
%    10    11   633
%    11     9   581
function [route]=prims(A,start) %A=cost matrix, start= initial node
[x y]=size(A);
if ne(x,y) % check if matrix is square
    fprintf('enter square matrix');
    return;end
for i=1 : size(A,1) %assigning large cost(inf) to not connected edges
    for j=1 : size(A,1)
        if A(i,j)==0; A(i,j)=inf;
        end
    end
end
route=zeros(x-1,3); %initialize route matrix (first node, second node, cost)
C=(start); %initial node
C_N=(1:x); % all nodes
C_N(:,start)=[]; %removing selected node
for k = 2:x
    counter=0;
    min=inf; %can be set to infinity
    for i=C
        count=0;
        for j=C_N
            count=count+1;
            if min>A(i,j)
                min=A(i,j);
                s=i;e=j;counter=count; %s=start node e=end node counter=node to remove
            end
        end
    end
    C(end+1)=e; % add node
    C_N(:,counter)=[]; % remove added none
    route(k-1,:)=[s e min]; % [start_node  end_node  cost]
end
end
    
