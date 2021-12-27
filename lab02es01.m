% Sistemi dinamici SISO LTI del primo ordine, risposte all'impulso e al gradino

clear variables
close all
clc

s=tf('s');

fdt = menu('Sistemi dinamici SISO LTI:', ...
           'G1(s) = 10/(s-5)', ...
           'G2(s) = 10/s', ...
           'G3(s) = 10/(s+5)', ...
           'G4(s) = 10/(s+20)');

switch fdt
    case 1, G = 10/(s-5);
    case 2, G = 10/s;
    case 3, G = 10/(s+5);
    case 4, G = 10/(s+20);
end

figure(1), impulse(G);

figure(2), step(G);
