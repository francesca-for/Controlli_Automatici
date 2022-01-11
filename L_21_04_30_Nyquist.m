clear variables
close all
clc 

s = tf('s');

F1 = 1/(s*(s+2)*(s+4))
Kf1 = dcgain(s*F1)  % calcolo guadagno stazionario
figure(1),bode(F1),grid on;
figure(2),nyquist(F1);
pause;


F2 = 10/s*F1 % E' di tipo 2. Poli in 0(2), -2, -4
Kf2 = dcgain(s^2*F2)
% phi_0 = -90*2 = -180
% phi_inf = -180-90*2 = -360
figure(1),bode(F2),grid on;
figure(2),nyquist(F2);
% nia=0 perche' non ho poli a parte reale positiva, N=2
% non mi servirebbe nemmeno Matlab, ho delle circonferenze di raggio
% infinito, il punto critico è ovviamente dentro
% nic = 2 , il sistema e' instabile e ho sue poli a parte reale positiva
% Come posso verificare che l'analisi fatta con Nyquist sia corretta?
% calcolo la funzione di catena chiusa con feedback
W2 = feedback(F2,1);
damp(W2); % per vedere dove sono collocati i poli
pause;


F3 = F2*(s+1) % la funzione ha uno zero reale negativo in -1, poli reali 
               % in 0(2), -2, -4
Kf3 = dcgain(s^2*F3)
% phi_0 = -90*2 + fase(Kf3) = -180
% phi_inf = -180+90-90*2 = -270   ho un aumento di fase e poi una
% diminuzione, ed e' quello che si vede dal DdB della fase
figure(1),bode(F3),grid on;
figure(2),nyquist(F3);
% gia' dal diagramma di Bode si puo' notare che il modulo corrispondente a
% fase -180 e' minore di zero in decibel, quindi minore di uno in unita'
% naturali. Il punto critico sara' alla sua sinistra
% N=0, nic=0, quindi il sistema e' asintoticamente stabile
% Per controllare:
W3=feedback(F3,1);
damp(W3)

