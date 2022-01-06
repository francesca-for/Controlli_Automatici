clear variables
close all
clc

s=tf('s');
G=8*(1+0.5*s)/((1+2*s)^2*(1+0.125*s)^2)

% formule di Zeigler-Nichols in catena chiusa
% Kp = 0.6*Kpbar
% TI = 0.5*Tbar
% TD = 0.125*Tbar

% la condizione per cui le formule sopra sono applicabili e' che il margine di guadagno sia finito
% Potrei applicare il comando margin a G nella sua forma  , ma posso fare di meglio usando
[Gm, Pm, Wgm, Wpm] = margin(G)
% Gm contiene il valore del margine di guadagno in unità naturali
% Pm contiene il margine di fase
% Wgm è la wpi a cui leggiamo il margine di guadagno
% Wpm è la pulsazione a cui leggiamo il fargine di fase

% vediamo che Gm = 11.8753 è finito quindi possiamo applicare i metodi di taratura in catena chiusa e corrisponde a Kpbar
Kpbar=Gm
Tbar=2*pi/Wgm


%% Metodo di Zeigler-Nichols ad anello chiuso

Kp = 0.6*Kpbar
TI = 0.5*Tbar
TD = 0.125*Tbar

N=10;

Rpid = Kp*(1+1/(TI*s)+TD*s/(1+TD/N*s));
Ga = Rpid*G;
figure,margin(Ga)
W = feedback(Ga,1)
figure,step(W)
% Vedo che il margine di fase è di soli 23 gradi, devo prevedere di avere oscillazioni grandi durante il transitorio
% Scegliendo N=10 avrò il polo di chiusura in -88.8
% Dal comando margin vedo che la wc = 5.44 rad/s --> è inutile aumentare N perché il polo di chiusura è già di AF
% La povertà del comportamento durante il transitorio sono dovuti al metodo scelto

% Applicando l'azione proporzionale e derivativa solo sull'uscita, lasciando solo il blocco integrale sul ramo diretto
% abbiamo che i margini del sistema crescono molto
% Gm = 6.15 dB
% Pm = 58.7
% la sovraelongazione scende al 17% ma il tempo di salita cresce a 0.73 s
% il tempo di assestamento non cambia perché non abbiamo cambiato i parametri del controllore e i poli in catena chiusa sono gli stessi


%% Metodo in catena chiusa imponendo Pm = 50

% formule per imposizione del margine di fase
mfdes = 50/180*pi;    % converto in radianti per poterlo usare nelle funzioni trigonometriche
Kp = Kpbar*cos(mfdes)
TI = Tbar/pi*(1+sin(mfdes))/(cos(mfdes))
TD = 0.25*TI

Rpid = Kp*(1+1/(TI*s)+TD*s/(1+TD/N*s));    % come nel caso sopra
Ga = Rpid*G;
figure,margin(Ga)
W = feedback(Ga,1)
figure,step(W)

% vedo ce ho un buon margine di fase (43 gradi) con wc = 7.39, piu' grande
% di quella ottenuta prima
% Risposta al gradino: la sovraelongazione e' del 35.6% e ts = 0.228 (circa come nel primo caso)
% Il tempo di assestamento = 1.25s, circa la meta' rispetto a prima, c'e'
% una coda ma e' molto smorzata

%% Taratura con metodo di Ziegler-Nichols ad anello aperto

% Posso applicare i metodi in anello aperto perche' il sistema e'
% asintoticamete stabil, privo di poli nell'origine e ha solo poli a Re<0
% (se avesse un polo in s=0 non sarebbe BIBO stabile) e non presenta
% sovraelongazione

figure,step(G)
Kf = 8   %  = yinf/ampiezza(u(t))
0.63*8   % valore a cui devo leggere tauf + thetaf
         % tauf + thetaf = 4
thetaf = 0.44  % per ottenerlo traccio sul grafico la retta che parte dall'ascissa del 63% e interseca il punto di massima pendenza e vado a predere l'istante in cui questa retta interseca y=0
tauf = 4-thetaf

Fapp = Kf/(1+tauf*s)*exp(-thetaf*s);
hold on, step(Fapp)
hold off

% Parametri Ziegler-Nichols
Kp = 1.2*tauf/(Kf*thetaf)
TI = 2*thetaf
TD = 0.5*thetaf

Rpid = Kp*(1+1/(TI*s)+TD*s/(1+TD/N*s));
Ga = Rpid*G;
figure,margin(Ga)
W = feedback(Ga,1)
figure,step(W)
% ho un margine di fase migliore rispetto a prima ma ho un overshoot del
% 41%, decisamente elevato
% Il tempo di assestamento è molto più grande di prima (8.48), ho un sistema
% decisamente più lento
% Tempo di salita = 0.85

%% Metodo in catena aperta di Cohen-Coon

% manteniamo N = 10

% Abbiamo uno smorzamento veloce delle oscillazioni, infatti il tempo di
% assestamento si è ridotto a 6.23s  --> è questo l'obbiettivo quando si
% usa Cohen-Coon
% La sovraelongazione è comparabile con quella ottenuta prima


%% Metodo di Internal Model Control

TI = 3.87
TD = 0.2072

% il valore di Kp può essere variato, facendo variare il parametro Tf (originariamente asociato al filtro del primo ordine)
% Kp = 2.0543 per Tf = 0.01
% Kp = 1.4766 per Tf = 0.1
% Kp = 0.3873 per Tf = 1

% N=10 come prima, pc=-48.26, otteniamo:
% Pm = da 61 a 65.9 (con wc da 2.54  0.767 rad/s)
% Gm = da 26.5 a 41 dB
% al variare di Tf


% COMMENTI:
% i metodi classici di Ziegler-Nichols danno risuòtati poco soddisfacenti
% dal punto di vista delle prestazini, anche se la stabilità è solitamente
% ottenuta
% I metodi di taratura più avanzati, sia in anello chiuso che in anello
% aperto, sono preferibili ogni volta in cui sia necessario garantire migliori
% indici di robustezza e/o un migliore comportamento del sistema durante il
% transitorio


% NB:
% NELL'ESERCIZIO D'ESAME SUL PID NON CI SARANNO SPECIFICHE
% SI DOVRA' VALUTARE L'APPLICABILITA' DELLE DUE FAMIGLIE DI METODI, NEL
% CASO IN CUI ENTRAMBE FOSSERO APPLICABILI SCEGLIERE UN METODO IN
% PARTICOLARE (e indicarlo chiaramente), DETERMINARE I PARAMETRI
% CARATTERISTICI DI F(s) E INDICARE I VALORI DI Kp, TI, TD COERENTI CON IL
% METODO SCELTO E VALUTARE IL SISTEMA IN CATENA CHIUSA
% Il sistema in catena chiusa DEVE essere asintoticamente stabile
