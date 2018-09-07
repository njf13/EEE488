function [pascalCoefficient]=pascal(k,n)
    pascalCoefficient=0;
    if k>=0 & k<=n
        pascalCoefficient=factorial(n)/(factorial(n-k)*factorial(k));
    end
end