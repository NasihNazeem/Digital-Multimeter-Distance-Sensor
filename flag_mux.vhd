library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flag_mux is
	port( bcd_orig : in std_logic_vector(15 downto 0);
			flag_select	 : in std_logic;
			bcd_new	 : out std_logic_vector(15 downto 0)
		 );
		 
end entity;

architecture Behavioral of flag_mux is

begin
	process(flag_select, bcd_orig)
	begin
		if flag_select = '0' then
			bcd_new <= bcd_orig;
		else
			bcd_new <= "1110111011101110";
		end if;
	end process;
	
end Behavioral;