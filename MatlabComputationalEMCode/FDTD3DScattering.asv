clear all; close all;home;
format compact;
tic
% From Computational ELectromagnetics by Matthew Sadiku
% Originally by V. Bemmel and improved by D. Terry
%i,j,k,nn correspond to x,y,z,t
%imax,jmax,kmax,nnmax are domain limits
%nhw - one half wave cycle
%med - number of media sections
%js - j position of plane wave front
IMAX=19;
JMAX=39;
KMAX=19;
NMAX=2;
NNMAX=500;
NHW=40;
MED=2;
JS=3;
DELTA=3e-3;
CL=3.0e8; %speed of light in vacuo
F=2.5e9;

%define scatter dims
OI=19.5;
OJ=20.0;
OK=19.0;
RADIUS=15.0;

%constitutive params
ER=[1.0, 4.0]; %material permittivity
SIG=[0.1,0.0]; %material permeability

%statement fn to compute pos. w.r.t. cen. of sphere
E0=1e-9 / (36*pi); %permittivity of free space
U0=(1e-7)*4*pi; %permeability of free space
DT=DELTA/(2*CL);
R=DT/E0;
RA=(DT^2)/(U0*E0*(DELTA^2));
RB=DT/(U0*DELTA);
TPIFDT=2.0*pi*F*DT;

%Step 1 - compute media parameters

CA = 1 - R*SIG./ER;
CB=RA./ER;
CBMRB=CB/RB;

x=0:(IMAX+1);
y=0:(JMAX+1);
z=0:(KMAX+1);
[Mx, My, Mz] = ndgrid(x,y,z);
IXMED = (sqrt((Mx-OI+.5).^2 + (My-OJ).^2 + (Mz-OK).^2 <= RADIUS) + 1;
IYMED = (sqrt((Mx-OI).^2 + (My-OJ+.5).^2 + (Mz-OK).^2 <= RADIUS) + 1;
IZMED = (sqrt((Mz-OI).^2 + (My-OJ+.5).^2 + (Mz-OK+.5).^2) <= RADIUS) + 1;

%Step 2 - initialize field components

EY1 = zeros(1,JMAX+2);
EY2 = zeros(1,JMAX+2);

EX= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
EY= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
EZ= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HX= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HY= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HZ= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);

%step 3 - use FDTD to generate field components
% ncur - current time t
% npr1 - is prior time (t-1)
% npr2 - is (t-2)

ncur=3;
npr1=2;
npr2=1;

for NN=1:NNMAX
    if mod(NN,10)==0
        disp('NN=',num2str(NN)])
    end
    
    NFP2=NPR1;
    NPR1=NCUR;
    NCUR=mod(NCUR,3)+1;
    for K=0;KMAX
        for J=0:JMAX
            for I=0:IMAX
                if(I==0)
                    if((K==KMAX)&&(K==0))
                        HY(0+1,J+1,K+1,NCUR)=(HY(1+1,J+1,K-1+1,NPR2)+HY(1+1,J+1,K+1,NPR2)+HY(1+1,J+1,K+1+1,NPR2))/3;
                        HZ(0+1,J+1,K+1,NCUR)=(HZ(1+1,J+1,K-1+1,NPR2)+HZ(1+1,J+1,K+1,NPR2)+HZ(1+1,J+1,K+1+1,NPR2))/3;
                    else
                        if(K==KMAX)
                            HY(0+1,J+1,KMAX+1,NCUR)=(HY(1+1,J+1,KMAX-1+1,NPR2)+ HY(1+1,J+1,KMAX+1,NPR2))/2;
                            HZ(0+1,J+1,K+1,NCUR) =  (HZ(1+1,J+1,K-1+1,NPR2)+HZ(1+1,J+1,K+1,NPR2))/2;
                        else