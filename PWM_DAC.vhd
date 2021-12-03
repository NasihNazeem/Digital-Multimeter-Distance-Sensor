library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM_DAC is
   Generic ( width : integer := 9);
   Port    ( reset      : in STD_LOGIC;
             clk        : in STD_LOGIC;
             frequency  : in natural;
             pwm_out    : out STD_LOGIC
           );
end PWM_DAC;

architecture Behavioral of PWM_DAC is
   signal pwm_counter : natural;
	signal duty_cycle : natural;
       
begin
	duty_cycle <= frequency/2;
	
   count : process(clk,reset)
   begin
       if( reset = '1') then
           pwm_counter <= duty_cycle;
       elsif (rising_edge(clk)) then 
			 if (pwm_counter < frequency) then
				  pwm_counter <= pwm_counter + 1;
			 else
				  pwm_counter <= 0;
			end if;
       end if;
   end process;
 
   compare : process(pwm_counter, duty_cycle)
   begin    
       if (pwm_counter < duty_cycle) then
           pwm_out <= '1';
       else 
           pwm_out <= '0';
       end if;
   end process;
  
end Behavioral;

