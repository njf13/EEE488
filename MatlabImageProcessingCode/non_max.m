function [new_edge]=non_max(edges)

    for i=1:cols(edges(0,0)-2)
        for j=1:rows(edges(0,0)-2_
            Mx=(edges(0,0))(j,i);
            My=(edges(0,1))(j,i);
            
            theta=-pi()/2;
            if(My ~=0 & Mx>0)
                theta=atan(Mx/My);
            else
                theta=-pi()/2;
            end
            
            adds=get_coords(theta);
            
            %TODO Finish non_max
end