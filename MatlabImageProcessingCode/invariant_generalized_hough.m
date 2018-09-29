function [acc]=invariant_generalized_hough(inputimage, RTable, M, Ang)

    [rows,columns] = size(inputimage);
    
    [rowsT, h, columnsT] = size(RTable);
    
    D=pi()/rowsT;
    
    %[M,Ang] = detect_edges_sobel_2(inputimage,3);
    
    alfa=pi()/4.0;
    
    acc=zeros(rows,columns);
    
    for x=1:columns
        for y=1:rows
            if(M(y,x)~=0)
                x1=-1;
                y1=-1;
                phi=Ang(y,x);
                m=tan(phi-alfa);
                
                if(m>-1 & m<1)
                    for i=3:columns
                        c=x+i;
                        j=round(m*(c-x)+y);
                        if(j>0 & j<rows & c>0 & c<columns & M(j,c)~=0)
                            x1=c;
                            y1=j;
                            i=columns;
                        end
                        c=x-i;
                        j=round(m*(c-x)+y);
                        if(j>0 & j<rows & c>0 & c<columns & M(j,c)~=0)
                            x1=c;
                            y1=j;
                            i=columns;
                        end
                    end
                else
                    for j=3:rows
                        c=y+j;
                        i=round(x+(c-y)/m);
                        if(c>0 & c<rows & i>0 & i<columns & M(c,i)~=0)
                            x1=i;
                            y1=c;
                            i=rows;
                        end
                        c=y-j;
                        i=round(x+(c-y)/m);
                        if(c>0 & c<rows & i>0 & i<columns & M(c,i)~=0)
                            x1=i;
                            y1=c;
                            i=rows;
                        end
                    end
                end
                
                if(x1~=-1)
                    phi=tan(Ang(y,x));
                    phj=tan(Ang(y1,x1));
                    if((1+phi*phj)~=0)
                        beta=atan((phi-phj)/(1+phi*phj));
                    else
                        beta=1.57;
                    end
                    
                    i=round((beta+(pi()/2))/D);
                    if(i==0)
                        i=1;
                    end
                    
                    for j=1:columnsT
                        if(RTable(i,j)==0)
                            j=columnsT;
                        else
                            k=RTable(i,j);
                            m=tan(cast(k+Ang(y,x), 'double'));
                            if(m>-1 & m<1)
                                for x0=1:columns
                                    y0=round(y+m*(x0-x));
                                    if(y0>0 & y0<rows)
                                        acc(y0,x0)=acc(y0,x0)+1;
                                    end
                                end
                            else
                                for y0=1:rows
                                    x0=round(x+(y0-y)/m);
                                    if(x0>0 & x0<columns)
                                        acc(y0,x0)=acc(y0,x0)+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

end