clear variables
close all
clc

s = tf('s');
F = 10/(s*(s+2)*(s+4));

Kr = 1;
Kf = dcgain(s*F)
Kc = Kr/(Kf*0.2)

Ga1 = Kc*F;
bode(Ga1)

wcd = 4.7;

md1 = 4;
figure,bode((1+s)/(1+s/md1))

wtau = sqrt(md1);
taud1 = wtau/wcd
taud1 = 0.425

Rd1 = (1+taud1*s)/(1+taud1/md1*s);

Ga2 = Ga1*Rd1^2;

figure,margin(Ga2)

C = Kc * Rd1^2;

W = feedback(C*F,1);
figure,step(W)

%% Parte sulla discretizzazione

% Scelta del passo di campionamento
% serve trovare la wb

figure,bode(W)

wB = 8.75;
T = 2*pi/(20*wB)  % prima approssimazione del passo di campionamento
T = 0.03;  % valore approssimato

Gazoh = Ga2/(1+s*T/2);
figure,margin(Gazoh)  % il margine di fase è crollato a 40 gradi, molto vicino al minimo di Nichols 

% essendo il passo di campionamento grande rispetto al minimo (intorno a un
% millisecondo), possiamo tranquillamente provare a diminuirlo

T = 0.01;
Gazoh = Ga2/(1+s*T/2);
figure,margin(Gazoh)

T = 0.005;   % uso questa scelta che mi permette di far risalire all'interno del range prefissato il margine di fase
Gazoh = Ga2/(1+s*T/2);
figure,margin(Gazoh)

%% Provo ad applicare i vari metodi

Cz1 = c2d(C,T,'tustin')
Cz2 = c2d(C,T,'zoh')
Cz3 = c2d(C,T,'match')

% notiamo che i denominatori sono più o meno uguali nei tre casi, quindi
% non cambia molto per quanto riguarda i poli
% i numeratori invece sono quasi uguali con Tustin e match, è diverso
% usando il metodo di invarianza al gradino -> gli zeri sono diversi,
% potrei avere differenze nel comportamento durante il transitorio usando
% questo metodo

Fz = c2d(F,T,'zoh');
W1 = feedback(Cz1*Fz,1);
W2 = feedback(Cz2*Fz,1);
W3 = feedback(Cz3*Fz,1);

%% comportmento nel tempo

figure,step(W1)
hold on
step(W2)
step(W3)
hold off

% vedo che con il metodo di invarianza al gradino ho una sovraelongazione
% del 26.2%, la scelta di uno degli altri metodi mi porterebbe ad avere
% overshoot più basso che soddisfa le specifiche
% Per quanto riguarda il tempo di salita la differenza è minima

%% comportamento in frequenza

figure,bode(W1)

% il diagramma si interrompe alla frequanza di Nyquist, con il passo di
% campionamento scelto non posso avere informazioni a frequanze superiori a
% quella

%% Simulazione del sistema ibrido con Simulink

open_system('L_25_05_21_esempio_discretizzazione_schema');

% nel report dell'esame per l'esercizio di discretizzazione serve riportare:
%  - passo di campionamento e come ci siamo arrivati
%  - riportare la fdt di Cz così come data da matlab 
%  - quanto valgono i valori per le prestazioni che era stato richiesto di
%    valutare
