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
IMAX=19*2;
JMAX=39*2;
KMAX=19*2;
NMAX=2;
NNMAX=500;
NHW=40;
MED=2;
JS=3;
DELTA=3e-3;
CL=3.0e8; %speed of light in vacuo
F=10e9;

%define scatter dims
OI=20.0;
OJ=20.0;
OK=20.0;
RADIUS=5.0;

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
IXMED = (Mx >= 15).*(Mx<=25).*(sqrt((My-OJ).^2 + (Mz-OK).^2)<=RADIUS) + 1;
IYMED = (sqrt((Mx-OI).^2 + (My-OJ+.5).^2 + (Mz-OK).^2) <= RADIUS) + 1;
IZMED = (sqrt((Mz-OI).^2 + (My-OJ+.5).^2 + (Mz-OK+.5).^2) <= RADIUS) + 1;

%Step 2 - initialize field components
EX1 = zeros(1,JMAX+2);
EY1 = zeros(1,JMAX+2);
EZ1 = zeros(1,JMAX+2);

EX= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
EY= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
EZ= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HX= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HY= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1);
HZ= zeros(IMAX+2, JMAX+2, KMAX+2, NMAX+1,3);

%step 3 - use FDTD to generate field components
% ncur - current time t
% npr1 - is prior time (t-1)
% npr2 - is (t-2)

NCUR=3;
NPR1=2;
NPR2=1;
%graphics for s get assigned at bottom of loop, remember to adjust there
figure(5)
s=surf( sqrt(EX(:,:,floor(KMAX/2),NCUR).^2 + EY(:,:,floor(KMAX/2),NCUR).^2 + EZ(:,:,floor(KMAX/2),NCUR).^2))

% figure(6)
% q = quiver(EX(:,:,floor(KMAX/2),NCUR),EY(:,:,floor(KMAX/2),NCUR))

for NN=1:NNMAX
    if mod(NN,10)==0
        disp(['NN=',num2str(NN)])
    end
    
    NPR2=NPR1;
    NPR1=NCUR;
    NCUR=mod(NCUR,3)+1;
    for K=0:KMAX
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
                            HY(0+1,J+1,K+1,NCUR) = (HY(1+1,J+1,K+1,NPR2)+HY(1+1,J+1,K+1+1,NPR2))/2;
                            HZ(0+1,J+1,K+1,NCUR) = (HZ(1+1,J+1,K+1,NPR2)+HZ(1+1,J+1,K+1,1+1,NPR2))/2;
                        end
                    end
                end
                if(J==0)
                    EX(I+1,0+1,K+1,NCUR)=EX(I+1,1+1,K+1,NPR2);
                    EZ(I+1,0+1,K+1,NCUR)=EZ(I+1,1+1,K+1,NPR2);
                else
                    if(J==JMAX)
                        EX(I+1,JMAX+1,K+1,NCUR)=EX(I+1,JMAX-1+1,K+1,NPR2);
                        EZ(I+1,JMAX+1,K+1,NCUR)=EZ(I+1,JMAX-1+1,K+1,NPR2);
                    end
                end
                if(K==0)
                    if((I~=0)&&(I~=IMAX))
                        EX(I+1,J+1,0+1,NCUR)=(EX(I-1+1,J+1,1+1,NPR2) + EX(I+1,J+1,1+1,NPR2)+EX(I+1+1,J+1,1+1,NPR2))/3;
                        EY(I+1,J+1,0+1,NCUR)=(EY(I-1+1,J+1,1+1,NPR2)+EY(I+1,J+1,1+1,NPR2)+EY(I+1+1,J+1,1+1,NPR2))/3;
                    else
                        if(I==0)
                            EX(0+1,J+1,0+1,NCUR)=(EX(0+1,J+1,1+1,NPR2)+EX(1+1,J+1,1+1,NPR2))/2;
                            EY(I+1,J+1,0+1,NCUR)=(EY(I+1,J+1,1+1,NPR2)+EY(I+1+1,J+1,1+1,NPR2))/2;
                        else
                            EX(I+1,J+1,0+1,NCUR)=(EX(I-1+1,J+1,1+1,NPR2)+EX(I+1,J+1,1+1,NPR2))/2;
                            EY(I+1,J+1,0+1,NCUR)=(EY(I-1+1,J+1,1+1,NPR2)+EY(I+1,J+1,1+1,NPR2))/2;
                        end
                    end
                end
                
                %Apply FDTD algorithm
                HX(I+1, J+1,K+1,NCUR)=HX(I+1,J+1,K+1,NPR1)+RB*(EY(I+1,J+1,K+1+1,NPR1)-EY(I+1,J+1,K+1,NPR1)+EZ(I+1,J+1,K+1,NPR1)-EZ(I+1,J+1+1,K+1,NPR1));
                HY(I+1,J+1,K+1,NCUR) =HY(I+1,J+1,K+1,NPR1)+RB*(EZ(I+1+1,J+1,K+1,NPR1)-EZ(I+1,J+1,K+1,NPR1)+EX(I+1,J+1,K+1,NPR1)-EX(I+1,J+1,K+1+1,NPR1));
                HZ(I+1,J+1,K+1,NCUR) =HZ(I+1,J+1,K+1,NPR1)+RB*(EX(I+1,J+1+1,K+1,NPR1)-EX(I+1,J+1,K+1,NPR1)+EY(I+1,J+1,K+1,NPR1)-EY(I+1+1,J+1,K+1,NPR1));
                
                if(K==KMAX)
                    HX(I+1,J+1,KMAX+1,NCUR)=HX(I+1,J+1,KMAX-1+1,NCUR);
                    HY(I+1,J+1,KMAX+1,NCUR)=HY(I+1,J+1,KMAX-1+1,NCUR);
                end
                
                if((J~=0)&&(J~=JMAX)&&(K~=0))
                    M=IXMED(I+1,J+1,K+1);
                    EX(I+1,J+1,K+1,NCUR)=CA(M)*EX(I+1,J+1,K+1,NPR1)+CBMRB(M)*(HZ(I+1,J+1,K+1,NCUR)-HZ(I+1,J-1+1,K+1,NCUR)+HY(I+1,J+1,K-1+1,NCUR)-HY(I+1,J+1,K+1,NCUR));
                end
                
                if(K~=0)
                    M=IYMED(I+1,J+1,K+1);
                    if I~=0
                        EY(I+1,J+1,K+1,NCUR)=CA(M)*EY(I+1,J+1,K+1,NPR1)+CBMRB(M)*(HX(I+1,J+1,K+1,NCUR)- HX(I+1,J+1,K-1+1,NCUR)+HZ(I-1+1,J+1,K+1,NCUR)-HZ(I+1,J+1,K+1,NCUR));
                    else
                        EY(I+1,J+1,K+1,NCUR)=CA(M)*EY(I+1,J+1,K+1,NPR1)+CBMRB(M)*(HX(I+1,J+1,K+1,NCUR)-HX(I+1,J+1,K-1+1,NCUR)+0 - HZ(I+1,J+1,K+1,NCUR));
                    end
                end
                
                if((J~=0)&&(J~=JMAX))
                    M=IZMED(I+1,J+1,K+1);
                    if(M==1)
                        CAM=1;
                    else
                        CAM=CA(M);
                    end
                    
                    if I~=0
                        EZ(I+1,J+1,K+1,NCUR)=CAM*EZ(I+1,J+1,K+1,NPR1)+CBMRB(M)*(HY(I+1,J+1,K+1,NCUR)-HY(I-1+1,J+1,K+1,NCUR)+HX(I+1,J-1+1,K+1,NCUR)-HX(I+1,J+1,K+1,NCUR));
                    else
                        EZ(I+1,J+1,K+1,NCUR)=CAM*EZ(I+1,J+1,K+1,NPR1)+CBMRB(M)*(HY(I+1,J+1,K+1,NCUR)-0+HX(I+1,J-1+1,K+1,NCUR)-HX(I+1,J+1,K+1,NCUR));
                    end
                    
                    %apply plane wave source
                    
                    if(J==JS)
                        EZ(I+1,JS+1,K+1,NCUR) = EZ(I+1,JS+1,K+1,NCUR)+sin(TPIFDT*NN);
                    end
                end
                
                if(I==IMAX)
                    EY(IMAX+1+1,J+1,K+1,NCUR) = EY(IMAX+1,J+1,K+1,NCUR);
                    EZ(IMAX+1+1,J+1,K+1,NCUR) = EZ(IMAX+1,J+1,K+1,NCUR);
                end
                if(K==KMAX)
                    EX(I+1,J+1,KMAX+1+1,NCUR)=EX(I+1,J+1,KMAX-1+1,NCUR);
                    EY(I+1,J+1,KMAX+1+1,NCUR)=EY(I+1,J+1,KMAX-1+1,NCUR);
                end
            end
            
            %retain max abs vals during last half wave
            
            if((K==KMAX)&&(NN>(NNMAX-NHW)))
               
                TEMP=abs(EY(IMAX+1,J+1,KMAX-1+1,NCUR));
                if(TEMP>EY1(J+1))
                    EY1(J+1)=TEMP;
                end
                TEMP=abs(EZ(IMAX+1,J+1,KMAX+1,NCUR));
                if(TEMP>EZ1(J+1))
                    EZ1(J+1)=TEMP;
                end
            end
        end
    end
    
    
    s.ZData = sqrt(EZ(:,:,floor(KMAX/2),NCUR).^2 + EX(:,:,floor(KMAX/2),NCUR).^2+ EY(:,:,floor(KMAX/2),NCUR).^2)
    %q = quiver(HX(:,:,floor(KMAX/2),NCUR),HY(:,:,floor(KMAX/2),NCUR))
    pause(0.05);
end
toc

% figure(3),plot(6:34,EY1(6:34),'.-')
%     ylabel('Computed |E_y|/|E_i_n_c|')
%     xlabel('j')
%     grid on
% figure(4),plot(5:34,EZ1(5:34),'.-')
%     ylabel('Computed |E_z|/|E_i_n_c|')
%     xlabel('j')
%     grid on
    