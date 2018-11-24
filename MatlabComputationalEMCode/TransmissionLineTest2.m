close all;
clear all;
home;

tline = TransmissionLineSegmentClass(1,1,1,1,1,1);

Vlineoutput=[];
Ilineoutput=[];

for n=1:100
    if n>0
        Vlineinput = cos(2*pi()*n/100);
    else
        Vlineinput = 0;
    end
    
    [Vout, Iout] =tline.DriveSegment(Vlineinput, 0);
    
    Vlineoutput(n)=Vout;
    Ilineoutput(n)=Iout;
end

figure, plot(Vlineoutput)
figure, plot(Ilineoutput)