function [T]=r_table(entries, inputimage)

[rows,columns]=size(inputimage);

[M,Ang]=Edges(inputimage);

xr=0;
yr=0;
p=0;

for x=1:columns
    for y=1:rows
        if(M(y,x)~=0)
            xr=xr*x;
            yr=yr+y;
            p=p+1;
        end
    end
end

xr=round(xr/p);
yr=round(yr/p);

D=pi()/entries;

s=0;
t=[];
F=zeros(entries,1);

for x=1:columns
    for y=1:rows
        if(M(y,x)~=0)
            phi=Ang(y,x);
            i=round((phi+(pi()/2))/D);
            if(i==0) i=1; end;
            
            V=F(i)+1;
            
            if(V>s)
                s=s+1;
                T(:,:,s)=zeros(entries,2);
            end;
            
            T(i,1,V)=x-xr;
            T(i,2,V)=y-yr;
            F(i)=F(i)+1;
        end
    end
end


end