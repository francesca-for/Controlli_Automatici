%% Stimatore asintotico dello stato
clear variables
close all
clc

% Modello linearizzato del levitatore magnetico controllato mediante retroazione statica dello stato
A = [0,1;-2400,-100];
B = [0;9];
C = [600,0];
D = 0;

% Poichè si vuole vedere come convergono i valori delle stime ai valori
% veri delle variabili di stato, occorre applicare lo stimatore asintotico
% ad un sistema asintoticamente stabile
% Il levitatore magnetico è un sistema instabile, applico lo stimatore al
% sistema controllato mediante retroazione statica dello stato

lambda1_oss = -120;
lambda2_oss = -180;

Mo = obsv(A,C)
rank_Mo = rank(Mo)  % rango è massimo, il sistema è completamete osservabile

L = place(A',C',[lambda1_oss,lambda2_oss])'  % faccio la trasposta del risultato perchè place restituisce sempre dei vettori riga

eig_A_meno_LC = eig(A-L*C)   % verifica della corretta assegnazione degli autovalori

Atot = [A, zeros(size(A)); L*C, A-L*C];
Btot = [B; B];
Ctot = [C, zeros(size(C)); zeros(size(C)), C];
Dtot = [D; D];

% Simulazione del sistema complessivo

sistemaTot = ss(Atot, Btot, Ctot, Dtot);

t = 0:0.001:4;
r = sign(sin(2*pi*0.5*t));

x0_1 = [0; 0];
x0_2 = [0.01; 0];
x0_3 = [-0.01; 0];

x0_oss = [0;0];   % condizione iniziale dello stimatore asintotico

x0tot_1 = [x0_1; x0_oss];
x0tot_2 = [x0_2; x0_oss];
x0tot_3 = [x0_3; x0_oss];

[ytot1, tsim1, xtot1] = lsim(sistemaTot, r, t, x0tot_1);
[ytot2, tsim2, xtot2] = lsim(sistemaTot, r, t, x0tot_2);
[ytot3, tsim3, xtot3] = lsim(sistemaTot, r, t, x0tot_3);

% figure,plot(tsim1, xtot1, 'r', tsim2, xtot2, 'g', tsim3, xtot3, 'b');
% figure,plot(t, r, 'k', tsim1, ytot1, 'r', tsim2, ytot2, 'g', tsim3, ytot3, 'b');


figure, plot(t,r,'k',tsim1,ytot1(:,1),'r',tsim1,ytot1(:,2),'c--', ...
                       tsim2,ytot2(:,1),'g',tsim2,ytot2(:,2),'y--', ...
                       tsim3,ytot3(:,1),'b',tsim3,ytot3(:,2),'m--'), grid on,
title(['Risposta y(t) del sistema e sua stima y_{oss}(t) al variare di x(t=0)']),
legend('r(t)','y(t) per x_0^{(1)}', 'y_{oss}(t) per x_0^{(1)}',...
              'y(t) per x_0^{(2)}', 'y_{oss}(t) per x_0^{(2)}',...
              'y(t) per x_0^{(3)}', 'y_{oss}(t) per x_0^{(3)}')

figure, plot(t,r,'k',tsim1,ytot1(:,1),'r',tsim1,ytot1(:,2),'c--', ...
                       tsim2,ytot2(:,1),'g',tsim2,ytot2(:,2),'y--', ...
                       tsim3,ytot3(:,1),'b',tsim3,ytot3(:,2),'m--'), grid on,
title(['Risposta y(t) del sistema e sua stima y_{oss}(t) al variare di x(t=0)']),
legend('r(t)','y(t) per x_0^{(1)}', 'y_{oss}(t) per x_0^{(1)}',...
              'y(t) per x_0^{(2)}', 'y_{oss}(t) per x_0^{(2)}',...
              'y(t) per x_0^{(3)}', 'y_{oss}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(tsim1,xtot1(:,1),'r',tsim1,xtot1(:,3),'c--', ...
             tsim2,xtot2(:,1),'g',tsim2,xtot2(:,3),'y--', ...
             tsim3,xtot3(:,1),'b',tsim3,xtot3(:,3),'m--'), grid on,
title(['Stato x_1(t) del sistema e sua stima x_{oss,1}(t) al variare di x(t=0)']),
legend('x_1(t) per x_0^{(1)}', 'x_{oss,1}(t) per x_0^{(1)}',...
       'x_1(t) per x_0^{(2)}', 'x_{oss,1}(t) per x_0^{(2)}',...
       'x_1(t) per x_0^{(3)}', 'x_{oss,1}(t) per x_0^{(3)}')

figure, plot(tsim1,xtot1(:,1),'r',tsim1,xtot1(:,3),'c--', ...
             tsim2,xtot2(:,1),'g',tsim2,xtot2(:,3),'y--', ...
             tsim3,xtot3(:,1),'b',tsim3,xtot3(:,3),'m--'), grid on,
title(['Stato x_1(t) del sistema e sua stima x_{oss,1}(t) al variare di x(t=0)']),
legend('x_1(t) per x_0^{(1)}', 'x_{oss,1}(t) per x_0^{(1)}',...
       'x_1(t) per x_0^{(2)}', 'x_{oss,1}(t) per x_0^{(2)}',...
       'x_1(t) per x_0^{(3)}', 'x_{oss,1}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);

figure, plot(tsim1,xtot1(:,2),'r',tsim1,xtot1(:,4),'c--', ...
             tsim2,xtot2(:,2),'g',tsim2,xtot2(:,4),'y--', ...
             tsim3,xtot3(:,2),'b',tsim3,xtot3(:,4),'m--'), grid on,
title(['Stato x_2(t) del sistema e sua stima x_{oss,2}(t) al variare di x(t=0)']),
legend('x_2(t) per x_0^{(1)}', 'x_{oss,2}(t) per x_0^{(1)}',...
       'x_2(t) per x_0^{(2)}', 'x_{oss,2}(t) per x_0^{(2)}',...
       'x_2(t) per x_0^{(3)}', 'x_{oss,2}(t) per x_0^{(3)}')

figure, plot(tsim1,xtot1(:,2),'r',tsim1,xtot1(:,4),'c--', ...
             tsim2,xtot2(:,2),'g',tsim2,xtot2(:,4),'y--', ...
             tsim3,xtot3(:,2),'b',tsim3,xtot3(:,4),'m--'), grid on,
title(['Stato x_2(t) del sistema e sua stima x_{oss,2}(t) al variare di x(t=0)']),
legend('x_2(t) per x_0^{(1)}', 'x_{oss,2}(t) per x_0^{(1)}',...
       'x_2(t) per x_0^{(2)}', 'x_{oss,2}(t) per x_0^{(2)}',...
       'x_2(t) per x_0^{(3)}', 'x_{oss,2}(t) per x_0^{(3)}')
axis_orig=axis;
axis([0,0.2,axis_orig(3:4)]);


% COMMENTI: 
% grafico 1: uscite e riferimento
% grafico 2: primi 2 decimi di secondo del primo grafico, le risposte
%            stimate sono rappresentate tratteggiate. Notiamo che queste partono 
%            da zero ma dopo 0.02 secondi coincidono con le uscite reali
% grafico 3: variabile di stato x1, notiamo che ha un andamento analogo a
%            quello di y. Guardando la matrice C vediamo che vale [600,0],
%            quindi l'uscita vale 600 volte x1 (sono proporzionali)
% grafico 5: x2 è la velocità, Non viene misurata direttamente. L'andamento
%            zoomato è rappresentato nel grafico 6 (primi 2 decimi di secondo di simulazione)
%            Dopo circa 0.04 secondi lo stima di x2 coincide con il valore di x2 

