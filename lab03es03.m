clear variables
close all
clc

% Si consideri un levitatore magnetico, il cui modello linearizzato nell'intorno del punto 
% di funzionamento desiderato `e dato dal seguente sistema dinamico LTI a tempo continuo:
% dx'(t) = Adx(t) + Bdu(t)
% dy(t) = Cdx(t) + Ddu(t)

A = [0,1;900,0];
B = [0;-9];
C = [600,0];
D = 0;

% Progettare un regolatore tale che gli autovalori dell'osservatore dello stato siano
% lambda1_o = -120, lambda2_o = -180 e gli autovalori imposti dalla retrazione degli 
% stati stimati siano in lambda1 = -40, lambda2 = -60 
lambda = [-40, -60];
lambda_o = [-120, -180];
%% Raggiungibilità e osservabilità

Mr = ctrb(A,B)
rank(Mr)
Mo = obsv(A,C)
rank(Mo)
% Entrambe le matrici hanno rango massimo quindi il sistema è completamente
% raggiungibile e osservabile

% Legge di controllo:
%  du(t) = -K*dx_stim + alfa*r(t)

%% Progetto di K

K = place(A,B,lambda);
lambda
eig(A-B*K)  % controllo il corretto posizionamento degli autovalori

%% Progetto di L

L = place(A',C',lambda_o)';
lambda_o
eig(A-L*C)  % controllo il corretto posizionamento degli autovalori

%% Simstema complessivo

alfa = -1;

A_tot = [A, -B*K; L*C, A-B*K-L*C];
B_tot = [alfa*B; alfa*B];
C_tot = [C, -D*K; zeros(size(C)), C-D*K];
D_tot = [alfa*D; alfa*D];

%% Simulazione dell'evoluzione dello stato e dell'uscita

system = ss(A_tot, B_tot, C_tot, D_tot);

t = 0:0.001:5;
r = sign(sin(2*pi*0.5*t));

dx0_1 = [0;0];
dx0_2 = [0.01;0];
dx0_3 = [-0.01;0];
dx0_oss = [0;0];
dx0tot_1 = [dx0_1; dx0_oss];
dx0tot_2 = [dx0_2; dx0_oss];
dx0tot_3 = [dx0_3; dx0_oss];

[yreg_1, treg1, xreg_1] = lsim(system,r,t,dx0tot_1);
[yreg_2, treg2, xreg_2] = lsim(system,r,t,dx0tot_2);
[yreg_3, treg3, xreg_3] = lsim(system,r,t,dx0tot_3);


figure, plot(t, r, 'k', treg1, yreg_1(:,1), 'r', treg1, yreg_1(:,2), 'm', ...
                        treg2, yreg_2(:,1), 'c', treg2, yreg_2(:,2), 'b', ...
                        treg3, yreg_3(:,1), 'g', treg3, yreg_3(:,2), 'k-.');

legend('r(t)','\deltay(t) per \deltax_0^{(1)}', '\deltay_{oss}(t) per \deltax_0^{(1)}', ...
              '\deltay(t) per \deltax_0^{(2)}', '\deltay_{oss}(t) per \deltax_0^{(2)}', ...
              '\deltay(t) per \deltax_0^{(3)}', '\deltay_{oss}(t) per \deltax_0^{(3)}');
title('Uscita \deltay(t) del sistema controllato mediante regolatore e sua stima \deltay_{oss}(t) al variare di \deltax_{0}');


figure(2), plot(treg1, xreg_1(:,1), 'r', treg1, xreg_1(:,2), 'm', ...
                treg2, xreg_2(:,1), 'c', treg2, xreg_2(:,2), 'b', ...
                treg3, xreg_3(:,1), 'g', treg3, xreg_3(:,2), 'k');

legend('\deltay(t) per \deltax_0^{(1)}', '\deltay_{oss}(t) per \deltax_0^{(1)}', ...
       '\deltay(t) per \deltax_0^{(2)}', '\deltay_{oss}(t) per \deltax_0^{(2)}', ...
       '\deltay(t) per \deltax_0^{(3)}', '\deltay_{oss}(t) per \deltax_0^{(3)}');
title('Stato \deltax(t) del sistema controllato mediante regolatore e sua stima \deltax_{oss,1}(t) al variare di \deltax_{0}');

% TODO: CONTROLLARE NELLE SOLUZIONI COSA PLOTTARE NEL SECONDO E TERZO GRAFICO
figure(3), plot(treg1, xreg_1(:,1), 'r', treg1, xreg_1(:,2), 'm', ...
                treg2, xreg_2(:,1), 'c', treg2, xreg_2(:,2), 'b', ...
                treg3, xreg_3(:,1), 'g', treg3, xreg_3(:,2), 'k');

legend('\deltay(t) per \deltax_0^{(1)}', '\deltay_{oss}(t) per \deltax_0^{(1)}', ...
       '\deltay(t) per \deltax_0^{(2)}', '\deltay_{oss}(t) per \deltax_0^{(2)}', ...
       '\deltay(t) per \deltax_0^{(3)}', '\deltay_{oss}(t) per \deltax_0^{(3)}');
title('Stato \deltax(t) del sistema controllato mediante regolatore e sua stima \deltax_{oss,2}(t) al variare di \deltax_{0}');
