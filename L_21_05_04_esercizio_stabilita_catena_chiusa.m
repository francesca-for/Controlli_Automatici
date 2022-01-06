clear all
close all
s=tf('s');
Kr=1;
F1=(s+1)/(s-1);
F2=(s+1)/(s*(s-1));
Gaf=F1*F2;
bode(Gaf)
figure,nyquist(Gaf)
axis equal