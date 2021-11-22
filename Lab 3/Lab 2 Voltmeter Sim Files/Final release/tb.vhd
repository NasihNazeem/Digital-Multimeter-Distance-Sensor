library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.HexArrays.all;

entity tb is
end tb;

architecture test of tb is

signal clk, reset : STD_LOGIC;
signal LEDR : STD_LOGIC_VECTOR (9 downto 0);
signal Hex  : HexType;
signal Sel : STD_LOGIC;


	-- Clock period definition
constant clk_period : time := 10 ns;

component Voltmeter is
	Port ( clk											: in STD_LOGIC;
			 reset										: in STD_LOGIC;
			 LEDR											: out STD_LOGIC_VECTOR (9 downto 0);
			 Hex                      	  			: out HexType;
			 Sel											: in STD_LOGIC
			);
end component;
			


begin

volt_meter : Voltmeter
port map(
clk => clk,
reset => reset,
LEDR => LEDR,
Hex  => Hex,
Sel  => Sel

);



	-- Clock process definition
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		reset <= '0';
		wait for 1000*clk_period;
		reset <= '1';
		wait for 1000*clk_period;
		reset <= '0';
		wait;
		-- insert stimulus here
		
		wait;
		
		end process;
		

end;