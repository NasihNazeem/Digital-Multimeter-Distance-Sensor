-- Library declarations
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.HexArrays.all;

-- Entity declaration, no ports for a tb
entity Voltmeter_tb is
end Voltmeter_tb;

-- Architecture
architecture tb of Voltmeter_tb is

-- Signal declarations, type should match those in the main vhd file
signal clk, reset : STD_LOGIC;
signal LEDR : STD_LOGIC_VECTOR (9 downto 0);
signal HEX  : HexType;

-- For mux
signal S_i 	 : std_logic;

-- Clock period
constant clk_period : time := 10 ns;
constant reset_period : time := 30 ns;

-- Component declarations, the ports should be the same as the entity ports in the main vhd file
component Voltmeter is
	port( clk 									: in STD_LOGIC;
			reset                         : in  STD_LOGIC;
         LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
         HEX								   : out HexType;
			Selecter								: in STD_LOGIC-- No semicolon for last one
		 );
end component;

begin

-- Instaniate as UUT. We map the local signals to the ones in the enitity ports
	UUT: Voltmeter port map (
	clk => clk,
	reset => reset,
	LEDR => LEDR,
	HEX  => HEX,
	Selecter	  => S_i --No comma for last one
	);

-- Stimuli/Processes

	clk_proccess: process
		begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end process;
		
	reset_process: process
		begin
			reset <= '0';
			wait for clk_period*5;
			reset <= '1';
			wait for clk_period*5;
			reset <= '0';
			wait;
		end process;
		
	 mux_process : process
		begin
	
			--AVG_i (11 downto 0) <= "111111111111";
			--RAW_i (11 downto 0) <= "000000000000";
			
			S_i <= '0';
			wait for 100 ns;
			S_i <= '1';
			wait for 100 ns;
			
			--RAW_i (11 downto 0) <= "100000000000";
			--wait for 100 ns;
			--AVG_i (11 downto 0) <= "011111111111";
			--wait for 100 ns;
			
			S_i <= '0';
			wait for 100 ns;
			S_i <= '1';
			wait for 100 ns;
			
		end process;
		
end tb;

