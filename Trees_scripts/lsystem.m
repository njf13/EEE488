% A class to store and manipulate L-Systems
classdef lsystem < handle
   properties
       axiom = '';
       state = '';
       % Define basic L System properties.
       
       % Initialize the basic Turtle Rules
       % The format is [ruleCharacter outputString probability]
       % In most cases the probability will be 1. But if stochastic systems
       % are desired, a different value will be use.
       rules = ['F', "F", 1;
                'f', "f", 1;
                '[', "[", 1;
                ']', "]", 1;
                '+', "+", 1;
                '-', "-", 1];
       generation = 0;
       angle = 30;
       step = 10;
       turtle = [];
       
       % Keep track of info for importing to the Dendrite Class
       nodeCount = 1;
       dA = sparse(1,1);
       X = [];
       Y = [];
       
       
       % Store some optional parameters
       
       % determine if the system is edge or Node rewriting. If it is edge
       % rewriting, the system will move the turtle for F or for user
       % defined characters. I believe this is the only difference between edge
       % and node rewriting.
       edgeRewrite = false; 
       
       
       
       
       % A stack property to store branch positions
       % I think it'll store a node number, X, Y, and the orientation.
       stack = [];
   end
   methods
       function obj = lsystem( axiom_, rules_, angle_, option)
           obj.axiom = axiom_;
           obj.rules = [obj.rules; rules_]; % Append to basic rules.
           obj.angle = angle_;
           obj.state = axiom_;
           obj.generation = 0;
           
           
           % Create a "turtle" to move around and draw positions. The turtle is
           % actually just the nodecount, an X and a Y coordinate, and the orientation.
       
           obj.nodeCount = 1;
           obj.turtle = [obj.nodeCount 0 0 -90];
           obj.stack = [];
           obj.X = [0];
           obj.Y = [0];
           
           
           % Initialize Graph data
           obj.dA = [0];
           obj.X =  [0];
           obj.Y =  [0];
           
           if(~exist('option', 'var'))
               option = false;
           end
           
           obj.edgeRewrite = option;
       end
       
       function y = generate(obj, generations)
           if(isempty(generations))
               generations = 1;
           end
           
           for n = 1:generations
               obj.reset;
               nextState = '';
               stateChar = char(obj.state);

               for i = 1:length(stateChar)
                   currentChar = stateChar(i);
                   
                   % Build next L System state
                   nextState = [nextState obj.replaceChar(currentChar)];
                   
                   % Manage turtle
                   switch currentChar
                       case 'F'
                           obj.forward(1); % 1 indicates that it draws
                       case 'f'
                           obj.forward(0); % 0 indicates that it doesn't draw
                       case '['
                           obj.push();
                       case ']'
                           obj.pop();
                       case '+'
                           obj.rotate(1);
                       case '-'
                           obj.rotate(-1);
                       otherwise
                           if(obj.edgeRewrite)
                               obj.forward(1);
                           end
                   end
                   
                           
               end           

               obj.state = join(nextState, '');
               y = obj;
           end
       end
       
       function y = replaceChar(obj, inChar)
           ruleNumber = find(obj.rules(:,1)==inChar);
           ruleSelection = 1; % This part is for stochastics.
           
           % Determine if there is more than one rule entry, which would
           % indicate that there is a random choice between the different
           % options.
           if(length(ruleNumber)>1)
               % Pick a random value to start with.
               randomPick = rand(1);
               
               % Use this value to accumulate the probability values. All
               % of the probabilities should add up to 1.
               probRange = 0;
               
               
               for i= 1:length(ruleNumber)
                   probRange = probRange + str2num(obj.rules(ruleNumber(i), 3));
                   if( randomPick <= probRange)
                       ruleSelection = i;
                       break;
                   end
               end
           end
           
           % Return the next replacement string
           y = obj.rules(ruleNumber(ruleSelection), 2);
       end
       
       function y = push(obj)
           obj.stack = [obj.turtle; obj.stack];
           
           y = obj.stack(1,:);
       end
       
       function y = pop(obj)
           obj.turtle = obj.stack(1,:);
           obj.stack(1,:) =  [];
           
           y = obj.stack(1,:);
       end
       
       function y = forward( obj, draw)
           % Move the turtle
           newX = obj.turtle(2) + obj.step*cosd(obj.turtle(4));
           newY = obj.turtle(3) + obj.step*sind(obj.turtle(4));
           
           obj.turtle(2) = newX;
           obj.turtle(3) = newY;
           
           % Manage Directed Adjacency Matrix
           % Eventually I'd like this function to be able to draw or not
           % draw. I suppose this choice is determined by whether or not
           % there is an entry in the Directed Adjacency Matrix. So I will
           % just set that matrix entry to the value of "draw". If draw is
           % 1, then the points are connected with a line. If draw is 0,
           % then the points are not connected.
           obj.nodeCount = obj.nodeCount + 1;
           newDA = zeros(obj.nodeCount);
           newDA(1:end-1,1:end-1) = obj.dA;
           newDA(obj.nodeCount, obj.turtle(1)) = draw;
           obj.turtle(1) = obj.nodeCount;
           obj.dA = newDA;
           
           obj.X( obj.nodeCount, 1) = obj.turtle(2);
           obj.Y( obj.nodeCount, 1) = obj.turtle(3);
           
           y = obj.turtle;
       end
       
       function y = rotate( obj, direction)
           newAngle = obj.turtle(4) + direction*obj.angle;
           if(newAngle >= 360)
               newAngle = newAngle - 360;
           elseif(newAngle< 0)
               newAngle = newAngle + 360;
           end
               
           obj.turtle(4) = newAngle;
       end
       
       function y = plot( obj)
       end
       
       function y = reset(obj)
           obj.nodeCount = 1;
           obj.stack = [];
           obj.X = [0];
           obj.Y = [0];
           obj.dA = sparse(1,1);
           obj.turtle = [1, 0, 0, 90];
           obj.push();
       end
   end 
end
