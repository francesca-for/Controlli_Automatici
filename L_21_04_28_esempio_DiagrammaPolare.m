clear variables
close all
clc

s = tf('s');
F1 = 1/(s*(s+2)*(s+4));
Kf1 = dcgain(s*F1)  % calcolo guadagno stazionario
bode(F1);

%%
F2 = 10/s*F1; % E' di tipo 2. Poli in 0 (doppio), -2, -4
Kf2 = dcgain(s^2*F2)
% phi_0 = -90*2 = -180
% phi_inf = -180-90*2 = -360
figure,bode(F2);
% notiamo che il DdB del modulo decresce piu' velocemente e quello della
% fase e' "spostato" di 90 gradi
% Per tracciare il diagramma polare, partiamo da -180 da sopra perché dal
% DdB vediamo che la fase varia da -180 a -360 passando per -270, e
% arriviamo nell'origine con fase -360.
% Il diagramma è come quello di F1 ma ruotato di -90°, il contributo del 10
% al numeratore non è immediatamente apprezzabile.

%%
F3 = F2*(s+1); % la funzione ha uno zero reale negativo in -1, poli reali
               % in 0 (doppio), -2, -4
Kf3 = dcgain(s^2*F3)
% phi_0 = -90*2 + fase(Kf3) = -180
% phi_inf = -180+90-90*2 = -270   ho un aumento di fase e poi una
% diminuzione, ed e' quello che si vede dal DdB della fase
figure,bode(F3);
% avendo avuto un recupero di fase iniziale dovuto allo zero, nella prima
% parte la fase supera il valore di -180, poi riscende pe reffetto dei due
% poli.
% Il diagramma polare parte da un asintoto a -180 DA SOTTO (il grafico
% della fase va sopra i -180), poi risale e arriva nell'origine dall'alto,
% a 170°. Ho un attraversamento dell'asse reale negativo
