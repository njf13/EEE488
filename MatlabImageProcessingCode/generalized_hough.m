function generalized_hough(inputimage, RTable)

[rows,columns] = size(inputimage);

[rowsT, h, columnsT]= size(RTable);

D=pi()/rowsT;

[M, Ang]= Edges(inputimage);

acc=zeros(rows,columns);

for x=1:columns
    for y=1:rows
        if(M(y,x)~=0)
            phi=Ang(y,x);
            i=round((phi+(pi()/2))/D);
            if(i==0) i=1; end;
            
            for j=1:columnsT
                if(RTable(i,1,j)==0 & RTable(i,2,j)==0)
                    j=columnsT;
                else
                    a0=x-RTable(i,1,j); b0=y-RTable(i,2,j);
                    if (a0>0 & a0columns & b0>0 & b0<rows)
                        acc(b0,a0) = acc(b0,a0)+1;
                    end
                end
            end
        end
    end
end

end