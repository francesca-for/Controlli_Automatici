clear all
close all
clc

es=menu('Simulazione della riaposta del sistema meccanico',...
        '1.a) beta=0.1, K=2,  x0=[0;0],   F(t)=1;',...
        '1.b) beta=0.01, K=2,  x0=[0;0],   F(t)=1;',...
        '1.c) beta=10,   K=20, x0=[0;0],   F(t)=1;',...
        '1.d) beta=0.1,  K=2,  x0=[0;0.2], F(t)=1;',...
        '2.a) beta=0.1,  K=2,  x0=[0;0],   F(t)=cos(4t);',...
        '2.b) beta=0.01, K=2,  x0=[0;0],   F(t)=cos(4t);',...
        '2.c) beta=10,   K=20, x0=[0;0],   F(t)=cos(4t);',...
        '2.d) beta=0.1,  K=2,  x0=[0;0.2], F(t)=cos(4t)' );

switch es
        case 1, beta=0.1;  k=2;  x0=[0;0];   w0=0; tmax=20;
        case 2, beta=0.01; k=2;  x0=[0;0];   w0=0; tmax=200;
        case 3, beta=10;   k=20; x0=[0;0];   w0=0; tmax=10;
        case 4, beta=0.1;  k=2;  x0=[0;0.2]; w0=0; tmax=20;
        case 5, beta=0.1;  k=2;  x0=[0;0];   w0=4; tmax=10;
        case 6, beta=0.01; k=2;  x0=[0;0];   w0=4; tmax=10;
        case 7, beta=10;   k=20; x0=[0;0];   w0=4; tmax=10;
        case 8, beta=0.1;  k=2;  x0=[0;0.2]; w0=4; tmax=10;
end

m = 0.2;
f0 = 1;

tmax = 20;

t=0:0.01:tmax;
u = f0*cos(w0*t);

A = [0,-k/m;1,-k/beta];
B = [1/m;0];
C = [1,0];
D = 0;

% Stesso sistema di prima, calcolo le funzioni di trasferimento 

[num,den] = ss2tf(A,B,C,D)

%% ESERCIZIO 3

% Calcolare analiticamente, per condizioni iniziali nulle, le risposte dei
% sistemi dinamici ai seguenti ingressi:
%  -  gradino di ampiezza 1
%  -  rampa unitaria
%  -  u0*cos(4t)

ingresso = menu('tipo di ingresso del sistema','u(t) = u0','u(t) = t','u(t) = u0*cos(4*t)');

s=tf('s');

switch ingresso
    case 1, U = 1/s;
    case 2, U = 1/s^2;
    case 3, U = s/(s^2+4^2);
end

H = tf(num,den)

Y = H * U;

[numY,denY] = tfdata(Y,'v')

[residui,poli,K] = residue(numY,denY)
