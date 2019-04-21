function Zeq = tf(obj, minFreq, maxFreq)
    freq = logspace(log10(minFreq), log10(maxFreq),100);
    s = 1i*2*pi*freq;
    
    Tmatrix = cell(obj.nodes, length(freq));

    dA = obj.dA;
    BCT = obj.BCT;
    X = obj.X;
    Y = obj.Y;
    %index = [1:obj.nodes];
    
    errorCheck = false;
    
    % Pre load each of the nodes with an ABCD matrix.
    for ii = 2:obj.nodes
        for jj=1:length(freq)
            Tmatrix{ii,jj} = [(1+s(jj)*obj.R(ii)*obj.C(ii)), obj.R(ii); s(jj)*obj.C(ii), 1];
        end
    end

    
    
    while(length(X)>2 && errorCheck == false)
        terminations = find(BCT==0);

        dnew = dendrite(dA, X, Y,[]);
        dnew.plot;
        
        for ii=1:length(terminations)

            parent = find(dA(terminations(ii),:));

            if(BCT(parent)==1)
                for jj = 1:length(freq)
                    % Find the cascaded equivalent matrix by multiplying the ABCD matrices
                    Tmatrix{parent,jj} = Tmatrix{parent,jj}*Tmatrix{terminations(ii),jj};
                end
                % Now clean up the matrices and vectors so we know that these networks were combined.
                X(terminations(ii)) = [];
                Y(terminations(ii)) = [];
                %index(ii) = []
                   
                dA(terminations(ii),:) =[];
                dA(:,terminations(ii)) =[];
                BCT = ones(1,length(X))*dA;
                break
            elseif(BCT(parent)==2)
                % If the parent is a branch.
                % Find the sister node.
                sister = find(dA(:,parent));
                
                % These next lines delete any repeats from the list.
                termRepeat = find(sister==terminations(ii));
                sister(termRepeat) = [];

                % Check if sister node is also a termination
                if(BCT(sister) == 0)
                    
                    for jj = 1:length(freq)
                        % If the sister nodes are each terminations, then they can be combined by adding their Y matrices
                        ySum = ABCD2Y(Tmatrix{terminations(ii),jj}) + ABCD2Y(Tmatrix{sister,jj});

                        % Then they can be merged with the parent node by multiplying the ABCD matrices;
                        Tmatrix{parent,jj} = Tmatrix{parent,jj}*Y2ABCD(ySum);
                    end

                    % Now clean up.
                    X(terminations(ii)) = [];
                    Y(terminations(ii)) = [];
                    %index(terminations(ii)) = []
                    
                    dA(terminations(ii),:) =[];
                    dA(:,terminations(ii)) =[];


                    X(sister-1) = [];
                    Y(sister-1) = [];
                    %index(sister-1) = [];
                    
                    dA(sister-1,:) =[];
                    dA(:,sister-1) =[];

                    BCT = ones(1,length(X))*dA;

                    break;
                end
            end
        end
    end
    
    dnew = dendrite(dA, X, Y,[]);
    dnew.plot;
    
    Zosc = zeros(length(freq),1);
    parent
    %index(parent)
    for ii = 1:length(freq)
        Zosc(ii) = Tmatrix{2,ii}(1,2)/Tmatrix{2,ii}(1,1);
    end
    semilogx(abs(s),20*log10(abs(Zosc)))
    
    f = frd(Zosc,abs(s),'FrequencyUnit','rad/s');
    Zeq = tfest(f,40);
    
    
end