%% 3.1 - ANALISI A TEMPO CONTINUO

clear variables
close all
clc

% Sistema LTI TC con rappresentazione in variabili di stato:
% x'(t) = Ax(t) + Bu(t)
% y(t) = Cx(t) + Du(t)

A1 = [-0.5, 1; 0, -2];
A2 = [-0.5, 1; 0, -1];
A3 = [-0.5, 1; 0, 0];
A4 = [-0.5, 1; 0, 1];

B = [1;1];
C = [1,3];
D = 0;

% Simulare l’evoluzione dello stato x (t) a partire da una arbitraria
% condizione iniziale x0 != [0;0] (ad esempio [1;2]) ed assumendo nullo l ingresso:
% u(t) = u_eq = 0, ∀t > 0.

x0 = [1;2];
t = 0:0.01:20;
u = 0*t;

% A1 e A2: autovalori a Re < 0, ho modi esponenzialmente convergenti quindi
%             il sistema è asintoticamente stabile
% A3: ho un autovalore con Re<0 -> modo esp. convergente, e un autovalore
%         con Re=0 e molteplicità algebrica 1, il sistema è
%         semplicemente stabile
% A4: ho un autovalore a Re>0 -> modo esp. divergente, il sistema è instabile

sistema1 = ss(A1,B,C,D);
sistema2 = ss(A2,B,C,D);
sistema3 = ss(A3,B,C,D);
sistema4 = ss(A4,B,C,D);

[y1,tsim1,x1] = lsim(sistema1, u, t, x0);
[y2,tsim2,x2] = lsim(sistema2, u, t, x0);
[y3,tsim3,x3] = lsim(sistema3, u, t, x0);
[y4,tsim4,x4] = lsim(sistema4, u, t, x0);

figure(1),plot(tsim1,x1,'r');
figure(2),plot(tsim1,y1,'r');
pause
figure(1),plot(tsim2,x2,'g'); 
figure(2),plot(tsim2,y2,'g');
pause;
figure(1),plot(tsim3,x3,'b');
figure(2),plot(tsim3,y3,'b');
pause;
figure(1),plot(tsim4,x4,'m');
figure(2),plot(tsim4,y4,'m');
pause

%% 3.1 - ANALISI A TEMPO DISCRETO

clear variables
close all
clc

% Sistema LTI TD con rappresentazione in variabili di stato:
% x(k+1) = Ax(k) + Bu(k)
% y(k) = Cx(k) + Du(k)

A1 = [-0.5, 1; 0, -2];
A2 = [-0.5, 1; 0, -1];
A3 = [-0.5, 1; 0, 0];
A4 = [-0.5, 1; 0, 1];

B = [1;1];
C = [1,3];
D = 0;

x0 = [1;2];
t = 0:1:20;
u = 0*t;

% A1: ho un autovalore a |z|>1, il sistema è instabile
% A2: un autovalore con |z|<1 e uno con |z|=1, il sistema è semplicemente stabile
% A3: ho due autovalori con |z|<1, il sistema è asintoticamente stabile
% A4: come caso 2, il sistema è semplicemente stabile

sistema1 = ss(A1,B,C,D,-1);
sistema2 = ss(A2,B,C,D,-1);
sistema3 = ss(A3,B,C,D,-1);
sistema4 = ss(A4,B,C,D,-1);

[y1,tsim1,x1] = lsim(sistema1, u, t, x0);
[y2,tsim2,x2] = lsim(sistema2, u, t, x0);
[y3,tsim3,x3] = lsim(sistema3, u, t, x0);
[y4,tsim4,x4] = lsim(sistema4, u, t, x0);

figure(1),plot(tsim1,x1,'r');
figure(2),plot(tsim1,y1,'r');
pause
figure(1),plot(tsim2,x2,'g'); 
figure(2),plot(tsim2,y2,'g');
pause;
figure(1),plot(tsim3,x3,'b');
figure(2),plot(tsim3,y3,'b');
pause;
figure(1),plot(tsim4,x4,'m');
figure(2),plot(tsim4,y4,'m');
pause


