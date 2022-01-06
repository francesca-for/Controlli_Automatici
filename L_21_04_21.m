% Matlab ci serve per manipolare facilmente le funzioni di trasferimento e
% calcolarne le loro principali caratteristiche (singolarita', guadagno, ecc)
% Servira' per analizzare il comportamento in frequenza dei sistemi
% tracciando diagrammi di Bode, Nyquist e Nichols della sua fdt, dove gli
% ultimi due sono rappresentazioni grafiche orientate all'analisi della
% stabilita' di un sistema retroazionato dall'uscita
% Infine ci permettera' di simulare la risposta del sistema ad un ingresso
% assegnato per verificare che le specifiche siano soddisfatte
%  ___________________________________________________________

% ESEMPIO: Simulazione di un sistema di controllo nel caso di un
% servomotore in corrente continua (vedi immagine)
% Manca il ramo di retroazione che moltiplicava Omega per Km e lo riportava
% indietro sottraendola a Va. La retroazione interna non c'e' piu' perche'
% e' stato inserito un blocco di azionamento del motore che contiene al suo
% interno una retroazione di corrente: la corrente Ia di armatura viene
% fatta passare per una resistenza nota Rs, la tensione ai suoi capi e'
% proporzionale alla corrente; il blocco di azionamento chiude un anello di
% retroazione di controllo di corrente con l'inserimento di un controllore
% di corrente.
% Se consideriamo l'azionamento come un sistema controllato notiamo che
% l'uscita Ia insegue il riferimento V(r,Ia) se il progetto di C(Ia) e' stato
% fatto in maniera adeguata. Ia rimane agganciata all'andamento di V(r,Ia)
% e il contributo della retroazione interna diventa trascurabile perche'
% diventa assimilabile a un disturbo cancellato dagli effetti del controllo
% di corrente.


% Noi come utenti abbiano a disposizione come tensione di ingresso quella
% dell'azionamento V(r,Ia) e come segnale in uscita V_omega erogata dal
% trasduttore
% -> La parte da controllare e' quella in giallo

% Primo obbiettivo: calcolo della fdt del motore (incluso anello di
% corrente) per Tc=0

% E' utile iniziare il file con clear all e close all per "pulire"
% l'ambiente di lavoro
clear variables
close all

% Poiche' lavoreremo con dft, definiamo la variabile complessa s
s=tf('s');

% Assegniamo i valori numerici ai parametri del sistema (nelle appropriate
% unita' di misura) e definiamo CIa(s).
Ra=6;
L=3.24e-3;
Km=0.05335;
J=20e-6;
beta=14e-6;
KD=0.0285;
Kcond=0.67;
Rs=7.525;
A=2.925;
K=1000;
CIa=K/s;   % controllore di corrente

% Calcoliamo la fdt del sistema chiuso in retroazione (fdt tra Vr,Ia(s) e
% Ia(s), indicata come FrIa(s)) 
% Manualmente puo' essere calcolata come una funzione razionale fratta:
% funzioneRamoDiretto / 1-(funzione d'anello)
% Usiamo il comando  >>  feedback(fdt_ramo_diretto,fdt_retroazione) 
% che ci permette di calcolare in maniera "pulita", ovvero effettuando in
% automatico eventuali cancelazioni zeri-poli
% il alternativa, se la calcolassi a mano, poi dovrei applicare
% minreal(sys) per trovare la forma minima
FrIa = feedback(CIa*A/(L*s+Ra),Rs); % con 2 argomenti assumo che la retroazione sia negativa
                                    % se fosse positiva dovrei indicare come 3^ parametro +1
% A questo punto calcoliamo la fdt complessiva
F = FrIa*Km/(J*s+beta)*KD*Kcond

% Quindi per Tc=0 lo schema a blocchi diventa:
%
%   r    _____  ydes     e    ____________    u    ______        y
%  ---->| Kr  |------>O----->| C_omega(s) |------>| F(s) |-----.--->
%       |_____|    +  | _    |____________|       |______|     |
%                     |________________________________________|
% 
% con:   ydes = Vr,omega    u = Vr,Ia    y= V_omega 

% Simulazione della risposta del sistema ad anello chiuso per diversi
% controllori, considero un riferimento a gradino unitario.
% Consideriamo due tipi di controllore, puramente proporzionale (P) e
% proporzionale-integrativo (PI), che tiene conto di cio' che e' successo in
% passato, mediando nel tempo il segnale d'errore
Kr=1;
Kp=0.4;
C_omega1=Kp; % guadagno proporzionale
Ki=2; % proporzionale all'integrale dell'errore
C_omega2= Kp+Ki/s;

% Calcolo le fdt in catena chiusa che ottengo nei due casi
W1=Kr*feedback(C_omega1*F,1)  % 1 perche' non ho nulla nel ramo in retroazione
W2=Kr*feedback(C_omega2*F,1)

% Applichiamo il gradino unitario con il comando step e vediamo se l'uscita
% insegue il riferimento e come evolve
step(W1,5)
hold on
step(W2,5)
hold off

% Notiamo che in entrambi i casi il sistema e' asintoticamente stabile, ma
% con C_omega=Kp l'uscita a regime converge ad un valore diverso da 1,
% quindi errore non nullo (e=0.205)
% Anche nel transitorio il comportamento e' diverso, con C_omega=Kp+Ki/s si
% ha sovraelongazione (significativa, circa 27%), tempo di assestamento
% maggiore (circa doppio) ma tempo di salita inferiore
% Questa differenza nel comportamento dipende dalla posizione dei poli delle W(s)
% Il comando >> damp(W1)   determina i poli della fdt nella forma "parte
% reale + parte immaginaria" e ne fornisce anche pulsazione naturale e
% fattore di smorzamento
damp(W1)
damp(W2)

% I poli dominanti sono: -3,41e+00 per W1 e -1,70e+00 +- 3,26e+00i per W2,
% quindi ho una coppia di poli complessi coniugati.
% La costante di tempo si determina come 1/|Re(polo)|, quindi circa 1/3 per
% W1 e circa 2/3 per W2. Gli altri poli, avendo parte reale di due ordini di
% grandezza piu' piccola, avranno anche costante di tempo di due ordini di
% grandezza piu' piccola. Le voluzione dei modi associati a questi poli si
% esaurisce prima che sia finito il transitorio del polo dominante.
% Per questo motivo W1 non presenta sovraelongazione 
% W2 e' caratterizzato da una coppia di poli complessi coniugati, quindi
% presenta elongazione, che e' elevata perche' presentano un fattore di
% smorzamento basso (<< di radice(2)/2)

%%
% Facendo variare Kp, cosa cambia? (transitorio, asintotica stabilita'...)

% Caso 1:  Kp = 0.8 )

clear all
close all

s=tf('s');

Ra=6;
L=3.24e-3;
Km=0.05335;
J=20e-6;
beta=14e-6;
KD=0.0285;
Kcond=0.67;
Rs=7.525;
A=2.925;
K=1000;
CIa=K/s;

FrIa = feedback(CIa*A/(L*s+Ra),Rs);

F = FrIa*Km/(J*s+beta)*KD*Kcond

Kr=1;
Kp2=0.8;  %   -->   raddoppio, do un'azione di controllo piu' forte
C_omega1=Kp2; 
Ki=2;
C_omega2= Kp2+Ki/s;

% Calcolo le fdt in catena chiusa
W1=Kr*feedback(C_omega1*F,1)
W2=Kr*feedback(C_omega2*F,1)

step(W1,5)
hold on
step(W2,5)
hold off
damp(W1)
damp(W2)

% Per W1 l'errore rimane nullo a regime, quindi il valore di Kp non
% influisce, per W2 notiamo che il valore finale e' piu' vicino a quello
% desiderato, errore e quasi dimezzato.
% Si nota che in W2 la sovraelongazione e' minore rispetto a prima e W1
% continua a non presentarla.

% W1 continua ad avere un polo reale dominante, W2 una coppia di poli
% complessi coniugati dominanti; la differenza sta nel fattore di
% smorzamento che e' diventato molto piu' grande (0.832).

%%
% Caso 2:  Kp = 1.6 )

clear all
close all

s=tf('s');

Ra=6;
L=3.24e-3;
Km=0.05335;
J=20e-6;
beta=14e-6;
KD=0.0285;
Kcond=0.67;
Rs=7.525;
A=2.925;
K=1000;
CIa=K/s;

FrIa = feedback(CIa*A/(L*s+Ra),Rs);

F = FrIa*Km/(J*s+beta)*KD*Kcond

Kr=1;
Kp3=1.6;  %   -->   raddoppio di nuovo
C_omega1=Kp3; 
Ki=2;
C_omega2= Kp3+Ki/s;

% Calcolo le fdt in catena chiusa
W1=Kr*feedback(C_omega1*F,1)
W2=Kr*feedback(C_omega2*F,1)

step(W1,5)
hold on
step(W2,5)
hold off
damp(W1)
damp(W2)

% Aumentando ancora Kp speriamo di migliorare il valore dell'uscita e
% diminuire la sovraelongazione.
% Dal grafico possiamo vedere che questo funziona.
% Cambiando il valore di Kp abbiamo spostato i poli facendo diminuire il
% fattore di smorzamento 

% Si "intuisce" che continuano ad aumentare Kp possiamo ulteriormente
% migliorare il valore dell'uscita e diminuire la sovraelongazione ma,
% dovendo assegnare un valore finito, non si azzerera' mai l'errore
% --> Non e' detto inoltre che si possa aumentare a piacimento Kp senza
% compromettere la stabilita' del sistema


%%
% PRECISIONE A REGIME PERMANENTE

%  Si consideri il consueto schema di controllo:
%                                                         |d
%   r    _____  ydes     e    ______    u    ______      +v      y
%  ---->| Kr  |------>O----->| C(s) |------>| F(s) |----->O----.--->
%       |_____|    +  | _    |______|       |______|    +      |
%                     |________________________________________|
% 
% fdt d'anello:  Ga(s) = C(s)*F(s)
% fdt in catena chiusa:  W(s) = y(s)/r(s);  Wy(s) = y(s)/ydes(s)
%
% Supponiamo che l'asintotica stabilita' in catena chiusa sia garantita
% dall'azione del controllore, quindi ci assicura l'esistenza di un regime
% permanente.
% La precisione con cui l'uscita insegue il riferimento e' spesso oggetto
% di specifica. Le specifiche vengono di solito formulate rispetto al
% valore massimo ottenuto in regime permanente, si definisce l'errore
% e=ydes-y  per un dato segnale di riferimento.
% Le famiglie di segnali canonici di riferimento di maggiore interesse
% pratico sono costituiti dai segnali polinomiali e dai segnali sinusoidali
%       r(t) = t^k/k!  ->  r(s) = 1/s^(k+1),   k=0,1,2,...
%       r(t) = sin(omega0*t)  ->  r(s) = omega0/(s^2+omega0^2)
% ad entrambi posso applicare il fattore di scala Kr che mi permette di
% assegnare l'ampiezza desiderata e definire cosi' l'effettiva y desiderata
%
% Usiamo segnali di riferimento polinomiali perche' sono lo strumento
% matematico piu' semplice per definire i principali tipi di comportamento
% che ci aspettiamo di ottenere sul sistema

% ES) k=0, r(t)= epsilon(t) -> ydes(t)=Kr*epsilon(t)
%       L'uscita desiderata e' un gradino di ampiezza Kr
%       Per un sistema meccanico con uscita in posizione corrisponde ad
%       imporre posizione desiderata pari a Kr
%     K=1,  r(t)=t -> ydes(t)=Kr*t
%       L'uscita desiderata e' una rampa di coefficiente angolare Kr.
%       Per un sistema meccanico con uscita in posizione corrisponde ad
%       imporre velocita' dsiderata costante paria  Kr
%     K=2,  r(t)=0.5t^2 -> ydes(t)=0.5Kr*t^2
%       L'uscita desiderata e' un arrco di parabola
%       Per un sistema meccanico con uscita in posizione corrisponde ad
%       imporre accelerazione desiderata costante pari a Kr

% ES) per spostare un braccio robotico dalla posizione iniziale a una
%     posizione finale desiderata viene solitamente utilizzato un profilo
%     di riferimento in posizione di tipo 2-1-2 (cioe' formato dalla
%     sequenza di tre polinomi di ordine 2, 1, 2), generato in modo da
%     rispettare i vincoli di velocita' ed accelerazione massime consentite.
%     Tale profilo corrisponde ad un profilo in velocita' di tipo
%     trapezoidale, ovvero ad un profilo di riferimento in accelerazione
%     formato da una sequenza di gradini.

% Formulare delle richieste sulla capacita' dell'uscita di un sistema di
% inseguire un segnale di riferimento sinusoidale equivale a valutare la
% capacita' di inseguire un segnale generico le cui componenti in frequenza
% sono riconducibili ai segnali sinusoidali considerati.
% Specifiche sull'errore massimo di inseguimento di segnali sinusoidali in
% regime permanente corrispondono a garantire una buona precisione
% all'interno di una banda di pulsazioni di interesse.

