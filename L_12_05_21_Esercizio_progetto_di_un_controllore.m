clear all
close all
clc

s=tf('s');
F1 = (s+40)/(s+2)
F2 = 80/(s^2+13*s+256)
Kr = 1;

d1 = 0.5;
d2 = 0.2;

%                                          d1               d2
%                 ______        ______     |     ______     |
%   r(s)--->O--->| C(s) |--u-->|  F1  |--->0--->|  F2  |--->0---.-->y
%        +  ^     ------        ------           ------         |
%         - |_______________________[ 1/Kr ]____________________|

% Progettare il controllore C(s) in modo che il sistema retroazionato
% soddisfi le seguenti specifiche: 
%   * errore di inseguimento alla rampa unitaria in regime permanente pari
%     al massimo in modulo a 0.04, in assenza di disturbi 
%   * effetto del disturbo d1 sull'uscita in regime permanente pari al massimo in modulo a 0.01
%   * effetto del disturbo d2 sull'uscita in regime permanente pari al massimo in modulo a 0.01
%   * tempo di salita della risposta al gradino unitario pari a circa 0.2s
%     (la specifica è ritenuta soddisfatta se l'errore commesso è inferiore in modulo al 20%) 
%   * sovraelongazione massima della risposta al gradino unitario minore o
%     uguale al 35% 

% Tutte e due le funzioni sono di tipo zero
Kf1 = dcgain(F1)
Kf2 = dcgain(F2)  % entrambi > 0

%% Specifiche statiche

% Errore inseguimento = 0.04 con r(t) = t
% Devo inserire un polo in 0 nel controllore per avere errore non infinito
% Per avere effetto finito dei disturbi non ho bisogno di poli nell'origine
% Dovendo inserire un polo per l'errore di inseguimento, d1 e d2 avranno effetto nullo

% err = Kr/Kga = 1/(|Kc|*Kf1*Kf2) <= 0.04
Kc = 1/(0.04*Kf1*Kf2)

% Studio il segno di Kc.
% Il sistema è a minima rotazione di fase
bode(F1*F2/s)
% il sistema è a stabilità regolare, posso scegliere Kc>0

Ga1 = Kc/s * F1 * F2

%% Specifiche dinamiche

% Tempo di salita = 0.2
% ts * wb = 3  ->
wb = 3/0.2
wcd = 0.63 * wb
wcd = 9.5   % approssimiamo

% Sovraelongazione massima <= 35%
% (1+sovrael)/Mr = 0.9  ->  Mr <= 1.35/0.9 in unità naturali
Mr = 20*log10(1.35/0.9)  % picco di risonanza
Mr = 3.5  % valore approssimato

%%
% Dalla carta di Nichols scelgo il valore minimo di margine di fase
% trovo mf = 38 circa
% Dalle relazioni approssimate ho che:
mf = 60-5*Mr   % 42.5, accettabile perchè superiore al minimo di Nichols
mf = 43   % valore approssimato

%% RETI

figure,bode(Ga1)
% la fase in wcd vale -192, quindi devo recuperare 55 gradi
% Devo considerare di recuperarne i più perchè per un recupero così elevato
% devo aspettari che il modulo aumenti di più di 3 dB -> quindi dovrò poi
% mettere una rete attenuatrice

% Potrei usare due reti da 3 lavorando sul massimo (ma avrei un aumento
% significativo del modulo), oppure due da 4 lavorando sul fronte di salita

% Provo con due da 3 lavorando appena prima del massimo in modo da
% risparmiare un paio di decibel

%% Reti anticipatrici
md = 3;
xd = 1.5;
taud = xd/wcd;
Rd = (1+taud*s)/(1+taud/md*s);

Ga2 = Ga1 * Rd^2;

[m,f] = bode(Ga2,wcd)

%% Rete attenuatrice
mi = 1.8;
xi = 30;
taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2 * Ri;

%% A questo punto il progetto dovrebbe essere completo, uso margin per verificare wc e mf

figure,margin(Ga3)
% ho soddisfatto i requisiti sulla funzione d'anello
% posso provare a chiudere l'anello
%%
C = Kc/s*Rd^2*Ri;
W = feedback(C*F1*F2,1/Kr);
figure,step(W);   % tutte le specifiche dinamiche erano state formulate sulla risposta nel tempo

% Il tempo di salita va bene ma ho una sovraelongazione decisamente troppo elevata, 41.5%

% Il fatto di aver trovato un tempo di salita così perfetto vuol dire che
% dal punto di vista del tempo le relazioni approssimate che abbiamo usato
% andavano bene
% Quindi la wc che abbiamo ottenuto così va bene e la manterremo tale

% Abbiamo una sovraelongazione molto maggiore di quella che ci
% aspettavamo quindi dobbiamo rivedere la scelta delle reti anticipatrici


%% S E C O N D O   T  E N T A T I V O
% Usiamo delle reti più forti, usiamo due anticipatrici da 4
md = 4;
xd = 1.2;
taud = xd/wcd;
Rd = (1+taud*s)/(1+taud/md*s);

Ga2 = Ga1 * Rd^2;

[m2,f2] = bode(Ga2,wcd)

%% Rete attenuatrice
mi = 1.6;
xi = 30;
taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2 * Ri;

%% A questo punto il progetto dovrebbe essere completo, uso margin per verificare wc e mf

figure,margin(Ga3)
% ho soddisfatto i requisiti sulla funzione d'anello
% posso provare a chiudere l'anello
%%
C = Kc/s*Rd^2*Ri;
W = feedback(C*F1*F2,1/Kr);
figure,step(W);

% Vedo che ora la specifica sulla sovraelongazione è soddisfatta e questo
% non ha avuto conseguenze sul tempo di salita che continua ad andare bene
% (era richiesto 0.2s con tolleranza 20%)
