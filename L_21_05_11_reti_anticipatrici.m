% Schema di controllo:
%                   ______        ______
%   ydes--->O--e-->| C(s) |--u-->| F(s) |---.-->y
%        +  ^       ------        ------    |
%         - |_______________________________|

clear variables
close all
clc

s=tf('s');
F=10/(s*(s+2)*(s+4))  % di tipo 1, ha solo un polo nell'origine
Kf=dcgain(s*F)   % Kf = 10/8
Kr=1;

% progettare C(s) in modo che il sistema in caten chiusa soddisfi le
% seguenti specifiche:
% - statiche
%   *   |er,inf| < 0.2 per r(t)=t
% - dinamiche
%   *   ts della risposta al gradino unitario pari a circa 0.4s con tolleranza
%       di +-15%
%   *   sovraelongazione massima della risposta al gradino unitario non
%       superiore al 25%

%%
% si inizia analizzando le specifiche statiche
% Sistema di tipo 1 e riferimento di grado 1 -> errore intrinseco di
% inseguimento limitato senza necessita' di inserire poli nel controllore
% =>  h = 0
% |er,inf| = |Kr/(Kc*Kf)| <= 0.2  --> |Kc| >= 4

Kc = Kr/(Kf*0.2)
% il segno di Kc si sceglie POSITIVO per garantire la stabilizzabilita' del
% sistema (con C(s) stabile)
bode(F)
% dal diagramma di bode vediamo che abbiamo una sola pulsazione di crossover
% e una sola pulsazione alla quale la fase vale -180
% il sistema è quindi a stabilita' regolare e possiamo scegliere Kc > 0

% analizziamo ora le specifiche dinamiche
ts = 0.4    % con tolleranza 15%  =>  0.34 ≤ ts ≤ 0.46
% con l'approssimazione con dinamica dominante del secondo ordine , abbiamo che
% w_b * ts ≈ 3
w_b = 3 / ts
w_cd = w_b * 63/100
% specifica sulla sovraelongazione massima non superiore al 25%
% Mr ≤ (1+s^)/0.9
Mr_max = (1+0.25)/0.9
% A questo punto guardo qual e' il margine di fase minimo (detrerminato sulla carta di Nichols)
% e considero la relazione approssimata per capire se il valore trovato è
% significativamente superiore al minimo di Nichols
mf_min = 60-5*(20*log10(Mr_max))
pause;


%% ---- Ora possimo impostare il progetto in matlab ----

% definiamo la funzione d'anello di partenza
Ga1 = Kc*F;  % Kc = 4, valore minimo ammissibile e eventualmente aumentabile successivamente
bode(Ga1)
% vediamo cosa succede alla w_c desiderata
% M = -11.4 ,    fase = -206
% se voglio avere il margine di fase trovato prima devo recuperare fase,
% quella per salire a -180 e quella che voglio avere come margine, quindi = 44+26
% Affinche' la pulsazione sia di crossover, il modulo dovra' valere 0, quindi
% devo recuperare 11,4 gradi

% poiche' devo recuperare sia modulo che fase posso usare reti anticipatrici
% ne servono due perchè devo recuperare piu' di 60 gradi
% dalla carta vedo che possousare due reti (4) che fanno recuperare ≈ 35
% e devo centrearle in modo da avere il massimo alla wc di crossover
% max = sqrt(md)
% Devo prima controllare che l'aumento di modulo sia compatibile -> vedo che
% l'aumento in corrispondenza della w=2 della rete (4) vale 6 dB, quindi
% con 2 reti avro' un aumento di circa 12. Essendo leggermente piu' grande di
% quello che mi serviva, la w_c sara' leggermente superiore a quella attesa.

md1=4;
figure,bode((1+s)/(1+s/md1))    % questa funziona ha l'espressione della rete anticipatrice con tau_d = 1
% mi da' le stesse informazioni che avevo trovato in modo approssimativo sui fogli delle reti, ma piu' precise
w_tau = sqrt(md1);
tau_d1 = w_tau/w_cd
Rd1 = (1+tau_d1*s)/(1+tau_d1/md1*s)  % RETE DERIVATIVA con md=4 centrata sum massimo recupero di fase e con w_cd=4.7

% poiche' le due reti sono identiche, posso inserirla direttamente dicendo che la nuova funzione d'anello:
Ga2 = Ga1 * Rd1^2;

figure,margin(Ga2)  % a questo punto, quando non devo piu' inserire nulla nella
                    % parte dinamica del controllore e dovrei avere la funzione
                    % d'anello finale, mi conviene usare il comando margin

% A questo punto posso definire la funzione C completa
C = Kc * Rd1^2
% potrei usare direttamente feedback con Ga2, ma in questo modo ho tutto pronto per fare la verifica su simulink

W=feedback(C*F,1);
figure,step(W);     % simulo la risposta al gradino

% Dalla figura possiamo vedere che la sovraelongazione massima è di 1.24 quindi < 25%
% tempo di salita = 0,398 ≈ 0,4 ± 15%   -> ho soddisfatto entrambe le specifiche dinamiche
% Per quanto riguarda la specifica statica, siamo certi che sia soddisfatta perche' non abbiamo
% approssimazioni o incertezze, quello che abbiamo fatto come analisi del comportamento in
% regime permanente e che poi e' diventato strumento di sintesi, sono tutte relazioni esatte
% Il valore che ci aspettiamo di ottenere e' proprio 0.2 perche' abbiamo considerato il Kc minimo
% associato alla soglia dell'errore massimo imposto dalle specifiche e non lo abbiamo modificato


% ---- SIMULINK ----
%
%                       [errore]     [comando]
%    _____      ____        |    _____   |    _____
%   | rif |--->| Kr |--->O--.-->|  C  |--.-->|  F  |---.----[uscita]
%    -----      ----   + ^       -----        -----    |
%                      - |_____________________________|
