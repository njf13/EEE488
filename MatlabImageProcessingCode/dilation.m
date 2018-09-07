function dilated = dilation(image,template)
    [irows,icols]=size(image);
    [trows,tcols]=size(template);
    
    dilated(1:irows,1:icols)=uint8(0);
    
    trhalf=floor(trows/2);
    tchalf=floor(tcols/2);
    
    for x=trhalf+1:irows-trhalf
        for y=tchalf+1:icols-tchalf
            max=0;
            for iwin=1:trows
                for jwin=1:tcols
                    xi=x-trhalf-1+iwin;
                    yi=y-tchalf-1+jwin;
                    sub=double(image(xi,yi))+double(template(iwin,jwin));
                    if sub > max & sub > 0
                        max=sub;
                    end
                end
            end
            dilated(x,y)=uint8(max);
        end
    end
end