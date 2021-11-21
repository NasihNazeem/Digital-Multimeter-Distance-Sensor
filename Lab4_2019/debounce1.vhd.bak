--------------------------------------------------------------------------------
--   Version History
--
--   Original code by:
--   Version 1.0 3/26/2012 Scott Larson
--   From: https://eewiki.net/pages/viewpage.action?pageId=4980758#DebounceLogicCircuit(withVHDLexample)-ExampleVHDLCode
--   Accessed October 14, 2017
--   
--   Modified for ENEL 453
--   Version 1.1 10/14/2017 Denis Onen
--   Changes: - added reset signal
--            - modified and added comments
--
--   Usage:
--   This circuit debounces an input from a mechanical switch. The bounce time must be known in advance,
--   or an estimate must be made. The relationship determining the size of the counter is:
--   bouncing_period = (2^N + 2) / clock_frequency, where
--   bouncing_period is how long the switch will bounce in seconds
--   clock_frequency is the system's clock frequency in Hz
--   (2^N + 2) is the how long to count (using an N-bit counter) to go past the bouncing period
--   Alternatively,
--   number_counts = bouncing_period * clock_frequency
--   
--   Example:
--   If the mechanical switch will bounce for 10 ms, and the system's clock frequency is 100 MHz, 
--   then we need to count:
--   (0.01 s) * 100 MHz) = 1,000,000 clock cycles, and a 20-bit counter will satisfy the requirement
--   because 2^20 = 1,048,576 exceeds 1,000,000.
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY debounce IS
  GENERIC(
    counter_size  :  INTEGER := 20); --counter size (20 bits gives 10.5ms with 100MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    reset   : IN  STD_LOGIC;  --reset
    result  : OUT STD_LOGIC   --debounced signal
    );
END debounce;

ARCHITECTURE logic OF debounce IS
  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
  SIGNAL counter_set : STD_LOGIC;                    --sync reset 
  SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output
  
BEGIN

  counter_set <= flipflops(0) xor flipflops(1);   --determine when to start/reset counter
  
  PROCESS(clk,reset)
  BEGIN
    IF(reset = '1') THEN -- asynchronous, active-high reset
      flipflops <= "00";
      result <= '0';
      counter_out <= (OTHERS => '0');
    ELSIF(clk'EVENT and clk = '1') THEN -- this is an alternative to "rising_edge(clk)"
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      If(counter_set = '1') THEN                  --reset counter because input is changing
        counter_out <= (OTHERS => '0');
      ELSIF(counter_out(counter_size) = '0') THEN --stable input time is not yet met
        counter_out <= counter_out + 1;
      ELSE                                        --stable input time is met
        result <= flipflops(1);
      END IF;    
    END IF;
  END PROCESS;
END logic;
