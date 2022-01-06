clear variables
close all
clc

s = tf('s');
F = 10/(s*(s+2)*(s+4))

Kr = 1
Kc = 4
Ga1 = Kc*F
bode(Ga1)

wc = 2;
[m,f] = bode(Ga1,wc)

%% rete anticipatrice
md = 3;  % mi consente un recupero massimo di fase di 30 gradi, quindi 5 gradi in piu' del minimo necessario
xd = sqrt(md);
taud = xd/wc;
Rd = (1+taud*s)/(1+taud/md*s);
Ga2 = Ga1 * Rd;
[m1,f2] = bode(Ga2,wc)  % m1 = 2,74, approssimo a 2.8

%% rete attenuatrice
mi = 2.8;
figure,bode((1+s/mi)/(1+s))
xi = 40;
taui = xi/wc;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2 * Ri;

figure,margin(Ga3)

C = Kc * Rd * Ri;
W = feedback(C*F,1);
figure,bode(W)  % per specifica sulla banda passante
figure,step(W)  % per specifica sulla risposta al gradino

% preso da: L_12_05_21_reti_integro-derivative

%% Attività sul comando - calcolo (solo se non ho poli in s=0 nel controllore)
umax = Kc*md/mi;   % prodotto delle reti derivative / prodotto delle integrative

%% Attività sul comando - simulato con Matlab
Wu = C*feedback(1,Ga3)   % Wu = C*1/(1+Ga3)
figure,step(Wu)  % il valore iniziale è anche il massimo, lo ottengo con peak response

%% Attività sul comando - simulato con Simulink
open_system('L_12_05_21_effetti_sul_comando_schema')
