-- Library declarations
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration, no ports for a tb
entity mux_tb is
end mux_tb;

-- Architecture
architecture tb of mux_tb is

-- Signal declarations, type should match those in the main vhd file
signal AVG_i : std_logic_vector(11 downto 0);
signal RAW_i : std_logic_vector(11 downto 0);
signal S_i 	 : std_logic;
signal Y_i	 : std_logic_vector(11 downto 0);

-- Component declarations, the ports should be the same as the entity ports in the main vhd file
component mux is 
	port( AVG : in std_logic_vector(11 downto 0);
			RAW : in std_logic_vector(11 downto 0);
			Selecter	 : in std_logic;
			Y	 : out std_logic_vector(11 downto 0)
		 );
end component;

begin

-- Instantiate as UUT. We map the local signals to the ones in the enitity ports
	UUT: mux port map (
	AVG => AVG_i,
	RAW => RAW_i,
	Selecter => S_i,
	Y => Y_i
	);
	
-- Stimili

	stim_proc: process
		begin
		
			AVG_i (11 downto 0) <= "111111111111";
			RAW_i (11 downto 0) <= "000000000000";
			
			S_i <= '0';
			wait for 100 ns;
			S_i <= '1';
			wait for 100 ns;
			
--			RAW_i (11 downto 0) <= "100000000000";
--			wait for 100 ns;
--			AVG_i (11 downto 0) <= "011111111111";
--			wait for 100 ns;
--			
--			S_i <= '0';
--			wait for 100 ns;
--			S_i <= '1';
--			wait for 100 ns;
			
		end process;
	
end tb;