function [T]=invariant_r_table(entries, inputimage, M, Ang)

[rows,columns]=size(inputimage);

%[M,Ang]=detect_edges_sobel_2(inputimage,3);

alfa=pi()/10;

D=pi()/entries;
s=0;
t=0;
F=zeros(entries,1);
xr=0;
yr=0;
p=0;

for x=1:columns
    for y=1:rows
        if(M(y,x)~=0)
            xr=xr+x;
            yr=yr+y;
            p=p+1;
        end
    end
end
xr=round(xr/p);
yr=round(yr/p);

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
                    if(c>0 & c<rows & i>0 & i<columns & M(c,1)~=0)
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
                
                if((x-xr)~=0)
                    ph=atan((y-yr)/(x-xr));
                else
                    ph=1.57;
                end
                k=ph-Ang(y,x);
                i=round((beta+(pi()/2))/D);
                if(i==0)
                    i=1;
                end
                
                V=F(i)+1;
                
                if(V>s)
                    s=s+1;
                    T(:,s)=zeros(entries,1);
                end
                
                T(i,V)=k;
                F(i)=F(i)+1;
            end
        end
    end
end
end