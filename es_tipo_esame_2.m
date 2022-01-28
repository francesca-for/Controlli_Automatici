clear variables
close all
clc
s = tf('s');

F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10))
F2 = 1/s

Kf1 = dcgain(F1)
Kf2 = dcgain(s*F2)

Kr = 1;
disturbo = 1.5;

%%
Ga1 = F1*F2/Kr
Kga = Kf1*Kf2/Kr
% >  err inseguimento a gradino unitario sempre nullo perchè sistema di tipo 1
% >  err inseguimento a parabola 1/2*t^2 limitato  --> vedo inserire un polo
     h = 1;
%    nel controllore e err = Kr/(Kc*Kf1*Kf2/Kr) --> Kc = Kr/(err*Kf1*Kf2/Kr)
     Kc1 = Kr/(0.16*Kf1*Kf2/Kr)
% >  effetto di d sull'uscita pari al massimo in modulo a 0.05
     Kc2 = 1/(0.05*Kf1)
Kc = max(Kc1,Kc2)

%%
zeri = zero(Ga1)
poli = pole(Ga1)

% fase_0 = -90
% fase_inf = -90 -90*2 +90
figure,bode(Ga1),grid on;
figure,nyquist(Ga1);
% sistema a minima rotazione di fase, a guadagno positivo, con una sola wc 
% e una sola w con fase -180   -->   Kc positivo

Ga2 = Ga1*Kc/s^h

%%
% wb = 4 rad/s  -->  wc = [2.3, 2.8]
wc = 0.63*4
wc = 2.5  % approssimata

Mr = (1+0.25)/0.9;
Mr_dB = 20*log10(Mr)
% mf da nichols = 40
mf = 60 - 5*Mr_dB
mf = 46  % approssimata

%%
figure,bode(Ga2),grid on;
% recupero circa 60 gradi e attenuo il modulo di 16dB

%% reti anticipatrici

md = 4;
figure,bode((1+s)/(1+s/md)),grid on
xd2 = 1;
taud = xd2/wc;
Rd2 = (1+s*taud)/(1+s*taud/md)

%% 
Ga3 = Ga2*Rd2^2
[m,f] = bode(Ga3,wc)

%% rete attenuatrice
mi = 11.7;
figure,bode((1+s/mi)/(1+s)),grid on   % posso perdere circa 4 gradi
xi = 120;
taui = xi/wc;
Ri = (1+s*taui/mi)/(1+s*taui)

%%
Ga = Ga3*Ri
figure,margin(Ga),grid on

%%
C = Kc/s^h * Rd2^2 * Ri

W = feedback(C*F1*F2,1/Kr)

figure,step(W, 10), grid on;   % specifica su sovraelongazione non soddisfatta
figure,bode(W), grid on;    % specifica su wb non soddisfatta (ho 4.61 e max è 4.4)


%% -------  RIFAMO  --------

% wb = 4 rad/s  -->  wc = [2.3, 2.8]
wc = 2.3  % approssimo al minimo

Mr = (1+0.25)/0.9;
Mr_dB = 20*log10(Mr)
% mf da nichols = 40
mf = 60 - 5*Mr_dB
mf = 46  % approssimata

%%
figure,bode(Ga2),grid on;
% recupero circa 60+ gradi e attenuo il modulo di 17dB

%% reti anticipatrici

md1 = 5;
figure,bode((1+s)/(1+s/md1)),grid on
xd1 = 1;
taud1 = xd1/wc;
Rd1 = (1+s*taud1)/(1+s*taud1/md1)

%% 
Ga3 = Ga2*Rd1^2
[m,f] = bode(Ga3,wc)

%% rete attenuatrice
mi = 14;
figure,bode((1+s/mi)/(1+s)),grid on   % posso perdere circa 4 gradi
xi = 160;
taui = xi/wc;
Ri = (1+s*taui/mi)/(1+s*taui)

%%
Ga = Ga3*Ri
figure,margin(Ga),grid on

%%
C = Kc/s^h * Rd2^2 * Ri

W = feedback(C*F1*F2,1/Kr)

figure,step(W, 10), grid on;   % specifica su sovraelongazione non soddisfatta
figure,bode(W), grid on;    % specifica su wb non soddisfatta (ho 4.61 e max è 4.4)


%  AAAAAAAAAAAAAAAA non funzionaaaa chezzooo
