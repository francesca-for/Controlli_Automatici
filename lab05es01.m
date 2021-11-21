clear all
close all
clc

s=tf('s');

F=(s^2+11*s+10)/(s^4+4*s^3+8*s^2)

% Kc controllore statico di guadagno (da definire)
%
%                         d1             d2
%                         |              |
%    r(s)--->O---> Kc --->O---> F(s) --->O--- y(s) --->
%            ^                                 |
%          - |____________ 1/Kr _______________|

Kr=1;

%guadagno stazionario
Kf=dcgain(s^2*F)

%zeri e poli
zeri = zero(F)
poli = pole(F)
damp(F)

%% punto b - Bode

% considerazioni: Kf è positivo, quindi non darà contributo in termini di
% sfasamento di fase, zeri < 0, polo doppio nell'origine e coppia di complessi
% coniugati con pulsazione di risonanza in 2.82 e smorzamento 0.707
% La fase iniziale vale -180, dovuto al polo doppio nell'origine
% Il modulo parte scendendo con -40 dB/dec, poi ho l'effetto del primo zero
% che lo fa risalire un poco, ho l'effetto della coppia di complessi
% coniugati che non da' una sovraelongazione apprezzabile, poi ho l'effetto
% dei due poli quindi ho pendenza di -60, per finire con l'effetto dello
% zero che mi fa ritornare a pendenza -40
%
% La fase parte da -180, ho un recupero dovuto ai due zeri (+180)e una
% perdita (-180)per i due poli c.c., quindi fase finale = -180
% Per primo trovo zero di pulsazione 1 che fa guadagnare fase, in 2.83 ho i
% due poli c.c. che fanno perdere 180 e ci metto meno di due decadi perche'
% il fattore di smorzamento fa stringere questo intervallo di frequenze,
% poi ho l'effetto dello zero con pulsazione 10 che mi fa guadagnare 90

Kc=1;
Ga=F*Kc/Kr;  %funzione di trasferimento d'anello del sistema in retroazione

figure,bode(Ga);

%% punto c - Nyquist

% Il modulo parte da +inf e decresce sempre andando a -inf
% La fase parte da -180 (da sotto), aumenta inizialmente poi decresce
% attraversando l'asse reale negativo e finendo nell'origine da sopra

figure,nyquist(Ga);


%% punto d - verifica stabilità mediante criterio di Nyquist

% Osserviamo che il punto A si trova a destra del punto critico
% Si nota che N=0 e poichè nia=0, anche nic=0

% calcolo diretto
W=feedback(Kc*F, 1/Kr)  % primo arg. -> ramo diretto, secondo -> ramo in retroazione
damp(W)
% verifico che tutti i poli abbiano effettivamente parte reale < 0

%% punto e - calcolare errore di inseguimento a regime

% Calcolo analitico:

We=Kr*feedback(1,Ga)
Wd1=feedback(F,Kc/Kr)
Wd2=feedback(1,Ga)

% caso 1
% r1=t, errore di inseguimento intrinseco NULLO perche' il sistema e' di tipo 2
% d2=0.5 costante agisce sull'uscita, ho effetto sull'uscita nullo perche' ho
% almeno un polo nell'origine a monte del disturbo
% d1=0.1 costante, ha effetto d1/(Kc/Kr) perche' ci sono poli solo nel blocco a
% valle del disturbo

errore_r=dcgain(s*We*1/s^2)
effetto_d1=dcgain(s*Wd1*0.1/s)
effetto_d2=dcgain(s*Wd2*0.5/s)
errore_tot=errore_r-(effetto_d1+effetto_d2)

open_system('lab05es1e_errore_inseguimento')
sim('lab05es1e_errore_inseguimento')

pause;

% caso 2
% r2=2t, errore di inseguimento intrinseco NULLO perche' il sistema e' di tipo 2
% d1=0
% d2=0.01t a rampa, l'effetto sull'uscita e' nullo perche' il sistema e' di
% tipo 2

errore_r=dcgain(s*We*2/s^2)
effetto_d1=dcgain(s*Wd1*0)
effetto_d2=dcgain(s*Wd2*0.01/s^2)
errore_tot=errore_r-(effetto_d1+effetto_d2)

open_system('lab05es1e_errore_inseguimento')
sim('lab05es1e_errore_inseguimento')

pause;

% caso 3
% r3=t^2/2, errore di inseguimento intrinseco pari a Kr/KGa, con KGa =
% Kc*Kf/Kr perche' il sistema e' di tipo 2 ed e' posto ad inseguire un
% riferimento di secondo grado.
% d1=0
% d2=0

errore_r=dcgain(s*We*1/s^3)
effetto_d1=dcgain(s*Wd1*0)
effetto_d2=dcgain(s*Wd2*0)
errore_tot=errore_r-(effetto_d1+effetto_d2)

open_system('lab05es1e_errore_inseguimento')
sim('lab05es1e_errore_inseguimento')

pause;

% caso 4
% r4=t^2/2, errore di inseguimento intrinseco pari a Kr/KGa, KGa=Kc*Kf/Kr
% d1=0.1 effetto sull'uscita costante pari a d1/(Kc/Kr) perche' ci sono
% poli nell'origine solo a valle del disturbo
% d2=0.2 con effetto sull'uscita nullo perche' ho almeno un polo in 0 a
% monte del disturbo

errore_r=dcgain(s*We*1/s^3)
effetto_d1=dcgain(s*Wd1*0.1/s)
effetto_d2=dcgain(s*Wd2*0.2/s)
errore_tot=errore_r-(effetto_d1+effetto_d2)

open_system('lab05es1e_errore_inseguimento')
sim('lab05es1e_errore_inseguimento')
