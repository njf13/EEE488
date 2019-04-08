function ABCD = Y2ABCD(Y)
    s = tf('s');
    ABCD = s*ones(2);
    ABCD(1,1) = -Y(2,2)/Y(2,1);
    ABCD(1,2) = -1/Y(2,1);
    ABCD(2,1) = -(Y(1,1)*Y(2,2)-Y(2,1)*Y(1,2))/Y(2,1);
    ABCD(2,2) = -Y(1,1)/Y(2,1);
end

