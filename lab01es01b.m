clear variables
close all
clc

es=menu('Simulazione della risposta del sistema elettrico',...
        '1.a) R=10,  L=0.5,  x0=[0;0],   i=1;',...
        '1.b) R=100, L=0.5,  x0=[0;0],   i=1;',...
        '1.c) R=0.1, L=0.05, x0=[0;0],   i=1;',...
        '1.d) R=10,  L=0.5,  x0=[0;0.2], i=1;',...
        '2.a) R=10,  L=0.5,  x0=[0;0],   i=cos(4t);',...
        '2.b) R=100, L=0.5,  x0=[0;0],   i=cos(4t);',...
        '2.c) R=0.1, L=0.05, x0=[0;0],   i=cos(4t);',...
        '2.d) R=10,  L=0.5,  x0=[0;0.2], i=cos(4t)' );

switch es
        case 1, R=10;  L=0.5;  x0=[0;0];   w0=0;
        case 2, R=100; L=0.5;  x0=[0;0];   w0=0;
        case 3, R=0.1; L=0.05; x0=[0;0];   w0=0;
        case 4, R=10;  L=0.5;  x0=[0;0.2]; w0=0;
        case 5, R=10;  L=0.5;  x0=[0;0];   w0=4;
        case 6, R=100; L=0.5;  x0=[0;0];   w0=4;
        case 7, R=0.1; L=0.05; x0=[0;0];   w0=4;
        case 8, R=10;  L=0.5;  x0=[0;0.2]; w0=4;
end

C = 0.2;
i0 = 1;

tmax = 20;

% SYS = ss(A,B,C,D);

%     _________________
%    |       |         |
%    ^       | +      |R|
%    |      |C|        |
%   (i)      | -      |L|
%    |_______|_________|
%
% u = [i];
% x = [x1; x2] = [vc; il];
% y = [vc]
%
% Rappresentazione in variabili di stato:
%    x1' = -1/C * x2 + 1/C * u
%    x2' = 1/L * x1 - R/L * x2
%    y = x1

t=0:0.01:tmax;
u = i0*cos(w0*t);

A = [0,-1/L;1/L,-R/L];
B = [1/C;0];
C = [1,0];
D = 0;

% calcolo numerico dell'evoluzione di stati e uscita del sistema dinamico
system = ss(A, B, C, D);
[y,tsim,x] = lsim(system,u,t,x0)

% confronto grafico dei risultati ottenuti

figure(1), plot(tsim, x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')
figure(2), plot(tsim, x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), xlabel('tempo (in s)'), ylabel('posizione p_A (in m)')
figure(3), plot(tsim, y), grid on, zoom on, title('Evoluzione dell''uscita y'), xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')
