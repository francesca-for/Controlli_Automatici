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

% comando ss crea uno state-space model, un oggetto che contiene la
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
%   F <---| M |---·]---•---NNN---|//
%          ---                   |//
%  <-----------------------------|//

% u = [F];   x = [x1; x2] = [v; pa];   y = [v]
% Rappresentazione in variabili di stato:
%    x1' = -K/M * x2 + 1/M * u
%    x2' = x1 - K/B * x2
%    y = x1

M = 0.2;
F0 = 1;
w0 = 0;

t=0:0.01:10;

F = F0*cos(w0*t);
for es = 1:8
    pause
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
    
    A = [0,-k/M;1,-k/beta];
    B = [1/M;0];
    C = [1,0];
    D = [0];
    
    system = ss(A, B, C, D);
    
    figure,lsim(system,F,t,x0)
end

w0 = 4
F2 = F0*cos(w0*t);
for es = 1:8
    pause
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
    
    A = [0,-k/M;1,-k/beta];
    B = [1;0];
    C = [1,0];
    D = [0];
    
    system2 = ss(A, B, C, D);
    
    figure,lsim(system2,F2,t,x0)
end


