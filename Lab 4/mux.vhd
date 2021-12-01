library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
	port( clk 			: in std_logic;
			mux_voltage : in std_logic_vector(12 downto 0);
			mux_distance : in std_logic_vector(12 downto 0);
			Selecter	 : in std_logic;
			Y	 : out std_logic_vector(12 downto 0)
		 );
		 
end mux;

architecture Behavioral of mux is

begin
	process(Selecter, mux_voltage, mux_distance, clk)
	begin
		if(rising_edge(clk)) then
			if (Selecter = '0') then
				Y <= mux_distance;
			else
				Y <= mux_voltage;
			end if;
		end if;
	end process;
	
end Behavioral;