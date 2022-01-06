clear variables
close all
s=tf('s');
F=10/(s*(s+2)*(s+4));
Kc=1.5;
Kr=1;

% Guardando l'uscita sull'oscilloscopio posto sull'errore, notiamo che
% abbiamo un errore finito ma non nullo
% Ce lo aspettavamo perche' il sistema e' di tipo 1 e abbiamo un
% riferimento a rampa (grado 1) -> errore = Kr/Kga

Ga=Kc*F;  % funzione d'anello
Kga=dcgain(s*Ga); % dcgain calcola il valore in s=0 della funzione in argomento. 
                  % Poiche' F e' di tipo 1, avro' guadagno_stazionario =
                  % dcgain(s^1*Ga)
err_rampa=Kr/Kga

%% funzione di trasferimento in catena chiusa
W=Kr*feedback(Ga,1)
bode(W) % permette di vedere i diagrammi di bode

% dalla fdt, per ricavare il comportamento del diagramma di bode, devo per
% prima cosa mettere in evidenza i poli