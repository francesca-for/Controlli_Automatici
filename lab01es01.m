clear variables
close all
clc

es=menu('Simulazione della risposta del sistema meccanico',...
        '1.a) beta=0.1, K=2,  x0=[0;0],   F(t)=1;',...
        '1.b) beta=0.01, K=2,  x0=[0;0],   F(t)=1;',...
        '1.c) beta=10,   K=20, x0=[0;0],   F(t)=1;',...
        '1.d) beta=0.1,  K=2,  x0=[0;0.2], F(t)=1;',...
        '2.a) beta=0.1,  K=2,  x0=[0;0],   F(t)=cos(4t);',...
        '2.b) beta=0.01, K=2,  x0=[0;0],   F(t)=cos(4t);',...
        '2.c) beta=10,   K=20, x0=[0;0],   F(t)=cos(4t);',...
        '2.d) beta=0.1,  K=2,  x0=[0;0.2], F(t)=cos(4t)' );

switch es
        case 1, beta=0.1;  k=2;  x0=[0;0];   w0=0;
        case 2, beta=0.01; k=2;  x0=[0;0];   w0=0;
        case 3, beta=10;   k=20; x0=[0;0];   w0=0;
        case 4, beta=0.1;  k=2;  x0=[0;0.2]; w0=0;
        case 5, beta=0.1;  k=2;  x0=[0;0];   w0=4;
        case 6, beta=0.01; k=2;  x0=[0;0];   w0=4;
        case 7, beta=10;   k=20; x0=[0;0];   w0=4;
        case 8, beta=0.1;  k=2;  x0=[0;0.2]; w0=4;
end

m = 0.2;
f0 = 1;

tmax = 20;

% Comando ss crea uno state-space model, un oggetto che contiene la
% rappresentazione in variabili di stato del sistema.
% SYS = ss(A,B,C,D);

% comando lsim(SYS,U,T,X0) simula il comportamento di un sistema LTI
% U vettore degli ingressi, T vettore degli istanti temporali in cui voglio
% effettuare la simulazione e X0 è presente se ho condizioni iniziali non nulle
% Es:  t=0:0.01:5;  u=sin(t);
% lsim in questa forma plotta la risposta, non ci restituisce nulla.
% Per far si' che ci restituisca qualcosa va usato nella forma:
% [Y,T,X]=lsim(SYS,U,T,X0);
% X e' il vettore dell'evoluzione delle variabili di stato

%          ___     B   A    K    |//
%   F <---| M |---·]---•---NNN---|//            u = [F];
%          ---                   |//            x = [x1; x2] = [v; pa];
%  <-----------------------------|//            y = [v]
%
% Rappresentazione in variabili di stato:
%    x1' = -K/M * x2 + 1/M * u
%    x2' = x1 - K/B * x2
%    y = x1

t=0:0.01:tmax;
u = f0*cos(w0*t);

A = [0,-k/m;1,-k/beta];
B = [1/m;0];
C = [1,0];
D = 0;

% calcolo numerico dell'evoluzione di stati e uscita del sistema dinamico
system = ss(A, B, C, D);
[y,tsim,x] = lsim(system,u,t,x0)

% confronto grafico dei risultati ottenuti

figure(1), plot(tsim, x(:,1)), grid on, zoom on, title('Evoluzione dello stato x_1'), xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')
figure(2), plot(tsim, x(:,2)), grid on, zoom on, title('Evoluzione dello stato x_2'), xlabel('tempo (in s)'), ylabel('posizione p_A (in m)')
figure(3), plot(tsim, y), grid on, zoom on, title('Evoluzione dell''uscita y'), xlabel('tempo (in s)'), ylabel('velocità v (in m/s)')
