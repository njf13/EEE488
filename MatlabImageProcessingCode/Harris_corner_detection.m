function [outputImage]=Harris_corner_detection(inImage, op)

    inputImage=cast(inImage, 'double');
    w=4;
    k=0.1;
    [rows,columns]=size(inputImage);
    outputImage=zeros(rows,columns);
    
    [M,A]=detect_edges_sobel_2(inputImage,3);
    [difx, dify]=Gradient(inputImage);
    %M=MaxSupr(M,A);
    
    for x=w+1:columns-w
        for y=w+1:rows-w
            if M(y,x)>0
                A=0;B=0;C=0;
                
                for i=-w:w
                    for j=-w:w
                        A=A+difx(y+i,x+j)^2;
                        B=B+dify(y+i,x+j)^2;
                        C=C+(difx(y+i,x+j)*dify(y+i,x+j));
                    end
                end

                if(op=='H')
                    outputImage(y,x)= A*B - C^2 - k*((A + B)^2);
                    
                else
                    dx=difx(y,x);
                    dy=dify(y,x);

                    if dx*dx + dy*dy >0

                        outputImage(y,x)=((A*dy*dy - 2*C*dx*dy + B*dx*dx) / ( dx*dx + dy*dy));
                    end
                end
            end
        end
    end
end