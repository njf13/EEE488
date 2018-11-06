close all;
clear all;
home;

Vlineoutput=[];
Ilineoutput=[];
deltaz = 0.001;
z=[0:deltaz:1.0];

Vlineinput = 1;
Vlineoutputnm1=0;
Ilineinputn = 0;
Ilineinputnm1 = 0;
deltat = 1;
R=1;
L=1;
G=1;
C=1;

X=1000;
length = X*deltaz;

N=100;
for n=0:N
    if n<3
        Vlineinput = cos(10*pi*n/N);
    end
    
    for z=0:X
        [Vlineoutputn, Ilineoutputn]= TransmissionLineSegment(Vlineinput, Vlineoutputnm1, Ilineinputn, Ilineinputnm1, 1/N, deltaz, R, L, G, C);
        Vlineoutputnm1 = Vlineoutputn;
        Ilineinputnm1 = Ilineinputn;
        Vlineoutput(z+1,n+1) = Vlineoutputn;
        Ilineoutput(z+1,n+1) = Ilineoutputn;
        
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

X=[0:1:1000]';
time=22;
figure(3)
plot(X,Vlineoutput(:,time))
figure(4)
plot(X,Ilineoutput(:,time))