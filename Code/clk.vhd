library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

-- clock divider da 50MHz a 20hz OGGETTI CHE CADONO (1 20esimo di secondo)
ENTITY clk IS
		PORT(clk_in: IN STD_LOGIC;
			  clk_out: OUT STD_LOGIC);		  
END clk;

ARCHITECTURE clk_divider OF clk IS
	signal clk_i: std_logic := '0';
	signal count_i: std_logic_vector(24 downto 0) := "0000000000000000000000000";
	begin 
	
		process(clk_in)
		begin
			if rising_edge(clk_in) then
				count_i <= count_i + '1';
				if count_i = "000100110001001011001111" then --  1.249.999(20HZ - (50.000.000/(20*2)) – 1)
					clk_i <= not clk_i;     -- ciclo di clock completo
					count_i <= "0000000000000000000000000"; -- reset contatore
				end if;
				
			end if;
		end process;
		clk_out<=clk_i;
		
END clk_divider;
