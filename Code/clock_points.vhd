library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-- clock divider da 50MHz a 1Hz per la gestione del punteggio
ENTITY clk_points IS

		PORT(clk_in: IN STD_LOGIC;
			  clk_out: OUT STD_LOGIC);
			  
END clk_points;


ARCHITECTURE clk_divider OF clk_points IS
	signal clk_i: std_logic := '0';
	signal count_i: std_logic_vector(24 downto 0) := "0000000000000000000000000";
	
	begin 
	
		process(clk_in)
		begin
			if rising_edge(clk_in) then
				count_i <= count_i + '1';
				if count_i = "1011111010111100000111111" then -- 24.999.999(clock da 1Hz)
					clk_i <= not clk_i;   -- ciclo di clock completo
					count_i <= "0000000000000000000000000";
				 
				end if;
				
			end if;
		end process;
		
		clk_out<=clk_i;
		
END clk_divider;