library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
	port( AVG : in std_logic_vector(11 downto 0);
			RAW : in std_logic_vector(11 downto 0);
			Selecter	 : in std_logic;
			Y	 : out std_logic_vector(11 downto 0)
		 );
		 
end mux;

architecture Behavioral of mux is

begin
	process(Selecter, AVG, RAW)
	begin
		if Selecter = '0' then
			Y <= RAW;
		else
			Y <= AVG;
		end if;
	end process;
	
end Behavioral;