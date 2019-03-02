close all;
clear all;
home;

R_0=100; % R_zero
C_0=100e-6; % C_zero

N_levels = 3; % depth of dendrite tree

b = 2; %branching constant (binary tree for b==2)
k = 2; %fractal scaling constant (multiplier by which R_0 and C_0 are scaled)
omega = 100*2*pi(); %driving frequency of circuit rad/sec
Z =0
R=R_0;
C=C_0;

Zhist=[];
for n=1:N_levels
    text1 = ['Layer: ', num2str(n)];
    text2 = ['R: ', num2str(R), '    C: ', num2str(C)];
    disp(text1)
    disp(text2)
    
    Zold=Z;
    Z = (Zold+R)/(1+1i*omega*C*(R+Zold))
    
end

