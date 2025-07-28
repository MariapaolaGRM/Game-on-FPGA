library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity Joystick is
	port(clk, reset: in std_logic; --clk a 10 MHz
			move : out std_logic_vector(1 downto 0) -- val analog convertito
			);
end Joystick;

architecture behave of Joystick is
component unnamed is -- logica componenti ADC
	port (
		CLOCK : in  std_logic                     := '0'; --      clk.clk
		CH0   : out std_logic_vector(11 downto 0);        -- readings.CH0
		CH1   : out std_logic_vector(11 downto 0);        --         .CH1
		CH2   : out std_logic_vector(11 downto 0);        --         .CH2
		CH3   : out std_logic_vector(11 downto 0);        --         .CH3
		CH4   : out std_logic_vector(11 downto 0);        --         .CH4
		CH5   : out std_logic_vector(11 downto 0);        --         .CH5
		CH6   : out std_logic_vector(11 downto 0);        --         .CH6
		CH7   : out std_logic_vector(11 downto 0);        --         .CH7
		RESET : in  std_logic                     := '0'  --    reset.reset
	);
end component unnamed;

signal ch0: std_logic_vector(11 downto 0);
signal ch1: std_logic_vector(11 downto 0);
signal ch2: std_logic_vector(11 downto 0);
signal ch3: std_logic_vector(11 downto 0);
signal ch4: std_logic_vector(11 downto 0);
signal ch5: std_logic_vector(11 downto 0);
signal ch6: std_logic_vector(11 downto 0);
signal ch7: std_logic_vector(11 downto 0);

begin
	unnamed_map: unnamed PORT MAP(clk,ch0,ch1,ch2,ch3,ch4,ch5,ch6,ch7,reset);
	
	process(clk)
	begin
		if rising_edge(clk) then 
			if(ch0<"010000000000" AND ch0>"000000000000") then --ch0 < 1024 AND ch0 > 0
					move<="01"; -- destra
			elsif(ch0<"111111111111" AND ch0>"110000000000") then --ch0 < 4095 AND ch0 > 3072
				   move<="00"; -- sinistra 
			else
					move<="10"; -- fermo
			end if;
		end if;	
	end process;
end architecture behave;
