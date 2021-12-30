clear variables
close all
clc

% Si consideri un levitatore magnetico, il cui modello linearizzato nell’intorno 
% del punto di funzionamento desiderato `e dato dal seguente sistema dinamico
% LTI a tempo continuo:
%    dx'(t) = A*dx(t) + B*du(t)
%    dy(t) = C*dx(t) + D*du(t)
% dove du(t), dx(t) e dy(t) costituiscono gli scostamenti delle variabili di
% ingresso-stato-uscita del levitatore rispetto al punto di funzionamento,
% mentre le matrici della rappresentazione in variabili di stato sono:

A = [0,1;900,0];
B = [0;-9];
C = [600,0];
D = 0;

eig_A = eig(A)

lambda1 = -40;
lambda2 = -60;

% Legge di controllo:  u = -Kx(t) + alfa*r(t)
%   ->   x'(t) = (A-BK)x(t) + B*alfa*r(t)

% Mr = [B, A*B]
Mr = ctrb(A,B)
rank_Mr = rank(Mr)  % il rango è massimo, il sistema è completamente raggiungibile,
% POSSO ASSEGNARE GLI AUTOVALORI DI (A-BK)

K = place(A,B,[lambda1,lambda2])

eig_A_meno_BK = eig(A-B*K)   % verifica della corretta assegnazione degli autovalori

alfa = -1

% simulazione del sistema controllato con retroazione statica dello stato
Ars = A-B*K;
Brs = alfa*B;
Crs = C-D*K;
Drs = alfa*D;

tmax = 4;
t = 0:0.001:tmax;
r = sign(sin(2*pi*0.5*t));

sistema_r = ss(Ars, Brs, Crs, Drs);

dx0_1 = [0; 0];
dx0_2 = [0.01; 0];
dx0_3 = [-0.01; 0];

[dy1,tsim,dx1] = lsim(sistema_r,r,t,dx0_1);
[dy2,tsim,dx2] = lsim(sistema_r,r,t,dx0_2);
[dy3,tsim,dx3] = lsim(sistema_r,r,t,dx0_3);

figure,plot(t,r,'k',tsim,dy1,'r',tsim,dy2,'g',tsim,dy3,'b'), grid on

% COMMENTI:
% vediamo che dopo circa 2 decimi di secondo tutti e tre i grafici
% si sovrappongono. Questo vuol dire che il controllo mediante retroazione
% statica dello stato riesce a compensare un diverso posizionamento della
% pallina e riesce ad anullare l'effetto delle diverse condizioni iniziale
% non nulle
% La scelta di alfa = -1 era fatta in modo che l'andamento fosse in fase
% con il riferimento, ma notiamo che a regime l'uscita non coincide con il
% riferimento.

%% Usiamo alfa ottenuto mediante regolazione dell'uscita

alfa = (-((C-D*K)*(A-B*K)^(-1))*B+D)^(-1)

Ars = A-B*K;
Brs = alfa*B;
Crs = C-D*K;
Drs = alfa*D;

tmax = 4;
t = 0:0.001:tmax;
r = sign(sin(2*pi*0.5*t));

sistema_r = ss(Ars, Brs, Crs, Drs);

dx0_1 = [0; 0];
dx0_2 = [0.01; 0];
dx0_3 = [-0.01; 0];

[dy1,tsim,dx1] = lsim(sistema_r,r,t,dx0_1);
[dy2,tsim,dx2] = lsim(sistema_r,r,t,dx0_2);
[dy3,tsim,dx3] = lsim(sistema_r,r,t,dx0_3);

figure,plot(t,r,'k',tsim,dy1,'r',tsim,dy2,'g',tsim,dy3,'b'), grid on

%% 2.2 - Stimatore asintotico dello stato
% Poichè si vuole vedere come convergono i valori delle stime ai valori
% veri delle variabili di stato, occorre applicare lo stimatore asintotico
% ad un sistema asintoticamente stabile
% Il levitatore magnetico è un sistema instabile, applico lo stimatore al
% sistema controllato mediante retroazione statica dello stato

lambda1_oss = -120;
lambda2_oss = -180;

Mo = obsv(Ars,Crs)
rank_Mo = rank(Mo)

L = place(Ars,Crs,[lambda1_oss,lambda2_oss])
