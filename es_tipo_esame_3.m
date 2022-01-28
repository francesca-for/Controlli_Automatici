clear variables
close all
clc
s = tf('s');

Tp = 1;  % blocco in retroazione
A = 9;

Gp = -0.65/(s^3+4*s^2+1.75*s)
% sistema di tipo 1
Kgp = dcgain(s*Gp)   % guadagno negativo

%% specifiche statiche
% |err,inf| <= 0.2   NON devo aggiungere poli nel controllore
% Kc = Ktp/Kga
Kga = A*Kgp*Kc/Tp;
Kc1 = abs(Tp/(Kgp*A*0.2/Tp))

% eff_d1 = 6*10^-4
d1 = 5.5*10^-3;
Kc2 = abs(d1/(A/Tp*6*10^(-4)))

% eff_d2 = 1.5*10^-3
d2 = d1;
Kc2 = abs(d2/(A*6*10^(-4)))
%% specifiche dinamiche

