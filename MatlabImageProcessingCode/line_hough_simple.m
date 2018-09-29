function [acc1, acc2] = line_hough_simple(inputimage)

[rows,columns] = size(inputimage);
acc1=zeros(rows,91);
acc2=zeros(columns,91);

for x=1:columns
    for y=1:rows
        if(inputimage(y,x)==0)
            for m=-45:45
                b=round(y-tan((m*pi())/180)*x);
                if(b<rows & b>0)
                    acc1(b,m+45+1)=acc1(b,m+45+1)+1;
                end
            end
            for m=45:135
                b=round(x-y/tan((m*pi())/180));
                if(b<columns & b>0)
                    acc2(b,m-45+1)=acc2(b,m-45+1)+1;
                end
            end
        end
    end
end
end