function [output] = laplacian_of_gaussian(sigma, size)
    cx=(size-1)/2;
    cy=(size-1)/2;
    templateMax=1;
    for x=0:size-1
        for y=0:size-1
            nx=x-cy;
            ny=y-cx;
            template(y,x)=(1/(sigma.^2)).*((nx.^2 + ny.^2)./(sigma.^2) - 2).*exp(-(nx.^2 + ny.^2)./(2.*(sigma.^2)));
            if template(y,x) > templateMax
                templateMax=template(y,x);
            end
        end
    end
    
    output = template./templateMax;
end