function eroded = erosion(image, template)
    [irows,icols]=size(image);
    [trows,tcols]=size(template);
    
    eroded(1:irows, 1:icols)=uint8(0);
    
    trhalf=floor(trows/2);
    tchalf=floor(tcols/2);
    
    for x=trhalf+1:irows-trhalf
        for y=tchalf+1:icols-tchalf
            min=256;
            for iwin=1:trows
                for jwin=1:tcols
                    xi=x-trhalf-1+iwin;
                    yi=y-tchalf-1+jwin;
                    sub=double(image(xi,yi))-double(template(iwin,jwin));
                    if sub<min & sub>0
                        min=sub;
                    end
                end
            end
            eroded(x,y)=uint8(min);
        end
    end
end