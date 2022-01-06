% APPLICAZIONE AD UN SERVOMOTORE

% Il modello del servomotore in corrente continua puo' eesere facilmente
% realizzato in Simulink, dopo aver definito nello spazio de lavoro in
% Matlab tutti i parametri e le fdt che in esso compaiono.
% A tale scopo e' sufficiente eseguire la prima parte del file Matlab prima
% creato, completata dalla definizione della fdt dei controllori che si
% vogliono applicare

% Non avremo bisogno di calcolare la fdt del servomotore F(s), si puo'
% simulare direttamente il sistema interconnesso cosi' com'e'
% Possiamo anche eventualmente includere la contemporanea presenza di una
% coppia di disturbo Tc

%% prima parte del file: definizione dei parametri del servomotore

clear variables
close all
s=tf('s');
Ra=6;
L=3.24e-3;
Km=0.05335;
J=20e-6;
beta=14e-6;
KD=0.0285;
Kcond=0.67;
Rs=7.525;
A=2.925;
K=1000;
CIa=K/s;   % controllore di correnteKr=1;
%%
FrIa = feedback(CIa*A/(L*s+Ra),Rs); 
F = FrIa*Km/(J*s+beta)*KD*Kcond

%% seconda parte del file: definizione dei controllori P e PI
Kp=0.4;
C_omega1=Kp; % guadagno proporzionale
Ki=2; % proporzionale all'integrale dell'errore
C_omega2= Kp+Ki/s;

%%
W1=Kr*feedback(C_omega1*F,1)
W2=Kr*feedback(C_omega2*F,1)

step(W1,5)
hold on
step(W2,5)
hold off

damp(W1)
damp(W2)


