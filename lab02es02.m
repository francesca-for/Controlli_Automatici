%% 2.1 - due poli reali e nessuno zero

clear variables
close all
clc

s=tf('s');

G1 = 20/((s+1)*(s+10));
G2 = 2/(s+1)^2;
G3 = 0.2/((s+1)*(s+0.1));

figure(1), step(G1,'r'); hold on
step(G2,'g');
step(G3,'b');
hold off

%% 2.2 - due poli reali e uno zero in z

clear variables
close all
clc

s=tf('s');

z1 = 100;
z2 = 10;
z3 = 1;
z4 = 0.5;  % compare una sottoelongazione

z5 = -0.9;
z6 = -0.5;
z7 = -0.1;  % compare una sovraelongazione

z8 = -100;
z9 = -10;
z10 = -2;  % cambia la velocità di risposta

for z = [z1,z2,z3,z4]
    G1 = 5/(-z) * (s-z)/((s+1)*(s+5));
    figure(1),step(G1); hold on
end
hold off

for z = [z5,z6,z7]
    G2 = 5/(-z) * (s-z)/((s+1)*(s+5));
    figure(2),step(G2); hold on
end
hold off

for z = [z8,z9,z10]
    G3 = 5/(-z) * (s-z)/((s+1)*(s+5));
    figure(3),step(G3); hold on
end
hold off

%% 2.3 - nessuno zero e due poli complessi coniugati

clear variables
close all
clc

s=tf('s');

wn_z = [2,0.5; 2,0.25; 1,0.5]; 

for i = 1:1:3
    wn = wn_z(i,1);
    z = wn_z(i,2);
    G = wn^2/(s^2+2*z*wn*s+wn^2);

    figure(1),step(G); hold on


    sovrael_max = exp(-pi*z/sqrt(1-z^2))
    % ts = 1/(wn*sqrt(1-z^2)) * (pi-arccos(z))
end
hold off


