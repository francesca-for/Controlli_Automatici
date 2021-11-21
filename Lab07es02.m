clear all
close all
clc

%                             d
%                             |
%    r(s)--->O----> C(s) --->O----> F(s) ----.---> y(s)
%            ^                               |
%          - |_____________ 1/Kr ____________|


s = tf('s');
F = 5*(s+20)/(s*(s^2+2.5*s+2)*(s^2+15*s+100))

Kr = 2;

% Specifiche:
%  - err a r(t) = t a regime pari al massimo in modulo a 0.05
%  - effetto di d = 1 sull'uscita a regime paria la massimo a 0.02
%  - tempo di salita della risposta al gradino pari a 1s con tolleranza del 10%
%  - sovraelongazione massima della risposta al gradino <= 0.3

%% 
% Il sistema è di tipo 1, per avere errore di inseguimento a t finito non
% nullo non mi serve aggiungere poli nel controllore
% Kga = Kc*Kf/Kr
% err = 0.05 = Kr/Kga = Kr/((Kc*Kf)/Kr)

Kf = dcgain(s*F)

Kc_e = Kr^2/(0.05*Kf)

% effetto del disturbo sul comando con F di tipo 1 ->  ed = alfa/(Kc/Kr)
% ( = ampiezza disturbo / tutto ciò che è in retroazione rispetto al disturbo
Kc_d = 1/(0.02/Kr)

Kc = 160  % Kc minimo, prendo quello più restrittivo tra i due (maggiore)

%segno di Kc
bode(F)
% Kf>0, non ho singolarità a parte reale positiva ed è a stabilità regolare, scelgo Kc POSITIVO

%%
% tempo di salita  ->  wB * ts = 3
wB = 3/1;   % [0.9 - 1.1]
wcd = 0.63*wB
wcd = 1.9 % approssimato
%%
% sovraelongazione max 0.3  ->  (1+s')/Mr = 0.9   Mr in unità naturali
Mr = 1.3/0.9
Mr_db = 20*log10(Mr)
Mr_db = 3.2

mf = 60-5*(Mr_db)  % da Nichols 40 gradi circa
mf = 45  % approssimato

Ga1 = Kc*F/Kr
figure,bode(Ga1)
[m1,f1] = bode(Ga1,wcd)

% devo recuperare circa 75 gradi e far scendere il modulo di più di 2.6 dB
% (le reti derivative lo faranno salire ancora)

%% RETI DERIVATIVE - 2 da 5 sul fronte di salita
md = 6;
% figure,bode((1+s)/(1+s/md)) % diagramma della rete
xd = 1.3;
taud = xd/wcd;
Rd = (1+taud*s)/(1+taud/md*s);

Ga2 = Ga1*Rd^2;

figure,bode(Ga2)
[m2,f2] = bode(Ga2,wcd)

%% RETE INTEGRATIVA
mi = 21.5;
% figure,bode((1+s/mi)/(1+s))
xi = 230;
taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);

Ga3 = Ga2*Ri;

figure,margin(Ga3)

%% Verifica specifiche

C = Kc*Rd^2*Ri;
Ga_fin = C*F/Kr; 

W = feedback(C*F,1/Kr);

figure,step(W)  % devo tener conto che il valore di regime è 2 
figure,step(W/Kr)        %  OPPURE NORMALIZZO RISPETTO A Kr

% overshoot 26%, quindi soddisfa le specifiche
% ts = 0.93, accettabile pure questo

open_system('Lab07es02_schema');

%% Parte 2

% Valore massimo del comando con r(t) = gradino unitario

% Può essere calcolato a priori perchè non ho aggiunto poli nell'origine nel controllore
u_max = Kc*md^2/mi

% simulazione con Matlab
Wu = feedback(C,F/Kr);
figure,step(Wu)
% oppure in simulink


% Verifica della wB e picco di risonanza

% Basta fare i DdB della funzione di catena chiusa
% Essendoci Kr diverso da 1, quindi il valore iniziale della W in w=0 non
% sarà pari a 1 ma a 2, ovvero circa 6 in dB
% Il valore del picco di risonanza dovrà quindi determinato prendendo il
% massimo valore raggiunto dal modulo e sottraendone il valore iniziale
% Il valore di wB dovrà essere cercato come il valore al quale il modulo è
% sceso di 3 dB rispetto al valore iniziale
% In alternativa posso normalizzare W rispetto al suo valore iniziale, ovvero Kr
figure,bode(W/Kr)


