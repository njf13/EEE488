function [Iindex, Jindex] = MatrixMax(A)
    [M,I]=max(A(:));
    [Iindex, Jindex]=ind2sub(size(A),I);
end