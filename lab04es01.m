clear variables
close all
clc

% parametri del motore elettrico:
Ra=1; La=6e-3; Km=0.5; J=0.1; beta=0.02; Ka=10;

s = tf('s');
F1 = Ka*Km/(s^2*J*La+s*(beta*La+J*Ra)+beta*Ra+Km^2)
F2 = -(s*La+Ra)/(s^2*J*La+s*(beta*La+J*Ra)+beta*Ra+Km^2)

%% simulazione del sistema in catena aperta
open_system('lab04es01a_schema');

%% simulazione del sistema in catena chiusa
Kc1 = 0.1;
Kc2 = 1;
Kc3 = 5;
open_system('lab04es01b_schema');

%% Calcolare la fdt del sistema controllato w/wrif per Td(s)=0 e tracciarne i DdB 

for Kc = [Kc1,Kc2,Kc3]
    fprintf("Kc = %d", Kc);
    W = feedback(Kc*F1,1)
    zeri = zero(W)
    poli = pole(W)
    damp(W)
    bode(W),grid on,hold on
    pause
end


