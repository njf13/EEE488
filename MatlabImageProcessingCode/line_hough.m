function [acc] = line_hough(inputimage)

[rows,columns]=size(inputimage);

rmax=round(sqrt(rows^2 + columns^2));
acc=zeros(rmax,18);

for x=1:columns
    for y=1:rows
        if(inputimage(y,x)==0)
            mm=1;
            for m=1:10:180
                r=round(x*cos((m*pi)/180) + y*sin((m*pi)/180));
                if(r<rmax & r>0)
                    acc(r,mm)=acc(r,mm)+1;
                end
                mm=mm+1;
            end
        end
    end
end
end