% A function to construct a netlist compatible with HSPICE
% There are currently no arguments. Future versions may have
% arguments for the beginn
function y = netlist( obj)
    y = [];
    branchCount = 1;
    
    if(isempty(obj.R))
        obj.setR;
    end
    
    if(isempty(obj.C))
        obj.setC;
    end

    str = ["* Netlist for Tree","","","","","","",""];

    disp(join(str,''));
    y = [y; str];

    str = ['* Netlist created on ' , date(),"","","","",""];
    disp(join(str,''));
    y = [y; [str, "\n"]];

    str = [".param maxV = 10","","","","","", ""];
    disp(join(str,''));
    y = [y; [str, "\n"]];

    % Add analysis commands here
    % All analysis commands except DC op will have an asterisk at
    % the beginning to "comment" them out. That way the person
    % doing the analysis can remove the asterisk for the desired
    % analysis.
    str = [".op", "","","","","",""];
    disp(join(str,''));
    y = [y;["\n", str]];

    % Place sources at all of the termination nodes.
    str = ["Vsource ", "Vsource ", "gnd ", "{maxV} AC 1", "", "", "", ""];
    disp(join(str,''));
    y = [y;str];

    str = ["*.AC dec 10 0.1 1G", "","","","","","",""];
    disp(join(str,''));
    y = [y;str];

    str = ["*.tran 1ns 1", "","","","","","",""];
    disp(join(str,''));
    y = [y;str];

    % Create a source for the transisent analysis.
    str = ["*Vsource ", "Vsource ", "gnd ", "PULSE (0 {maxV} 0 1n 1n 99m 200m)", "", "", "", ""];
    disp(join(str,''));
    y = [y;str];

    % Place sources at all of the termination nodes.
    str = ["*.measure tran tdlay TRIG V(Vsource) VAL = 0.5*maxV RISE=3 TARG V(*) VAL = 0.5*maxV RISE=3", "", "", "", "","","",""];
    disp(join(str,''));
    y = [y;str];




    % Place a 0V source from the beginning node to GND. Probably an
    % inefficent way to do this, but it simplifies the code for
    % now.
    str = ["Vgnd ", "n1 ", "gnd ", "0", "" ,"", "" ];
    disp(join(str,''));
    y = [y;[str, "\n\n"]];            

    for i = 1:obj.nodes
        daughterNodes = find(obj.dA(:, i));
        for j = 1:length(daughterNodes)
            % If the other node is a termination point, it should
            % connect to Vsource, instead of a n# node.
            if(obj.BCT(daughterNodes(j))== 0)
                node2 = " Vsource";
            else
                node2 = " n" + daughterNodes(j);
                node2 = join(node2,'');
            end

            str = ["r", branchCount, " n" , i, node2, " ", obj.R(daughterNodes(j)), ""];
            disp(join(str,''));
            y = [y;str];

            str = ["c", branchCount, node2, " gnd ",obj.C(daughterNodes(j)),"", "",""];
            disp(join(str,''));
            y = [y;str];

            branchCount = branchCount+1;
        end
    end



    % Add .end here
    str = [".end", "","","","","",""];
    disp(join(str,''));
    y = [y;["\n", str]];
end