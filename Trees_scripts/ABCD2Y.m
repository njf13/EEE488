function Y = ABCD2Y(ABCD)
    s = tf('s');
    Y = s*ones(2);
    Y(1,1) = ABCD(2,2)/ABCD(1,2);
    Y(1,2) = -(ABCD(1,1)*ABCD(2,2)-ABCD(1,2)*ABCD(2,1))/ABCD(1,2);
    Y(2,1) = -1/ABCD(1,2);
    Y(2,2) = ABCD(1,1)/ABCD(1,2);
end