function [outputImage] = gradient_corner(inImage, op)
    inputImage = cast(inImage, 'double');
    [rows, columns] = size(inputImage);
    outputImage = zeros(rows, columns);
    
    [M, A]=detect_edges_sobel_2(inputImage, 5);
    [Mx, My] = Gradient(M);
%    M=MaxSupr(M,A);
    [Mxx, Mxy]=Gradient(Mx);
    [Myx, Myy]=Gradient(My);
    
    for x=1:columns
        for y=1:rows
            if(M(x,y)>=0)
                My2 = My(x,y)^2; Mx2 = Mx(x,y)^2; MxMy=Mx(x,y)*My(x,y);
                if((Mx2+My2)>=0)
                    if(op=='TI')
                        outputImage(x,y)=(1/(Mx2 + My2)^1.5)*(My2*Mxx(x,y) - MxMy * Myx(x,y)- Mx2*Myy(x,y)+ MxMy*Mxy(x,y));
                    elseif (op=='N')
                        outputImage(x,y)=(1/(Mx2 + My2)^1.5)*(Mx2*Myx(x,y) - MxMy * Mxx(x,y)- MxMy*Myy(x,y) + My2*Mxy(x,y));
                    elseif (op=='NI')
                        outputImage(x,y)=(1/(Mx2 + My2)^1.5)*(-Mx2*Myx(x,y) + MxMy*Mxx(x,y) - MxMy*Myy(x,y) + My2*Mxy(x,y));
                    else
                        outputImage(x,y)=(1/(Mx2 + My2)^1.5)*(My2*Mxx(x,y) - MxMy*Myx(x,y) + Mx2*Myy(x,y) - MxMy*Mxy(x,y));
                    end
                end
            end
        end
    end
end