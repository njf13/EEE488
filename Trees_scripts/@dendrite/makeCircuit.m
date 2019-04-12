function ckt = makeCircuit(obj)
% Must have the MATLAB RF Toolbox installed to use this function.
% This function just outputs the circuit object with the topology of the
% dendrite. This circuit can be manipulated and analyzed with the RF
% Toolbox.
    ckt = circuit('dendriteCircuit');
    
    % It seems like the best way to use the setports function with a
    % varying number of ports, without manually typing in the command, is
    % to build a string for the MATLAB command, and running it using the
    % eval(expression) command, which will execute the string argument as
    % if it were a typed command.
    ports = "setports(ckt";
    
    % I think it's best not to set Node 1 as the ground, but to consider it
    % a port instead. When we evaluate the circuit as if Node 1 is the
    % ground, then we short it to ground. So we'll set a variable to serve
    % as the ground. This will be the highest node value plus 1.
    gnd = obj.nodes + 1;
    newPort = ", [1 " + gnd + "]";
    ports = join([ports,newPort'],'');
    
    % Go through each node and find its parent. Create a resistor from
    % current node to parent.
    for i = 2:obj.nodes
        parent = find(obj.dA(i, :));
        
        add(ckt, [parent i], resistor(obj.R(i), ['R', num2str(i)]));
        add(ckt, [i 1], capacitor(obj.C(i), ['C', num2str(i)]));
        
        if(obj.BCT(i) == 0)
            newPort = ", ["+i+" "+ gnd + "]";
            ports = join([ports,newPort'],'');
        end
    end
    
    ports = join([ports, ");"],'');
    eval(ports);
    obj.circuit = ckt;
end