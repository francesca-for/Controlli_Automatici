clear all
close all
clc

s= tf('s');

% Sistem LTI descritto dalla seguente funzione di trasferimento:
F=(s+10)/(s^3+45*s^2-250*s)
% controllato da un controllore statico di guadagno Kc (da definire), chiuso in un anello di retroazione
% negativa con un blocco di guadagno 1/Kr, secondo lo chema seguente:

%                         d1             d2
%                         |              |
%    r(s)--->O---> Kc --->O---> F(s) --->O---.---> y(s)
%            ^                               |
%          - |_____________ 1/Kr ____________|


% il sistema non e' piu' a minima rotazione di fase (ho il -250 a denom.)
%  Ga(s) = Kc/Kr * F(s)


%% --------  punto (a)  --------

Kf = dcgain(s*F)  % <0, avra' un contributo nel calcolo della fase iniziale

zeri=zero(F)
poli=pole(F)  % ho un polo in +5, fa guadagnare fase
damp(F)

bode(F)
% La fase parte da -270 perche' ho il contributo del polo nell'origine e il
% guadagno negativo che fa perdere altri 180 gradi
% Poi la fase sale per il contributo del polo positivo, poi dello zero
% negativo e ho infine il contributo del polo reale negativo che fa perdere
% 90 gradi. In totale avro' quindi guadagnato 90 gradi


%% --------  punto (b)  --------

Kc = 1;
Kr = 2;
Ga1 = Kc*F/Kr
figure,bode(Ga1)


%% --------  punto (c)  --------

% il diagramma di nyquist parte da -270 da sinistra, supera i -180 e poi
% arriva nell'origine da sotto ( > -180). Traccio il simmetrico e chiudo il
% diagramma con una semicirconferenza in senso orario.

figure,nyquist(Ga1)


%% --------  punto (d)  --------

% verifica della stabilita' mediante criterio di nyquist

% Ho tre regioni da considerare (nia=1):
% - nella prima ho N=1, quindi nic=2
% - nella seconda ho N=-1, quindi nic=0 -> è la zona che dobbiamo considerare
% - nella terza, quindi per Kc<0 ho N=0, quindi rimane nic=1
% L'intervallo che mi va bene e' quello dei valori che mi portano il punto
% critico a destra del punto di attraversamento A=-1,5 * 10^(-3)

% >> nic = 2 per 0 < Kc < 642
% >> nic = 0 (asintotica stabilita') per Kc > 642
% >> nic = 1 per qualunque Kc < 0


%% --------  punto (e)  --------

% Fissato Kc=800, calcolare l'errore di inseguimento in regime permanente
% nei seguenti casi:
%   * r(t) = t in presenza dei disturbi d1 = 0.1 e d2 = 0.5 (entrambi costanti)
%   * r(t) = 2 in presenza del solo disturbo d2 = 0.01t (d1 = 0)
% Verificare la correttezza dei risultati ottenuti simulando il
% comportamento del sistema retroazionato nei diversi casi mediante
% utilizzo di Simulink

Kc=800;
Ga=Kc*F/Kr;
W = feedback(Kc*F,1/Kr)
damp(W)

% N.B: il sistema e' di tipo 1

We = Kr*feedback(1,Ga)
Wd1 = feedback(F, Kc/Kr)
Wd2 = feedback(1, Ga)

%% caso 1:
% errore intrinseco di inseguimento = Kr/KGa = Kr/(Kc*Kf/Kr) perche' il sistema e' di tipo 1
% effetto del disturbo d1 costante sull'uscita dipende solo dal guadagno che sta a monte del
% disturbo, quindi e' pari a d1/(Kc/Kr) -> perche' ho poli nell'origine solo nel blocco a valle
% effetto del disturbo d2 sull'usc  ita nullo perche' ho un polo nell'origine a monte nel blocco F

errore_r = dcgain(s*We*1/s^2)
effetto_d1 = dcgain(s*Wd1*0.1/s)
effetto_d2 = dcgain(s*Wd2*0.5/s)
errore_tot = errore_r - (effetto_d1 + effetto_d2)

open_system('lab06es01e1_schema')
sim('lab06es01e1_schema')


%% caso 2:
% errore intrinseco di inseguimento = 0 perche' il sistema e' di tipo 1 e rif. costante
% disturbo d1 nullo non ha effetto
% effetto del disturbo d2 = alfa_d2*t (rampa) sull'ucscita e' pari a alfa_d2/KGa = alfa_d2/(Kc*Kf/Kr)
% perche' il sistema è di tipo 1

errore_r = dcgain(s*We*2/s)
effetto_d1 = dcgain(s*Wd1*0)
effetto_d2 = dcgain(s*Wd2*0.01/s^2)
errore_tot = errore_r - (effetto_d1 + effetto_d2)

open_system('lab06es01e2_schema')
sim('lab06es01e2_schema')

% da Symulink l'errore risulta nullo --->  WTF??
