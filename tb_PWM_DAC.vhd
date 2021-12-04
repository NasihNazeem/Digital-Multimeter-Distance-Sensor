LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

ENTITY tb_PWM_DAC IS
END tb_PWM_DAC;

Architecture tb of tb_PWM_DAC is

component PWM_DAC
    Generic ( width : integer := 9);
	 Port    ( reset      : in STD_LOGIC;
             clk        : in STD_LOGIC;
             frequency  : in natural;
             pwm_out    : out STD_LOGIC
           );
end component;

   signal clk, reset, pwm_out : std_logic;
   signal frequency_input				: natural;
   constant clk_period : time := 10 ns;
	signal duty_cycle : natural;
  
begin
-- Unit Under Test
uut : PWM_DAC
         generic map (width => 9)
         port map(
                   reset      => reset,
                   clk        => clk,
                   frequency => frequency_input,
                   pwm_out    => pwm_out
                  );
			
   clk_process : process
   begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
   end process;
 
   reset_proc : process
   begin      
      reset <= '1';
      wait for 2*clk_period;   
      reset <= '0';
      wait;		
   end process;
		
   freq_proc: process
   begin      
      
      frequency_input <= 5000;
		duty_cycle <= 2500;
       wait for 1000*clk_period;   
      frequency_input <= 3000;
		duty_cycle <= 1500;
       wait for 1000*clk_period; 	
      frequency_input <= 5000;
		duty_cycle <= 2500;
      wait for 1000*clk_period; 	
      frequency_input <= 4000;
		duty_cycle <= 2000;
      wait for 1000*clk_period; 	  
   end process;
					
end;	