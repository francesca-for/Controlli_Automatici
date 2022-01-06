clear variables
close all
clc

s = tf('s');
F = 10/(s*(s+2)*(s+4))

Kr = 1

% progettare C(s) in modo che il sistema in catena chiusa soddisfi le seguenti specifiche:
%   * |er,inf| <= 0.2 per r(t) = t
%   * Sovraelongazione massima della risposta al gradino unitario non superiore al 25%
%   * Banda passante pari a circa 3.2 rad/s (con tolleranza dei +-15%)

% le prime due specifiche sono uguali agli esercizi L_11_05_21, quindi:
% C(s) = Kc * C'(s)
Kc = 4  % minimo valore ammissibile e la funzione d'anello di partenza e' di nuovo data da
Ga1 = Kc*F  % = 40/(s*(s+2)*(s+4))
% La specifica sulla sovraelongazione massima implica mf_min = 43 - 45
% La nuova specifica sulla banda passante implica 2.72 <= wB <= 3.68 rad/s
%               ->  wc = 0.63 * wB_des = 2 rad/s

% Nell'esercizio svolto su carta (vedi appunti, pag. 199) avevamo utilizzato una rete derivativa da 3
% e una rete integrativa con mi = 3 (2.8 sulle slide)

bode(Ga1)

wc = 2;
[m,f] = bode(Ga1,wc)

% Dal DdB vedo che devo far salire la fase per poter garantire il margine di fase
% Ho inoltre che il modulo è gia' maggiore di 0 e crescera' ancora mettendo
% la rete anticipatrice, quindi devo pensare di mettere una rete attenuatrice

%% rete anticipatrice
md = 3;  % mi consente un recupero massimo di fase di 30 gradi, quindi 5 gradi in piu' del minimo necessario
xd = sqrt(md);
taud = xd/wc;
Rd = (1+taud*s)/(1+taud/md*s);
Ga2 = Ga1 * Rd;
[m1,f2] = bode(Ga2,wc)  % m1 = 2,74, approssimo a 2.8

%% rete attenuatrice
mi = 2.8;
figure,bode((1+s/mi)/(1+s))   % Vedo che il modulo rimane pressoche' invariato da circa 40 rad/s in poi.
                              % In corrispondenza di questo valore si ha
                              % perdita di fase di circa 2.6 gradi, quindi
                              % è accettbile (rientra nel margine di fase)
xi = 40;
taui = xi/wc;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2 * Ri;

figure,margin(Ga3)  % Controllo i margini di modulo e fase e w di crossover
                    % Vanno bene, completo il progetto del controllore

%%
C = Kc * Rd * Ri;
W = feedback(C*F,1);
figure,bode(W)  % per specifica sulla banda passante
figure,step(W)  % per specifica sulla risposta al gradino
