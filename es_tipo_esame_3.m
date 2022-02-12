clear variables
close all
clc
s = tf('s');

Tp = 1;  % blocco in retroazione
A = 9;

Gp = -0.65/(s^3+4*s^2+1.75*s)
% sistema di tipo 1

Kgp = dcgain(s*Gp)   % guadagno negativo

Ga1 = Gp*A*Tp
Kga1 = A*Kgp*Tp

%% specifiche statiche
% |err,inf| <= 0.2   NON devo aggiungere poli nel controllore
% Kc = Ktp/Kga
% Kga = A*Kgp*Kc/Tp;
Kc3 = abs(Tp/(Kgp*A*0.2/Tp))

% eff_d1 = 6*10^-4
d1 = 5.5*10^-3;
Kc1 = abs(d1/(A/Tp*6*10^(-4)))

% eff_d2 = 1.5*10^-3        % AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIUTO
d2 = d1;
Kc2 = abs(d2/(A*6*10^(-4)))     % a quanto pare è sbagliato

Kc = max(Kc1,Kc2);
Kc = max(Kc,Kc3)

%%
zeri = zero(Ga1)
poli = pole(Ga1)
% f0 = -180 -90
% finf = -270 -180
figure, bode(Ga1),grid on

% segno di Kc, devo vedere Nyquist perchè il sistema non è a stabilità regolare
figure,nyquist(Ga1),grid on
Kc = -Kc   % scelgo Kc < 0
Kc = -1.5
%% specifiche dinamiche
wb = 3/1;
wc = 0.63*wb
wc = 2.1   % approssimata

Mr = (1+0.3)/0.9;
Mr_dB = 20*log10(Mr)
mf = 60 - 5*Mr_dB
mf = 45   % approssimata, accettabile (da nichols minimo = 38 circa)

%%
Ga2 = Ga1*Kc
figure,bode(Ga2),grid on

%% reti anticipatrici
% devo recuperare 61 gradi circa
md = 4;
figure,bode((1+s)/(1+s/md)),grid on;
xd = 1.1;
taud = xd/wc;
Rd = (1+taud*s)/(1+taud*s/md)

%%
Ga3 = Ga2*Rd^2
figure,bode(Ga3), grid on

%% Rete attenuatrice

% non serve WTF??

%% 
figure,margin(Ga3), grid on

%%
C = Kc*Rd^2

W = feedback(C*A*Gp,Tp)
zero(W)
pole(W)   % controllo che il sistema sia stabile
figure,bode(W/dcgain(W)),grid on;
figure,step(W/dcgain(W)),grid on;
%% 
open_system('es_tipo_esame_3_schema');

%% 1.2)
% Sovraelongazione massima della risposta in frequenza = 2.41 dB
% wb = 3.75 rad/s
% Sovraelongazione massima della risposta nel tempo = 25.2%
% ts = 0.803

% valore massimo del comando che può essere indotto da dp
% TODO: da svolgere

%% 1.3) Discretizzazione

T = 2*pi/20*3.75   % troppo
T = 0.01

Ga_zoh = c2d(Ga3,T,'zoh');
figure,margin(Ga_zoh),grid on;

Cz_tustin = c2d(C, T, 'tustin');
Cz_zoh = c2d(C, T, 'zoh');
Cz_matched = c2d(C, T, 'match');

open_system('es_tipo_esame_3_schema');

