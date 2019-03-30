close all;
clear all;
home;

R_0=100; % R_zero
C_0=100e-6; % C_zero

N_levels = 2; % depth of dendrite tree

b = [2]; %branching constant (binary tree for b==2)
k = [0.5,1,1.5]; %fractal scaling constant (multiplier by which R_0 and C_0 are scaled)
omega = [1:1:150].*pi().*2.0; %driving frequency of circuit rad/sec

Z =0;
R=R_0;
C=C_0;

Zhistory=[];

for mm=1:length(omega)
    
    for ii=1:length(b)
        for jj=1:length(k)
            for n=1:N_levels
                text1 = ['Layer: ', num2str(n)];
                text2 = ['R: ', num2str(R), '    C: ', num2str(C)];
                disp(text1)
                disp(text2)

                Zold=Z;
                Z = (Zold+R)/(1+1i*omega(mm)*C*(R+Zold));
                
                R=k(jj)*R/b(ii);
                C=b(ii)*C/k(jj);
            end
            Zhistory(mm,ii,jj) =Z;
        end
    end
    
    
end

% sizeZhistory = size(Zhistory);
% plotZ = reshape(Zhistory(:,:,1), sizeZhistory(1,1), sizeZhistory(1,2));
% figure,mesh(b, omega, abs(plotZ))
figure,plot(omega,abs(Zhistory(:,1,1)))
figure,plot(omega,angle(Zhistory(:,1,1)).*180.0./pi())
figure,plot(omega,real(Zhistory(:,1,1)))
figure,plot(omega,imag(Zhistory(:,1,1)))