classdef dendrite < handle
    properties
        %X, Y, and Z coordinates. I will leave Z empty for now. 
        %I'll probably create an overloaded constructor if we want
        %non-planar dendrites.
        X = [];
        Y = [];
        Z = [];
        %Directed Adjacency Matrix
        dA = [];
        %BCT string where 0=T (Termination), 1=C (Continuation), and 2=B (Branch);
        BCT = [];
        %Store the number of nodes. Not sure if it's useful but whatever.
        nodes = 0;
        
        % Store a vector indicating the resistance of each branch.
        R = [];
        C = [];
        circuit;
    end
    methods
        %Constructor Function
        function obj = dendrite(dA_, X_, Y_, Z_)
            obj.dA = full(dA_);
            obj.X = X_;
            obj.Y = Y_;
            if( isempty(Z_))
                obj.Z = zeros(length(X_),1);
            else
                obj.Z = Z_;
            end
            obj.nodes = length(obj.X);
            obj.BCT = ones(1,obj.nodes)*obj.dA;
            obj.R = obj.setR;
            obj.C = obj.setC;
        end
        
        y = necGeometry(obj, length, radius)        
        y = plot( obj, overlay, nodeLabels)
        newDendrite = rotate( obj, X_degrees, Y_degrees, Z_degrees)
        y = branchOrder(obj)
        y = netlist( obj)
        dA = nearestNeighborDA( locations)
        y = ladder( obj)
        y = fracDim(obj)
        y = voronoi(obj)
        y = strahler(obj)
        
        
        rValues = setR(obj,  calcMethod, inputVal) 
        capValues = setC(obj,  calcMethod, inputVal) 
        [vNodes currents] = DC( obj, Vdd)
        ckt = makeCircuit(obj)
        
        delay = elmore(obj)
        Zeq = tf(obj, minFreq, maxFreq)
    end
end
 