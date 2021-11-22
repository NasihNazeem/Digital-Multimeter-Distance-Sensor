library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux is
end tb_mux;

architecture behavior of tb_mux is


	Component mux is
		port (	AVG : in STD_LOGIC_VECTOR(11 downto 0);
					RAW : in STD_LOGIC_VECTOR(11 downto 0);
					S : in STD_LOGIC;
					Y : out STD_LOGIC_VECTOR(11 downto 0)
				);
	end component;
				
	signal AVG_i : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal RAW_i : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	signal S_i : STD_LOGIC;
	signal Y_i : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	

begin

uut : mux port map (
								AVG => AVG_i,
								RAW => RAW_i,
								S 	 => S_i,
								Y 	 => Y_i
								);
								
		stim_proc : process
		begin
		
		AVG_i(11 downto 0) <= "111111111111";
		RAW_i(11 downto 0) <= "000000000000";
		
		S_i <= '0';
		wait for 100 ns;
		S_i <= '1';
		wait for 100 ns;
		S_i <= '0';
		wait for 100 ns;
		
		wait;
		
		end process;
		
end behavior;
					



