% Schema di controllo:
%                   ______        ______
%   ydes--->O--e-->| C(s) |--u-->| F(s) |---.-->y
%        +  ^       ------        ------    |
%         - |_______________________________|


% progettare C(s) in modo che il sistema in caten chiusa soddisfi le
% seguenti specifiche:
%   *   |er,inf| < 0.2 per r(t)=t
%   *   sovraelongazione massima della risposta al gradino unitario non
%       superiore al 25%
%   *   banda passante pari a circa 6 rad/s con tolleranza 15%

clear variables
close all
clc

s=tf('s');
F=10/(s*(s+2)*(s+4))  % di tipo 1, ha solo un polo nell'origine
Kf=dcgain(s*F)   % Kf = 10/8
Kr=1;
Kc = Kr/(Kf*0.2)   % come nell'esempio precedente

% Kc>0 per garantire la stabilizzabilita' del sistema (con C(s) stabile)

Ga1 = Kc*F
bode(Ga1)

%%
% wc/wb = 0.63
wc = 6*0.63
wc = 3.8 % approssimo a 3.8

Mr = 1.25/0.9;
mf = 60 - 5*(20*log10(Mr))

figure,bode(Ga1),grid on
% devo recuperare 16+mf = circa 62 gradi

%% RETI

md1=3;
xd1=1.3;
tau_d1 = xd1/wc;
Rd1 = (1+tau_d1*s)/(1+tau_d1/md1*s)  % RETE DERIVATIVA con md=3 centrata sum massimo recupero di fase e con wc=3.8

md2=4;
figure,bode((1+s)/(1+s/md2))
xd2=1.16;
tau_d2 = xd2/wc;
Rd2 = (1+tau_d2*s)/(1+tau_d2/md2*s)  % RETE DERIVATIVA con md=4 centrata sum massimo recupero di fase e con wc=3.8

Ga2 = Ga1 * Rd1 * Rd2;  % in questo caso ho due diverse reti Rd1 e Rd2
figure,margin(Ga2)

%%
C = Kc * Rd1^2

W=feedback(C*F,1);
figure,step(W);     % simulo la risposta al gradino
pause;
figure,bode(W),grid on;     % perche' abbiamo una specifia sulla risposta in frequenza

% da Bode trovo la banda passante e vedo che e' intorno a 6.7
% poiche' la tolleranza e' del 15% :
wb_max = 6*1.15
% vedo che la banda trovata e' un valore accettabile

%%
open_system('L_21_05_11_reti_anticipatrici_2_schema');
