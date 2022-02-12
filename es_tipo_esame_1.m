clear variables
close all
clc

s = tf('s');

F1 = 30/(s+15)
F2 = (3*s+3)/(s^3+10*s^2+24*s)

Kr = 1;

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

Ga1 = F1*F2/Kr;
Kga1 = dcgain(F1*s*F2/Kr)
%%
% sistema di tipo 1, non devo aggiungere poli in 0 nel controllore
% err = Kr/Kga
Kc1 = Kr/(Kga1*0.1)
% effetto di d1 limitato --> eff_d1 = 1/(Kc*Kf1)  --> 
Kc2 = 1/(Kf1*0.05)
% effetto di d2 = 0 perchè ho un polo nei blocchi a monte
Kc = max(Kc1,Kc2)     % ---> poichè Kc = 40, eff_d1 = 1/(Kf1*Kc) = 0.0125

zeri = zero(Ga1)
poli = pole(Ga1)
% f0 = -90, finf = -90 -90*3 +90 = -270
%%
figure, bode(Ga1),grid on
% Kga1 positivo , sistema a minima rotazione di fase, una sola wc e una
% sola w con fase -180  --> posso scegliere Kc > 0
figure,nyquist(Ga1);
%%
Ga2 = Kc/Kr*F1*F2

wb = 20;
wc = 0.63*wb
wc = 12.6  % approssimata

Mr = (1+0.2)/0.9;
Mr_dB = 20*log10(Mr)
mf = 60 - 5*(Mr_dB)
% fase minima da nichols = circa 42 gradi
mf = 48;   % approssimata
%%
figure, bode(Ga2),grid on
[m,f] = bode(Ga2, wc)
%%
% devo guadagnare 51+ gradi
md = 12;
figure,bode((1+s)/(1+s/md)), grid on
xd = 2;
taud = xd/wc;

Rd = (1+s*taud)/(1+s*taud/md)
%%
Ga3 = Ga2 * Rd
[m3,f3] = bode(Ga3,wc)
%% 
mi = 2.2;
figure,bode((1+s/mi)/(1+s)), grid on
xi = 50;
taui = xi/wc;
Ri = (1+s*taui/mi)/(1+s*taui)
%%
Ga4 = Ga3 * Ri
figure,margin(Ga4),grid on

%% provo a chiudere l'anello
C = Kc*Rd*Ri;
W = feedback(C*F1*F2,1/Kr);

figure,step(W), grid on;
figure,bode(W),grid on;

%%
open_system('es_tipo_esame_1_schema');

%% valutare l'errore di inseguinmento massimo a regime a r(t)=sin(0.2t) in assenza di disturbi

wr_sin = 0.2;
sens = feedback(1,Ga4);

[m_sens, f_sens] = bode(sens,wr_sin);
err_max_sin = Kr * m_sens

%% 1.3) Discretizzazione
wb = 21.2
T = 2*pi/(20*wb)
T = 0.01;  % approssimato

Gazoh = Ga4/(1+s*T/2);
figure,margin(Gazoh);

Cz = c2d(C, T, 'tustin')

%% analisi della risposta al gradino del sistema discretizzato
open_system('es_tipo_esame_1_schema');



%% ESERCIZIO 2

clear variables
close all
clc
s = tf('s');

Ga = 3*(1+s)*(1+s/2)/((1-s)*(1+s/15)*(1+s/45))
Kga = dcgain(Ga)
figure,nyquist(Ga)


%% ESERCIZIO 3

clear variables
close all
clc
s = tf('s');

F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000)

% Posso utilizzare metodo di taratura in anello aperto perchè il sistema è
% già asintoticamente stabile e non presenta sovraelongazione

Kf = 4.5;
thetaf = 0.01;
tauf = 0.26-thetaf;

N=10;

Kp = 1.2*tauf/(Kf*thetaf)
Ti = 2*thetaf
Td = 0.5*thetaf

PID = Kp*(1+1/(Ti*s)+Td*s/(1+Td*s/N))

%% sovraelongazione e ts

W = feedback(PID*F,1);
figure,step(W/dcgain(W)),grid on;

% sovraelongazione del 40.1%
% ts = 0.0202