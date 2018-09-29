function [outputImage] = gradient_corner(inImage, op)
    inputImage = cast(inImage, 'double');
    [rows, columns] = size(inputImage);
    outputImage = zeros(rows, columns);
    [Mx, My] = gradient(inputImage);
    [M, A]=Edges(inputImage);
%    M=MaxSupr(M,A);
    [Mxx, Mxy]=gradient(Mx);
    [Myx, Myy]=gradient(My);
    
    for x=1:columns
        for y=1:rows
            if(M(y,x)~=0)
                My2 = My(y,x)^2; Mx2 = Mx(y,x)^2; MxMy=Mx(y,x)*My(y,x);
                if((Mx2+My2)~=0)
                    if(op=='TI')
                        outputImage(y,x)=(1/(Mx2 + My2)^1.5)*(My2*Mxx(y,x) - MxMy * Myx(y,x)- Mx2*Myy(y,x)+ MxMy*Mxy(y,x));
                    elseif (op=='N')
                        outputImage(y,x)=(1/(Mx2 + My2)^1.5)*(Mx2*Myx(y,x) - MxMy * Mxx(y,x)- MxMy*Myy(y,x) + My2*Mxy(y,x));
                    elseif (op=='NI')
                        outputImage(y,x)=(1/(Mx2 + My2)^1.5)*(-Mx2*Myx(y,x) + MxMy*Mxx(y,x) - MxMy*Myy(y,x) + My2*Mxy(y,x));
                    else
                        outputImage(y,x)=(1/(Mx2 + My2)^1.5)*(My2*Mxx(y,x) - MxMy*Myx(y,x) + Mx2*Myy(y,x) - MxMy*Mxy(y,x));
                    end
                end
            end
        end
    end
end