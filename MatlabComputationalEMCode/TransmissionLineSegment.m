function [Vlineoutput, Ilineoutput] = TransmissionLineSegment(Vlineinput, Vlineoutputnm1, Ilineinputn, Ilineinputnm1,  deltat, deltaz, R, L, G, C)

    Vlineoutput = Vlineinput - R*deltaz*Ilineinputn - L*deltaz*(Ilineinputn - Ilineinputnm1)/deltat;
    Ilineoutput = Ilineinputn - G*deltaz*Vlineoutput - C*deltaz*(Vlineoutput - Vlineoutputnm1)/deltat;
end