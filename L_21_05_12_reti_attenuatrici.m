clear variables
close all
clc

s=tf('s');
F=10/(s*(s+2)*(s+4))  % di tipo 1, ha solo un polo nell'origine
Kf=dcgain(s*F)   % Kf = 10/8
Kr=1;

% progettare C(s) in modo che il sistema in caten chiusa soddisfi le
% seguenti specifiche:
%   *   |er,inf| <= 0.2 per r(t)=t
%   *   sovraelongazione massima della risposta al gradino unitario non
%       superiore al 25%
%   *   banda passante minore di 1.8 rad/s

%% specifiche come nell'esempio precedente
Kc = Kr/(Kf*0.2)   
% Kc>0 per garantire la stabilizzabilita' del sistema (con C(s) stabile)

Mr = 1.25/0.9;
mf = 60 - 5*(20*log10(Mr))

%% nuova specifica
% wc/wb = 0.63
wb = 1.8;
wc = 0.63*wb
wc_max = 1.1

wc=0.9;

%% 
Ga1 = Kc*F
figure,bode(Ga1),grid on

% il modulo deve diminuire di 13.8 dB perdendo al massimo 
% (-180+45)+127 = 8 gradi di fase

[m,f] = bode(Ga1,wc)
%% RETE ATTENUATRICE

mi = 5;   % = m
figure,bode((1+s/mi)/(1+s)),grid on
xi = 50;
taui = xi/wc
Ri = (1+taui*s/mi)/(1+taui*s)

%% 
C = Kc*Ri;
Ga = C*F;
figure,margin(Ga),grid on

W = feedback(Ga,1);
figure,step(W)
figure,bode(W),grid on

%%
open_system('L_21_05_12_reti_attenuatrici_schema');
