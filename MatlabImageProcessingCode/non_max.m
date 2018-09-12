function [new_edge]=non_max(edges)

    for i=1:cols(edges(0,0)-2)
        for j=1:rows(edges(0,0)-2
            edges00=edges(0,0);
            edges01=edges(0,1);
            Mx=edges00(j,i);
            My=edges01(j,i);
            
            theta=-pi()/2;
            if(My ~=0 & Mx>0)
                theta=atan(Mx/My);
            else
                theta=-pi()/2;
            end
            
            adds=get_coords(theta);
            
            edges02=edges(0,2);
                        
            M1 = My .* edges02(j+adds(0,1),i+adds(0,0)) +(Mx-My).*edges02(j+adds(0,3), i+adds(0,2));
            
            adds = get_coords(theta+pi());
            
            M2=My.*(edges02(j+adds(0,1),i+adds(0,0) + (Mx-My).*(edges02(j+adds(0,3),i+adds(0,2)))));
            
            isbigger = (Mx.*edges02(j,i) > M1)*(Mx.*(edges02(j,i) >=M2)+(Mx*edges02(j,i)<M1).*(Mx.*edges02(j,i)<=M2);
            
            if isbigger>0
                new_edge(j,i)=edges02(j,i);
            else
                new_edge(j,i)=0;
            end
        end
    end
end