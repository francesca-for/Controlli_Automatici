clear all
close all
clc

% Sia dato il sistema LTI descritto dalla funzione di trasferimento F,
% controllato mediante un controllore statico di guadagno K (da definire),
% chiuso in un anello di retroazione negativa con un blocco di guadagno
% 1/KR secondo lo schema:
%                    _
%              Kr-->|e|     d1               d2
%              |            |                |
%    r(s)--->O-----> Kc --->O----> F(s) ---->O----.----> y(s)
%            ^                                    |
%          - |________________ 1/Kr ______________|


s = tf('s');
F = (s-1)/((s+0.2)*(s^3+2.5*s^2+4*s))

Kr = 0.5;

%% --------  punto (a)  --------

% determinare il guadagno stazionario della funzione F, le sue
% singolarità evidenziando le parti reale e parte immaginaria pulsazione
% naturale e fattore di smorzamento.calcolare fase iniziale e fase finale
% di F(jw)

Kf = dcgain(s*F)  % F ha un polo nell'origine

zeri = zero(F)
poli = pole(F)
damp(F)

% Fase iniziale: il guadagno stazionario della funzione è negativo quindi
% ho -90 -180 = -270
% Fase finale: ho uno zero positivo e 3 poli a parte reale negativa, le 4
% singolarita' comportano tutte una perdita di fase -> perdo 360°

%% --------  punto (b)  --------

% traccia qualitativamente a mano i diagrammi di Bode per KC = 1 e
% determinare andamento esatto con ausilio di Matlab

Kc = 1;
Ga1 = Kc*F/Kr

figure,bode(Ga1)

%% --------  punto (c)  --------

% tracciare qualitativamente il diagramma di Nyquist della funzione Ga(jw)

% parte da -270 (quindi dall'alto) da dx, perdo 360 gradi quindi arrivo
% nell'origine dall'alto dopo aver compiuto un giro in senso orario

figure,nyquist(Ga1)

%% --------  punto (d)  --------

% studiare la stabilità del sistema ad anello chiuso al variare di Kc
% mediante applicazione del criterio di Nyquist. Verificare in particolare
% l'asintotica stabilità del sistema per Kc = -0.1

% nia = 0 perche' non abbiamo poli a destra
% Abbiamo 4 regioni da considerare:
% - N = 1, nic = 1
% - N = 3, nic = 3
% - N = 2, nic = 2
% - N = 0, nic = 0 quindi asintotica stabilita' se Kc a destra del punto di
%   attraversamento  ->  -0.25 < Kc < 0

%% --------  punto (e)  --------

Kc = -0.1

Ga=Kc*F/Kr  % funzione d'anello

W = feedback(Kc*F,1/Kr)
damp(W)

% Calcolare l'errore di inseguimento in regime permanente nei seguenti casi:
%    * r(t) = t  in presenza dei disturbi d1 = 0.1 e d2 = 0.5 (costanti)
%    * r(t) = 2  in presenza dei disturbi d1 = 0.1 e d2 = 0.01t

% NB: il sistema di controllo e' di tipo 1
We = Kr*feedback(1,Ga)
Wd1 = feedback(F,Kc/Kr)
Wd2 = feedback(1,Ga)

%% caso 1

% - errore intrinseco di inseguimento a r(t) = t pari a Kr/KGa =
%   Kr/(Kc*Kf/Kr) perche' il sistema e' di tipo 1
% - effetto del disturbo d1 costante pari a d1/(Kc/Kr) perche' ci sono poli
%   solo a valle del disturbo
% - effetto di d2 nullo perche' ho almeno un polo in 0 a monte del disturbo

errore_r = dcgain(s*We*1/s^2)
effetto_d1 = dcgain(s*Wd1*0.1/s)
effetto_d2 = dcgain(s*Wd2*0.5/s)

errore_tot = errore_r - (effetto_d1 + effetto_d2)

open_system('lab06es02_e1')
sim('lab06es02_e1')

%% caso 2

% - errore intrinseco di inseguimento a r(t) = 2 pari a 0 perche' il sistema e' di tipo 1
% - effetto del disturbo d1 uguale al caso sopra
% - effetto di d2 = alfa_d2/KGa = alfa_d2/(Kc*Kf/Kr) perche' il sistema e'
% di tipo 1

errore_r = dcgain(s*We*2/s)
effetto_d1 = dcgain(s*Wd1*0.1/s)
effetto_d2 = dcgain(s*Wd2*0.01/s^2)

errore_tot = errore_r - (effetto_d1 + effetto_d2)

open_system('lab06es02_e2')
sim('lab06es02_e2')
