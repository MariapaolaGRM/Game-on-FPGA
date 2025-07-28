library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR is
    Port (
        clk : in STD_LOGIC;
        random_number : out STD_LOGIC_VECTOR(10 downto 0)
    );
end LFSR;

architecture Behavioral of LFSR is
    signal lfsr : STD_LOGIC_VECTOR(15 downto 0) := "1100101011111001"; -- Valore iniziale del LFSR
    signal feedback : STD_LOGIC;
    signal lfsr_temp : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            feedback <= lfsr(15) xor lfsr(13) xor lfsr(12) xor lfsr(10); -- Funzione di feedback per LFSR
            lfsr <= lfsr(14 downto 0) & feedback;
            
            -- Estrarre gli 11 bit più significativi come numero pseudo-casuale
            lfsr_temp <= lfsr(10 downto 0);

            -- Convertire lfsr_temp a intero per eseguire operazioni aritmetiche
            if to_integer(unsigned(lfsr_temp)) < 300 then
                lfsr_temp <= std_logic_vector(to_unsigned(to_integer(unsigned(lfsr_temp)) + 380, lfsr_temp'length));
            elsif to_integer(unsigned(lfsr_temp)) > 1350 and to_integer(unsigned(lfsr_temp)) <= 1650 then
                lfsr_temp <= std_logic_vector(to_unsigned(to_integer(unsigned(lfsr_temp)) - 380, lfsr_temp'length));
            elsif to_integer(unsigned(lfsr_temp)) > 1650 and to_integer(unsigned(lfsr_temp)) <= 1849 then
                lfsr_temp <= std_logic_vector(to_unsigned(to_integer(unsigned(lfsr_temp)) - 680, lfsr_temp'length));
            elsif to_integer(unsigned(lfsr_temp)) > 1849 then
                lfsr_temp <= std_logic_vector(to_unsigned(to_integer(unsigned(lfsr_temp)) - 999, lfsr_temp'length));
            end if;
        end if;
    end process;
	 
    random_number <= lfsr_temp;

end Behavioral;

