% Simulink ci permette di simulare facilmente sistemi interconnessi,
% consentendo la loro rappresentazione direttamente per mezzo del
% corrispondente schema a blocchi.
% L'uso congiunto di Matlab e Simulink permette di sviluppare interamente
% il progetto di un sistema di controllo, verificando agevolmente il
% soddisfacimento delle specifiche di progetto, nonche' la valutazione
% delle prestazioni di interesse.
% 
% - Posso assegnare agevolmente differenti segnali di riferimento
% - Posso considerare la presenza contemporanea di disturbi lungo
%   l'anello
% - Posso visualizzare direttamente l'andamento di piu' variabili di
%   interesse mediante oscilloscopi virtuali
% - Posso salvare in un file il risultato di una simulazione e/o renderlo
%   disponibile nello spazio di lavoro di Matlab
%
% > per aprire Simulink, e' sufficiente digitare la parola "simulink"
%   nella finestra di comando di Matt oppure cliccare sull'icona 
% > Dalla finestra del "Simulink library browser" e' possibile:
%     - creare un novo modello o aprirne uno esistente dal menu "File"
%     - individuare gli elementi di interesse nella libreria principale di
%       Simulink 
% Cartelle particolari: "Continuous" e "Discrete" che contengono blocchi
% principali associati alla rappresentazione di sistemi dinamici a tempo
% continuo e discreto, "LTI System" ci permette di definire direttamente
% un sistema LTI sia a TC che TD
% Nell'interfaccia si puo' inserire la FDT del blocco, ma e' anche
% possibile associarlo ad una funzione definita in Matlab.
% Nella cartella di "Signal Routing" ci sono blocchi utili per la gestione
% dei segnali, "Mux" "Demux" per multiplexer e demultiplexer, "Manual Switch"
% e "Switch" per interruttori manuali e automatici.
% Nella cartella "Sinks" ci sono blocchi utili per la visualizzazione,
% "Scope" oscilloscopio virtuale, "To Workspace" per rendere la variabile
% disponibile nello spazio di lavoro in Matlab e "To File" per salvarla in
% un file .mat
% E' possibile raggruppare parte dei blocchi creando dei sottosistemi
