close all;
clear all;
home;

Vlineoutput=[];
Ilineoutput=[];
deltaz = 0.001;


Vlineinput = 1;
Vlineoutputnm1=0;
Ilineinputn = 0;
Ilineinputnm1 = 0;
deltat = 1;
R=1;
L=1;
G=1;
C=1;

lineArray={}

for X=1:1000
    lineArray{X} = TransmissionLineSegmentClass(deltat,deltaz, R, L, G, C);
end

N=10000;
for n=0+1:N+1
    if n<300
        Vlineinput = cos(10*pi*n/deltaz);
    end
    
    for q=0+1:1000+1
        
        [Vlineoutput{q}, Ilineoutputn] = lineArray{q}.DriveSegment(Vlineinput, Vlineoutputnm1, Ilineinputn, Ilineinputnm1);
        Vlineoutputnm1 = Vlineoutputn;
        Ilineinputnm1 = Ilineinputn;
        Vlineoutput(q,n) = Vlineoutputn;
        Ilineoutput(q,n) = Ilineoutputn;
        
        Vlineinput = Vlineoutputn;
        Ilineinputn = Ilineoutputn;
    end
end

n=[0:1:N];
position = 33;
figure(1)
plot(n,Vlineoutput(position,:))
figure(2)
plot(n,Ilineoutput(position,:))

XX=[0:1:X]';
time=22;
figure(3)
plot(XX,Vlineoutput(:,time))
figure(4)
plot(XX,Ilineoutput(:,time))