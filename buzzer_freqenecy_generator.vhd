library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity buzz_freq_modifier is
		 port( 
				 clk			 		: in std_logic;
				 reset		 		: in std_logic;
				 pwm_enable		 		: in std_logic;
				 output_wave : out std_logic -- the pwm output
           );
end buzz_freq_modifier;

architecture Behavioral of buzz_freq_modifier is

constant width 					: integer := 4;
-- signal pwm_out 									: std_logic;
type Statetype is (S0,S1,S2);
signal CurrentState, NextState 				: Statetype;
signal output_wave_temp, count_direction  :	std_logic;
signal duty_cycle, duty_counter 					: std_logic_vector(width-1 downto 0);
signal max_count 									:	std_logic_vector(width-1 downto 0) := (others => '1'); -- 1111
signal zero_count 								: std_logic_vector(width-1 downto 0) := (others => '0'); -- 0000

component PWM_DAC is
   Generic ( width : integer := 9);
   Port    ( reset      : in STD_LOGIC;
             clk        : in STD_LOGIC;
             duty_cycle : in STD_LOGIC_VECTOR (width-1 downto 0);
             pwm_out    : out STD_LOGIC
           );
end component;

begin

	pwm: PWM_DAC
	generic map(width => 4)
	port map(
				reset => reset,
				clk => clk,
				duty_cycle => duty_cycle,
				pwm_out => output_wave_temp
			  );
	
	count : process(clk, reset, pwm_enable, count_direction)
		begin
			if (reset = '1') then
				duty_counter  <= zero_count;
				
			elsif	(rising_edge(clk)) then
				if (pwm_enable = '1') then -- only increment the count every time the enable pulses high
				
					if (count_direction = '1') then
						duty_counter  <= duty_counter  + '1';
						
					elsif (count_direction = '0') then
						duty_counter  <= duty_counter  - '1';
					
					end if;
				end if;
			end if;
		end process;
	
	-- setting the states
	seq_proc: process(clk, reset)
		begin
			if (reset = '1') then
				CurrentState 	<= S0;
			elsif rising_edge(clk) then
				CurrentState 	<= NextState;
			end if;
		end process;
	
	comb_proc: process(CurrentState, duty_counter)
		begin
			case CurrentState is
				when S0 => -- the initial state
					NextState 			<= S1;
					duty_cycle 			<= zero_count;
					count_direction 	<= '1';
				when S1 => -- when we're counting up
					duty_cycle 			<= max_count;
					count_direction 	<= '1';
					if (duty_counter = max_count) then -- if we reach 1111 move to the counting down state
						NextState 		<= S2;
					else
						NextState 		<= S1;
					end if;
				when S2 => -- when we're counting down
					duty_cycle 			<= zero_count;
					count_direction 	<= '0';
					if (duty_counter = zero_count) then -- if we reach 0000 move to the counting up state
						NextState 		<= S1;
					else
						NextState 		<= S2;
					end if;
				when others => -- set it to the initial state otherwise
					NextState 			<= S0;
					duty_cycle 			<= zero_count;
					count_direction 	<= '1';
			end case;
		end process;
		
		output_wave <= output_wave_temp;
		
end Behavioral;