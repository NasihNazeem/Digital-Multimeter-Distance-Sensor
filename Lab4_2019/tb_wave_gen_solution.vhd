library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_wave_gen is
end tb_wave_gen;

architecture Behavioral of tb_wave_gen is

    component wave_gen is
        Port (	
--					SW_SEL1 : in STD_LOGIC;
--					SW_SEL2 : in STD_LOGIC;
--					SW_F1 : in STD_LOGIC;
--					SW_F2 : in STD_LOGIC;
--					SW_F3 : in STD_LOGIC;
--					SW_F4 : in STD_LOGIC;
--					SW_A1 : in STD_LOGIC;
--					SW_A2 : in STD_LOGIC;
--					SW_A3 : in STD_LOGIC;
--					SW_A4 : in STD_LOGIC;
					
				 clk							: in std_logic;
				 clk_1kHz_pulse			: in std_logic;
				 buttontop					: in std_logic;
				 buttonbottom				: in std_logic;
				 freqoramp					: in std_logic;
				 reset						: in std_logic;
             wave_switch				: in STD_LOGIC_VECTOR(1 downto 0);
				 PWM_OUT						: out std_logic
              );
        end component;
        
    --signal reset,clk,PWM_OUT,SW_SEL1,SW_SEL2,SW_F1,SW_F2,SW_F3,SW_F4,SW_A1,SW_A2,SW_A3,SW_A4  : std_logic;
	 
	 signal reset,clk,PWM_OUT,clk_1kHz_pulse,buttontop,buttonbottom,freqoramp : std_logic;
    signal wave_switch  : std_logic_vector(1 downto 0);

              
    constant clk_period : time := 100 ns; -- 1/(100 ns) = 10 MHz

begin

    uut : wave_gen port map (
        reset => reset,
        clk => clk,
        PWM_OUT => PWM_OUT,
		  clk_1kHz_pulse	=>	clk_1kHz_pulse,
		  buttontop			=>	buttontop,
	  	  buttonbottom		=>	buttonbottom,
		  freqoramp			=>	freqoramp,
        wave_switch		=>	wave_switch
		  
--	SW_A1 => SW_A1,
--	SW_A2 => SW_A2,
--	SW_A3 => SW_A3,
--	SW_A4 => SW_A4,
--	SW_F1 => SW_F1,
--	SW_F2 => SW_F2,
--	SW_F3 => SW_F3,
--	SW_F4 => SW_F4,
--	SW_SEL1 => SW_SEL1,
--	SW_SEL2 => SW_SEL2
        );

   -- Clock process
   ClkProcess : process
   begin
		clk <= '0';
		clk_1kHz_pulse <= '1';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process; 

   SW_SEL1Process : process
	begin
		wave_switch(0) <= '0';
		wave_switch(1) <= '0';
		wait for clk_period*100000;
		wave_switch(0) <= '0';
		wave_switch(1) <= '1';
		wait for clk_period*100000;
	end process;

   SW_SEL2Process : process
	begin
		wave_switch(0) <= '1';
		wave_switch(1) <= '0';
		wait for clk_period*200000;
		wave_switch(0) <= '1';
		wave_switch(1) <= '1';
		wait for clk_period*200000;
	end process;

   resetProcess : process
	begin
		reset <= '1';
		wait for clk_period*100;
		reset <= '0';
		wait;
	end process;
    
end Behavioral;
