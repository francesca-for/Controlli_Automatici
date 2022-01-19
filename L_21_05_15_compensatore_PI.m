clear variables
close all
clc

s=tf('s');
F = 0.1/((1+s)*(1+0.1*s)*(1+0.01*s))
Kr = 1;

% Specifiche: 
%   * |er,inf| <= 0.04 con r(t) = t
%   * tempo di salita della risposta al gradino unitario pari a circa 0.5s
%   * sovraelongazione massima della risposta al gradino unitario <= 30% 

%% specifiche statiche

% per avere errore di inseguimento alla rampa finito non nullo devo
% aggiungere un polo nell'origine nel controllore
% -> err = Kr/Kga = Kr/(Kf*Kc) 

Kf = dcgain(F)
Kc = Kr/(Kf*0.04)

%% 
Ga1 = F/s

figure,bode(Ga1),grid on;
figure,nyquist(Ga1);
% sistema è a minima rotazione di fase, ha una sola w a cui modulo = 0 e
% una sola a dui la fase = -180 e Kf è positivo
% posso stabilizzarlo per valori di Kc>0

%% specifiche dinamiche
wb = 3/0.5;
wc = 0.63*wb

Mr = (1+0.3)/0.9
mf = 60-5*(20*log10(Mr))
mf = 44;

Ga2 = Kc*Ga1
% ngrid('new')  % nichols

figure,bode(Ga2),grid on;
% devo reucperare 8+mf gradi e far scendere il modulo di 4+(dB di cui aumenterà facendo salire la fase)

%% Compensatore PI
% poichè dobbiamo inserire un polo nell'origine nel controllore, dobbiamo
% guadagnare molta fase senza far salire il modulo, possimamo usare un
% compensatore PI
8+mf
figure,bode(1+s),grid on

xpi = 1.7;
tau_pi = xpi/wc

PI = (1+tau_pi*s)/s

%%
Ga3 = Kc*PI*F
figure,bode(Ga3),grid on

%% rete attenuatrice

mi = 10^(1/2)
figure,bode((1+s/mi)/(1+s)),grid on;
xi = 50;

taui = xi/wc

Ri = (1+s*taui/mi)/(1+s*taui)

%%
Ga4 = Ga3*Ri;
figure,margin(Ga4),grid on;

%%
C = Kc*PI*Ri;

 W = feedback(C*F,1)

 figure,step(W,5);

 %% 
 open_system('L_21_05_15_compensatore_PI_schema');
