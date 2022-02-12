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
     Kc = Kr/(0.16*Kf1*Kf2/Kr)
% >  effetto di d sull'uscita pari al massimo in modulo a 0.05
     % sempre soddisfatta perchè ho un polo a monte

%%
zeri = zero(Ga1)
poli = pole(Ga1)

% fase_0 = -90
% fase_inf = -90 -90*2 +90
figure,bode(Ga1),grid on;
figure,nyquist(Ga1);
% --> Kc positivo

Ga2 = Ga1*Kc/s^h

%%
% wb = 4 rad/s  -->  wc = [2.3, 2.8]
wc = 0.63*4
wc = 2.5  % approssimata

Mr = (1+0.25)/0.9;
Mr_dB = 20*log10(Mr)
% mf da nichols = 41
mf = 60 - 5*Mr_dB
mf = 46  % approssimata

%%
figure,bode(Ga2),grid on;
% recupero circa 60+ gradi

%% reti anticipatrici

md1 = 3;
figure,bode((1+s)/(1+s/md1)),grid on
xd1 = 1.3;
taud1 = xd1/wc;
Rd1 = (1+s*taud1)/(1+s*taud1/md1)

md2 = 4;
figure,bode((1+s)/(1+s/md2)),grid on
xd2 = 1;
taud2 = xd2/wc;
Rd2 = (1+s*taud2)/(1+s*taud2/md2)
%% 
Ga3 = Ga2*Rd1*Rd2
[m,f] = bode(Ga3,wc)

%% rete attenuatrice
mi = 4;
figure,bode((1+s/mi)/(1+s)),grid on 
xi = 60;
taui = xi/wc;
Ri = (1+s*taui/mi)/(1+s*taui)

%%
Ga = Ga3*Ri
figure,margin(Ga),grid on

%%
C = Kc/s^h * Rd2^2 * Ri

W = feedback(C*F1*F2,1/Kr)

figure,step(W, 10), grid on;   % specifica su sovraelongazione non soddisfatta
figure,bode(W), grid on;    % specifica su wb soddisfatta (ho 4.07 e max è 4.4)


%% -------  RIFAMO  --------

% wb = 4 rad/s  -->  wc = [2.27, 2.77]
wc = 0.63*4
wc = 2.2  % approssimata

Mr = (1+0.25)/0.9;
Mr_dB = 20*log10(Mr)
% mf da nichols = 41
mf = 60 - 5*Mr_dB
mf = 46  % approssimata

%%
figure,bode(Ga2),grid on;
% recupero circa 60+ gradi

%% reti anticipatrici
md = 4;
figure,bode((1+s)/(1+s/md)),grid on
xd = 1.2;
taud = xd/wc;
Rd = (1+s*taud)/(1+s*taud/md)

%% 
Ga3 = Ga2*Rd^2
[m,f] = bode(Ga3,wc)

%% rete attenuatrice
mi = 5.6;
figure,bode((1+s/mi)/(1+s)),grid on
xi = 130;
taui = xi/wc;
Ri = (1+s*taui/mi)/(1+s*taui)

%%
Ga = Ga3*Ri
figure,margin(Ga),grid on

%%
C = Kc/s^h * Rd^2 * Ri

W = feedback(C*F1*F2,1/Kr)

figure,step(W, 10), grid on;   % specifica su sovraelongazione soddisfatta
figure,bode(W), grid on;    % specifica su wb soddisfatta

%%
open_system('es_tipo_esame_2_schema');

%% 1.2)
% Valutare tempo di salita, il picco di risonanza della risposta in
% frequenza, il valore massimo del comando u(t) Applicato dal controllore
% progettato, quando r(t)=1 (gradino unitario)

% >> ts = 0.66 s
% >> Mr_freq = 2.8 dB in w = 1.36
% >> max_cmd = 1.27 da simulink (non posso calcolarlo in modo diretto)

%% 1.3) Discretizzazione del controllore
wb = 4.15;
% T = 2*pi/(20*wb)
T = 0.01;
Ga_zoh = c2d(Ga, T, 'zoh')
figure,margin(Ga_zoh);   % per verificare che il margine di fase sia accettabile

Cd = c2d(C, T, 'tustin');
%%
open_system('es_tipo_esame_2_schema');

%% Esercizio 3)

clear variables
close all
clc
s = tf('s');

F = (100*s+1000)/(s^5+38*s^4+481*s^3+2280*s^2+3600*s)

zeri = zero(F)
poli = pole(F)

N = 10;

% polo in zero, non posso applicare Ziegler Nichols in anello aperto

figure,margin(F),grid on
Kpbar = 27.1;
wpi = 3.54
Tbar = 2*pi/wpi;

Kp = 0.6*Kpbar;
Ti = 0.5*Tbar;
Td = 0.125*Tbar;

PID = Kp*(1+1/(Ti*s)+Td*s/(1+Td*s/N))

Ga = F*PID

W = feedback(Ga,1);

figure,step(W),grid on;
figure,bode(W),grid on;

% picco di risonanza = 7.16
% banda passante = 5.62