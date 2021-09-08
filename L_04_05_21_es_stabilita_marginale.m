clear all
close all

s=tf('s');

Ga=1e6*(s+2)*(s+20)/(s^2*(s+1)*(s+200)*(s+500));
Kga=dcgain(s^2*Ga);
bode(Ga)
figure,nyquist(Ga)
figure,margin(Ga)

% leggendo le informazioni dai diagrammi di bode ho informazioni
% discordanti, non riesco a capire se effettivamente il sistema sara'
% asintoticamente stabile oppure no. Devo analizzarlo usando Nyquist.
% Il modulo e' sempre decrescente, parte da inf e scende nell'origine, la
% fase parte da -180 dal basso, c'e' un iniziale recupero di fase dovuto
% all'alternarsi di zeri e poli in bassa frequenza, poi la fase taglia di
% nuovo i -180 e scende a -270
% il diagramma e' completato da due semicirconferenze di raggio inf che
% vanno da 0- a 0+ in senso orario.

% Lasciando Kc libero di variare, il sistema risulta asintoticamente
% stabile per tutti i valori di Kc per cui (-1/Kc, 0) risulta compreso tra
% A (-10.2, 0) e B (-0.0167, 0), cioe' per 0.098 < Kc < 59.9
% 59.9 e' quello che corrisponde al margine di guadagno cosi' come lo
% avevamo definito, 0.098 rappresenta un limite di massima attenuazione,
% posso diminuire Kc senza superare questo limite

% IN QUESTO CASO USARE IL COMANDO MARGIN NON CI DA' IL RISULTATO CORRETTO,
% MA UNO PARZIALE. QUESTO PERCHE' CI SONO DUE VALORI DI FASE E PRENDE SOLO
% IL PRIMO CHE TROVA.
% VALORE CHE TROVA

%%
% ESEMPIO 2: piu' pulsazioni a cui |Ga(s)|=1

clear all
close all

s=tf('s');

Ga=10000*(s+5)/((s+1)*(s^2+8*s+400)*(s+50));
Kga=dcgain(s^2*Ga);
%bode(Ga)
theta =[0:0.001:2*pi];
plot(1*cos(theta), 1*sin(theta));
hold,nyquist(Ga);
%figure,nyquist(Ga)
%figure,margin(Ga)
