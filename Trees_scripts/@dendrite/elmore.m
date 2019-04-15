function delay = elmore(obj)
    dApowers = eye(obj.nodes);
    downstreamC = obj.C;

    for ii = 1:obj.nodes
        dApowers = dApowers*obj.dA;
        downstreamC = downstreamC + dApowers'*obj.C;
    end
    
    tau = zeros(obj.nodes,1);

    for ii = 2:obj.nodes
        tau(ii) = obj.R(ii)*downstreamC(ii);
        parent = find(obj.dA(ii,:));
        while(parent~=1)
            tau(ii) = tau(ii) + obj.R(parent)*(downstreamC(parent));
            parent = find(obj.dA(parent,:));
        end
    end
    
    delay = log(2)*tau;
end