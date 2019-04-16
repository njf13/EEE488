function ABCD = Y2ABCD(Y)
% This function converts Y-parameters (admittance) to ABCD-parameters.
% There is a similar function included in the MATLAB RF Toolbox, but it
% only works on numbers (real or complex). This function works on both
% numbers or transfer functions.
    if(isa(Y,'tf'))
        s = tf('s');
        ABCD = s*ones(2);    
    else
        ABCD = zeros(2);
    end

    ABCD(1,1) = -Y(2,2)/Y(2,1);
    ABCD(1,2) = -1/Y(2,1);
    ABCD(2,1) = -(Y(1,1)*Y(2,2)-Y(2,1)*Y(1,2))/Y(2,1);
    ABCD(2,2) = -Y(1,1)/Y(2,1);
end

