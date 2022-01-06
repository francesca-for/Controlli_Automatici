clear all
close all
s = tf('s');

F1 = 1/(s*(s+2)*(s+4));

F2 = 10/s*F1;

F3 = F2*(s+1);

Kf3 = dcgain(s^2*F3);
figure,bode(F3);
figure,nichols(F3)

% dai diagrammi di bode vediamo che il modulo decresce sempre, da +inf a
% -inf in dB. Nel daigramma di Nichols ritrovo l'andamento del modulo
% sull'asse delle ordinate, quindi il diagramma scendera' da +inf a - inf.
% In che modo? Seguendo l'andamento della fase.
% Da bode vediamo che la fase iniziale vale -180, sale al di sopra per poi
% scendere fino a -270. La fase nei diagrammi di Nichols va da -360 a 0,
% quindi il diagramma partirà dall'alto dall'asse centrale verticale con
% valori un po' maggiori di -180, ad una certa pulsazione tagliera' l'asse
% per poi continuare a scendere fino a -270

% Possiamo leggere i margini di stabilita' direttamente dal diagramma di
% Nichols: il margine di guadagno viene letto in corrispondenza della
% pulsazione alla quale la fase vale -180.
% E' facile anche leggere il margine di fase, e' l'intersezione del
% diagramma con la linea orizzontale 0 dB, ovvero la omega di crossover; il
% margine di fase e' di quanto sono al di sopra di -180
