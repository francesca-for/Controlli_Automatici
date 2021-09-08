% Sistemi dinamici SISO LTI, risposte all'impulso e al gradino

s=tf('s');

H1=10/(s-5);
H2=10/s;
H3=10/(s+5);
H4=10/(s+20);

figure(1), impulse(H1,'r');
figure(2), impulse(H2,'r');
figure(3), impulse(H3,'r');
figure(4), impulse(H4,'r');
pause;

figure(1), step(H1,'g');
figure(2), step(H2,'g');
figure(3), step(H3,'g');
figure(4), step(H4,'g');
