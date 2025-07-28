library IEEE;
use IEEE.std_logic_1164.all;

entity Seven_segment is
	port (disp_in: in integer range 0 to 9;
			disp_out: out std_logic_vector(7 downto 0));
end Seven_segment;

architecture display_arc of Seven_segment is
	begin 
		process(disp_in)
			begin 
					case disp_in is 
						when 0 => disp_out<="11000000"; -- output a 0 = led acceso nel display
						when 1 => disp_out<="11111001"; 
						when 2 => disp_out<="10100100"; 
						when 3 => disp_out<="10110000"; 
						when 4 => disp_out<="10011001"; 
						when 5 => disp_out<="10010010"; 
						when 6 => disp_out<="10000010"; 
						when 7 => disp_out<="11111000"; 
						when 8 => disp_out<="10000000";
						when 9 => disp_out<="10010000";
						when others => disp_out<="11000000";
					end case;
				
		end process;
end display_arc;

