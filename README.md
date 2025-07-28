# Avoid Clash – FPGA Game in VHDL 🎮

## Descrizione del Progetto

**Avoid Clash** è un videogioco arcade sviluppato in **VHDL** e implementato su **scheda FPGA Terasic DE10-Lite**. L’obiettivo del gioco è semplice: muovere una piattaforma (paddle) per evitare ostacoli che cadono dall’alto. Il giocatore può muoversi solo orizzontalmente tramite un joystick. Il punteggio aumenta col tempo, mentre le collisioni fanno perdere vite.

Il progetto dimostra come sia possibile realizzare giochi interattivi direttamente su FPGA utilizzando linguaggio VHDL, sfruttando VGA, joystick, clock divider, generatori casuali (LFSR) e display a 7 segmenti.

---

## Hardware Utilizzato

- **Scheda FPGA**: Terasic DE10-Lite (Intel MAX 10)
- **Joystick analogico**
- **Monitor VGA (collegato via cavo VGA)**
- **Display a 7 segmenti (integrati nella scheda)**
- **LED per indicare le vite**

---

## Software

- **Intel Quartus Prime Lite Edition**
- Linguaggio: **VHDL**
- Simulazione e sintesi logica direttamente in ambiente Quartus

---

## Come Funziona il Gioco

- Il gioco parte con 3 vite.
- Un punto viene aggiunto ogni secondo di sopravvivenza.
- Gli ostacoli cadono con velocità crescente e sono gestiti tramite un generatore pseudo-casuale (LFSR).
- Se il paddle tocca un ostacolo, si perde una vita.
- Il gioco termina quando:
  - Si raggiungono **100 punti** → VITTORIA (schermo verde).
  - Si perdono tutte le vite → GAME OVER (schermo rosso).
- Il punteggio viene visualizzato su tre display a 7 segmenti.
- Il gioco può essere riavviato tramite uno switch sulla board (reset).

## Contenuti del Progetto

La repository è organizzata in questo modo:
- Code folder: cartella contenente tutto il codice del progetto
- PinPlanner.csv: file contenente la lista dei pin utilizzati nel progetto, essenziale per replicare il setup della FPGA
- Report.pdf: documentazione dettagliata utile per replicare il gioco. 
