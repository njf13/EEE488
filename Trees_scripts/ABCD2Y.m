function Y = ABCD2Y(ABCD)
% This function converts ABCD-parameters to Y-parameters (admittance).
% There is a similar function included in the MATLAB RF Toolbox, but it
% only works on numbers (real or complex). This function works on both
% numbers or transfer functions.
    if(isa(ABCD,'tf'))
        s = tf('s');
        Y = s*ones(2);    
    else
        Y = zeros(2);
    end
    
    Y(1,1) = ABCD(2,2)/ABCD(1,2);
    Y(1,2) = -(ABCD(1,1)*ABCD(2,2)-ABCD(1,2)*ABCD(2,1))/ABCD(1,2);
    Y(2,1) = -1/ABCD(1,2);
    Y(2,2) = ABCD(1,1)/ABCD(1,2);
end