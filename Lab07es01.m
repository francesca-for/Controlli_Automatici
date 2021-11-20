clear all
close all
clc

s = tf('s');
F = 13.5*(s+4)*(s+10)/(s+3)^3;
Kf = dcgain(F)  % >0, non contribuisce nel calcolo della fase iniziale

Kr=1;

zeri = zero(F)
poli = pole(F)

%% SPECIFICHE:
% er,inf <= 0.01  con  r(t) = t
% effetto del disturbo d = 1 sull'uscita pari al massimo in modulo a 0.02
% banda passante del sistema retroazionato pari a circa 6 rad/s con tolleranza del 15%
% picco di risonanza della risposta in frequenza ad anello chiuso <= 2 dB

% sistema di tipo 0, per avere errore di inseguimento finito non nullo a una rampa devo inserire un polo in zero nel controllore
h=1;
% per avere effetto del disturbo finito mi basterebbe sistema di tipo 0, con il polo aggiunto in C avremo effetto nullo

% err = Kr/Kga = Kr/(Kc*Kf/Kga)
Kc = 1/(0.01*Kf)

% segno di Kc: il sistema è stabilità regolare, Kf positivo e non ho singolarità a parte reale positiva
bode(F/s)  % vedo che ho una sola wc e una sola pulsazione a cui la fase vale -180
% quondi scelgo Kc POSITIVO

% specifica su wB
wcd = 6 * 0.63
wcd = 3.8;

% margine di fase:
% dalla carta di Nichols seguo la curva costante a 2dB, interseca l'asse
% 0dB a circa -135 gradi  ->  mf = 45 minimo
mf = 60-5*(2)  % dalle relazioni approssimate

%%
Ga = (Kc/s)*F/Kr
figure,bode(Ga)

[m,f] = bode(Ga,wcd)

% In corrispondenza della wcd abbiamo fase di circa -180 e modulo di circa
% 20 dB, piuttosto elevato
% Devo recuperare 50 gradi e so già che dovrò mettere una rete attenuatrice
% con parametro mi > 10 (già così sono al limite, le reti derivative lo
% faranno crescere ancora)

%% Reti derivative
% provo con 2 reti da 4 sul fronte di salita

md = 4;
% bode((1+s)/(1+s/4))   % per trovare xd
xd = 1;
taud = xd/wcd;
Rd = (1+taud*s)/(1+taud/md*s);

Ga1 = Ga*Rd^2;

figure,bode(Ga1)

[m1,f1] = bode(Ga1,wcd)

%% Reti attenuatrici

mi = 17.4;
% bode((1+s/mi)/(1+s))  % poer trovare xi
xi = 150;
taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);

Ga2 = Ga1*Ri;

figure,margin(Ga2)


%% verifica delle specifiche

C = (Kc/s)*Rd^2*Ri;
Ga3 = C*F/Kr;

W = feedback(C*F,1/Kr);

figure,bode(W)  % picco = 1.7 e wb = 5.7, entrambe le specifiche sono soddisfatte

open_system('Lab07es01_schema')

%% Parte 2

% errore di inseguimento massimo a r = sin(0.1*t)
sens = feedback(1,Ga3);
Wsens_e = 1/Kr * sens;

[ms1, fs1] = bode(Wsens_e,0.1)

% attenuazione con la quale vengono riportati sull'uscita disturbi sinusoidali entranti insieme al riferimento r(t) e aventi pulsazione maggiore o uguale a 100 rad/s
[ms2, fs2] = bode(Wsens_e,100)
