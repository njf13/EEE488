function [acc] = template_matching(inImg, template)

    [rows, cols]=size(inImg);
    
    [rowsT, colsT]=size(template);
    
    cx=floor(colsT/2)+1;
    cy=floor(rowsT/2)+1;
    
    acc = zeros(rows,cols);
    
    for i=cx:cols-cx
        for j=cy:rows-cy
            for x=1-cx:cx-1
                for y=1-cy:cy-1
                    
                    err = cast(inImg(j+y,i+x), 'double') - cast(template(y+cy,x+cx), 'double');
                    err = err^2;
                    acc(j,i) = acc(j,i) + err;
                end
            end
        end
    end
end