library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY hw_image_generator IS
  GENERIC(
    border_sx : INTEGER := 300; -- Coordinate del bordo sinistro
    border_dx : INTEGER := 1380 -- Coordinate del bordo destro
  );

  PORT(
    reset : in std_logic; 
    clk_points : in std_logic; -- Clock a 1Hz per il punteggio
    lfsr : in std_logic_vector(10 downto 0); -- Output del generatore di numeri casuali
    clk : in std_logic; -- Clock caduduta ostacoli ad 20Hz
	 
    move : in std_logic_vector(1 downto 0); 
    clk_obj : in std_logic; -- Clock a 10Hz per il movimento paddle
	 
    disp_ena : in std_logic; -- Abilitazione display ('1' = visualizzazione, '0' = blanking)
    row : in integer; -- Coordinata della riga dei pixel
    column : in integer; -- Coordinata della colonna dei pixel
	 
    red : out std_logic_vector(3 downto 0) := (OTHERS => '0'); -- Uscita del colore rosso per il DAC
    green : out std_logic_vector(3 downto 0) := (OTHERS => '0'); -- Uscita del colore verde per il DAC
    blue : out std_logic_vector(3 downto 0) := (OTHERS => '0'); -- Uscita del colore blu per il DAC
    
	 led : out std_logic_vector(2 downto 0) := (OTHERS => '0'); -- Uscita per i LED
	 
	 out_disp_1: out std_logic_vector(7 downto 0);
	 out_disp_2: out std_logic_vector(7 downto 0);
	 out_disp_3: out std_logic_vector(7 downto 0)
  );
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
  signal new_x: integer := 840; -- Coordinata orizzontale del centro del paddle
  signal new_y: integer := 950; -- Coordinata verticale del paddle
    
  signal obs_x: integer := 840; -- Coordinata orizzontale iniziale dell'ostacolo
  signal obs_y: integer := 0; -- Coordinata verticale iniziale dell'ostacolo
  signal obs2_x: integer := 0; -- Coordinata orizzontale del secondo ostacolo
  signal obs2_y: integer := 0; -- Coordinata verticale del secondo ostacolo
  
  signal lives: std_logic_vector(2 downto 0) := "111"; -- Vite del giocatore
  signal points: integer := 0; -- Punteggio del giocatore
  signal state: std_logic_vector(1 downto 0) := "11"; -- state del gioco ("00" = game over, "11" = in vita)
  
  signal Digit1 : integer :=0;
  signal Digit2 : integer :=0;
  signal Digit3 : integer :=0;
  
  component Seven_segment is
	port (disp_in: in integer range 0 to 9;
			disp_out: out std_logic_vector(7 downto 0));
	end component Seven_segment;

BEGIN
	
	display1 : Seven_segment port map(Digit1, out_disp_1);
	display2 : Seven_segment port map(Digit2, out_disp_2);
	display3 : Seven_segment port map(Digit3, out_disp_3);
	
  -- Processo di gestione del punteggio
  score: process(clk_points, reset)
  begin
    if (reset = '1') then
      points <= 0; -- Ripristina il punteggio
		Digit3 <= 0;
		Digit2 <= 0;
	   Digit1 <= 0;
		
	 elsif (rising_edge(clk_points)) then
		IF(lives/="000") THEN
		
        points <= points + 1; -- Incrementa il punteggio
		  IF(points = 101)THEN
			  points <= points;-- mantiene 100
			  Digit3 <= Digit3;
		     Digit2 <= Digit2;
	        Digit1 <= Digit1;
			  
		  ELSE
			Digit3 <= points/100; -- centinaia
			Digit2 <= (points/10) mod 10; -- decine
			Digit1 <= points mod 10; -- unita
		  END IF;
		  
		ELSE
		  Digit3<=Digit3;
		  Digit2<=Digit2;
	     Digit1<=Digit1;
	   END IF;
		
      end if;
  end process;
  
  -- Processo di gestione del movimento del paddle
  shift: process(clk_obj, reset)
  begin
    if reset = '1' then
      new_y <= 950;
		new_x <= 840; -- Ripristina la posizione orizzontale del paddle
		
    elsif (rising_edge(clk_obj) and state="11") then
      if move = "00" then -- Sposta a sinistra
        if new_x > 361 then -- Verifica che ci sia spazio a sinistra
          new_x <= new_x - 50; -- Sposta il paddle a sinistra
        end if;
      elsif move = "01" then -- Sposta a destra
        if new_x < 1319 then -- Verifica che ci sia spazio a destra
          new_x <= new_x + 50; -- Sposta il paddle a destra
        end if;
      elsif move = "10" then
        new_x <= new_x; -- Mantiene la posizione attuale
      end if;
    end if;
  end process;
     
  -- Processo di gestione degli ostacoli
  obstacles: process(clk, reset)
  begin  
    if reset = '1' then
      obs_y <= 0; -- Ripristina la posizione verticale del primo ostacolo
      obs_x <= conv_integer(unsigned(lfsr)); -- Genera una nuova posizione orizzontale casuale per il primo ostacolo
      obs2_x <= 0; -- Ripristina la posizione orizzontale del secondo ostacolo
      obs2_y <= 0; -- Ripristina la posizione verticale del secondo ostacolo
      state <= "11";
      lives <= "111";

    elsif (rising_edge(clk) and state="11") then
        if obs_y < 525 then
          obs_y <= obs_y + 25; -- Il primo ostacolo scende
		  elsif obs_y = 525 then
          obs_y <= obs_y + 25;
          obs2_x <= conv_integer(unsigned(lfsr)); -- Genera una nuova posizione orizzontale casuale per il secondo ostacolo
		  elsif obs_y > 525 and obs_y < 1025 then
          obs_y <= obs_y + 25;
          obs2_y <= obs2_y + 25;
          -- Collisione tra ostacolo e macchinina
          if obs_y = 875 and ((obs_x > new_x - 25  and obs_x < new_x + 75) or (obs_x > new_x - 75 and obs_x < new_x +25)) then
            if lives = "000" then
              state <= "00"; -- Game over
            elsif lives = "111" then
              obs_x <= obs_x + 2000; -- Sposta l'ostacolo fuori dallo schermo
              lives <= "110"; -- Perde una vita
            elsif lives = "110" then
              obs_x <= obs_x + 2000; -- Sposta l'ostacolo fuori dallo schermo
              lives <= "100"; -- Perde una vita
            elsif lives = "100" then
              obs_x <= obs_x + 2000; -- Sposta l'ostacolo fuori dallo schermo
              lives <= "000"; -- Perde l'ultima vita
            end if;
          end if;
        elsif obs_y = 1025 then
          obs_x <= obs2_x; -- Riposiziona il primo ostacolo
          obs_y <= obs2_y; -- Riposiziona il primo ostacolo
          obs2_x <= 0; -- Ripristina la posizione del secondo ostacolo
          obs2_y <= 0; -- Ripristina la posizione del secondo ostacolo
        end if;
        led <= lives; -- Aggiorna i LED con le vite attuali 
      end if;
  end process;
  

  -- Processo per la grafica
  graphics: process(disp_ena, row, column, reset)
  begin
    if reset = '1' then
      red <= (others => '0');
      green <= (others => '0');
      blue <= (others => '0');
		
    elsif disp_ena = '1' then -- Tempo di visualizzazione
      if lives = "000" then
        red <= (others => '1');
        green <= (others => '0'); -- Sfondo tutto rosso, sconfitta
        blue <= (others => '0');
      elsif points = 101 then
        red <= (others => '0');
        green <= (others => '1'); -- Vittoria verde
        blue <= (others => '0');
      elsif state = "11" then
        if column < new_x + 50 and column > new_x - 50 and row < new_y + 25 and row > new_y - 25 then
          red <= (others => '0');
          green <= (others => '0'); -- Paddle blu
          blue <= (others => '1');
        elsif column < border_sx or column > border_dx then
          red <= (others => '0');
          green <= (others => '0'); -- Bande laterali nere
          blue <= (others => '0');
        elsif column < obs_x + 50 and column > obs_x - 50 and row < obs_y + 50 and row > obs_y - 50 then
          red <= (others => '1');
          green <= (others => '0'); -- Ostacolo 1 rosso
          blue <= (others => '0');
        elsif column < obs2_x + 50 and column > obs2_x - 50 and row < obs2_y + 50 and row > obs2_y - 50 and obs2_x /= 0 and obs2_y /= 0 then
          red <= (others => '0');
          green <= (others => '1'); -- Ostacolo 2 verde
          blue <= (others => '0');
        else
			 red <= (others => '1');
			 green <= (others => '1'); -- Sfondo bianco
			 blue <= (others => '1');
        end if;
      end if;
    else
      red <= (others => '0');
      green <= (others => '0');  ---display spento
      blue <= (others => '0');
    end if;
  end process;
  
END behavior;