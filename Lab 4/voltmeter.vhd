library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.HexArrays.all;
 
entity Voltmeter is
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX 								  : out HexType;
			  buzzer								  : out STD_LOGIC;
			  Selecter							  : in STD_LOGIC -- Added this
--			  switch_buzzer					  : in  STD_LOGIC
          );
           
end Voltmeter;

architecture Behavioral of Voltmeter is

Signal A :   STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');
Signal Num_Hex : NumHexType := (others => (others => '0'));   
Signal DP_in:   STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data,q_outputs_1,q_outputs_2 : STD_LOGIC_VECTOR (11 downto 0);
Signal mult_output: STD_LOGIC_VECTOR (12 downto 0);
Signal busy: STD_LOGIC;
signal response_valid_out_i1,response_valid_out_i2,response_valid_out_i3 : STD_LOGIC_VECTOR(0 downto 0);
Signal bcd: STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp1 : std_logic_vector(11 downto 0);
Signal v2d_distance_output : std_logic_vector(12 downto 0);
Signal flag : std_logic;
Signal bcd_new : STD_LOGIC_VECTOR(15 downto 0);
Signal bcd_original : STD_LOGIC_VECTOR(15 downto 0);
Signal pulse		: STD_LOGIC;


Signal freq_wa		: STD_LOGIC;
Signal amp_wa	 	: STD_LOGIC;
Signal freq_clk	: STD_LOGIC;
--Mux signals
Signal mux_output: std_logic_vector(12 downto 0);

-- Mux component
Component mux is
	port( clk			: in std_logic;
			mux_voltage : in std_logic_vector(12 downto 0);
			mux_distance : in std_logic_vector(12 downto 0);
			Selecter	 : in std_logic;
			Y	 : out std_logic_vector(12 downto 0)
		 );
end Component;

Component flag_mux is
	port( bcd_orig : in std_logic_vector(15 downto 0);
			flag_select	 : in std_logic;
			bcd_new	 : out std_logic_vector(15 downto 0)
		 );
end Component;

Component voltage2distance is
	PORT(
      clk            :  IN    STD_LOGIC;                                
      reset          :  IN    STD_LOGIC;                                
      voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
      distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0);
		err_flag			:  OUT	STD_LOGIC
		);
end Component;

Component SevenSegment is
    Port( Num_Hex																 : in  NumHexType;
          Hex  								                         : out HexType;
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component ADC_Conversion is
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component downcounter IS
	PORT (
			clk		: IN STD_LOGIC;
			reset		: IN STD_LOGIC;
			enable	: IN STD_LOGIC;
			f_c		: IN natural;
			zero		: OUT	STD_LOGIC
			);
end Component;
			
Component amp_buzzer is
   Port    ( 
				 clk							: in std_logic;
				 clk_1kHz_pulse			: in std_logic;
				 reset						: in std_logic;
             amp_buzz					: in STD_LOGIC_VECTOR(12 downto 0);
				 amp_wave					: out std_logic
           );
end Component;

Component freq_buzz_gen is
   Port    ( 
				 clk							: in std_logic;
				 reset						: in std_logic;
				 freq_clk					: in std_logic;
				 freq_buzz					: out std_logic
           );
end Component;

Component clk_divider_buzz is
    PORT ( clk    		: in  STD_LOGIC; -- clock to be divided
           reset  		: in  STD_LOGIC; -- active-high reset
           enable 		: in  STD_LOGIC; -- active-high enable
			  dis_freq		: in  STD_LOGIC_VECTOR(12 downto 0);
           clock_out   	: out STD_LOGIC -- creates a positive pulse every time current_count hits zero
                                   -- useful to enable another device, like to slow down a counter
     --      value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0) -- outputs the current_count value, if needed
         );
end Component;

Component MUX_BUZZER IS
	PORT (
	in1     		:   in std_logic;
	in2  		   :   in std_logic;
	s    			:   in std_logic;
	mux_out     :   out std_logic
	);
end Component;

Component registers is
   generic(bits : integer);
   port
     ( 
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(bits-1 downto 0);
      q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;

Component averager is
  port(
    clk, reset : in std_logic;
    Din : in  std_logic_vector(11 downto 0);
    EN  : in  std_logic; -- response_valid_out
    Q   : out std_logic_vector(11 downto 0)
    );
  end Component;

begin
   Num_Hex(0) <= bcd_new(3  downto  0); 
   Num_Hex(1) <= bcd_new(7  downto  4);
   Num_Hex(2) <= bcd_new(11 downto  8);
	Num_Hex(3) <= bcd_new(15 downto 12) when (bcd_new(15 downto 12) /= "0000") else
					  "1111";
   Num_Hex(4) <= "1111";  -- blank this display
   Num_Hex(5) <= "1111";  -- blank this display   
	DP_in <= "001000" when (Selecter = '1') else 
				"000100";
				
	
				
				
-- Mux instantiation
multiplexer: mux
				 port map(
							 clk => clk,
							 mux_voltage => mult_output,
							 mux_distance => v2d_distance_output,
							 Selecter   => Selecter,
							 Y	  => mux_output
							);

flag_multiplexer : flag_mux
				port map(
							bcd_orig => bcd_original,
							flag_select => flag,
							bcd_new => bcd_new
							
							
							);
							
V2D : voltage2distance
				port map(
							clk => clk,
							reset => reset,
							voltage => mult_output,
							distance => v2d_distance_output,
							err_flag => flag
							);							
							
ave :    averager
         port map(
                  clk       => clk,
                  reset     => reset,
                  Din       => q_outputs_2,
                  EN        => response_valid_out_i3(0),
                  Q         => Q_temp1
                  );
   
sync1 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => ADC_read,
                 q_outputs => q_outputs_1
                );

sync2 : registers 
        generic map(bits => 12)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => q_outputs_1,
                 q_outputs => q_outputs_2
                );
                
sync3 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i1,
                 q_outputs => response_valid_out_i2
                );

sync4 : registers
        generic map(bits => 1)
        port map(
                 clk       => clk,
                 reset     => reset,
                 enable    => '1',
                 d_inputs  => response_valid_out_i2,
                 q_outputs => response_valid_out_i3
                );                
                
SevenSegment_ins: SevenSegment  
                  PORT MAP( Num_Hex => Num_Hex,
                            Hex 		=> Hex,
                            DP_in   => DP_in
                          );
                                     
ADC_Conversion_ins:  ADC_Conversion  PORT MAP(      
                                     MAX10_CLK1_50       => clk,
                                     response_valid_out  => response_valid_out_i1(0),
                                     ADC_out             => ADC_read);
 
LEDR(9 downto 0) <=Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter

-- Added mux_output, before it was Q_temp1
mult_output <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,mult_output'length)); -- Converting ADC_read a 12 bit binary to voltage readable numbers

binary_bcd_ins: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset    => reset,                                 
      ena      => '1',                           
      binary   => mux_output,    
      busy     => busy,                         
      bcd      => bcd_original         
      );
		
--down: downcounter      
--		port map (  clk		=>		clk,
--						reset		=>		reset,
--						enable	=>		'1',
--						zero		=>		pulse,
--						f_c		=>		5000
--         );

--buzzer_amplitude: amp_buzzer
--   port map  ( 
--				 clk							=>		clk,
--				 clk_1kHz_pulse			=>		pulse,
--				 reset						=>		reset,
--             amp_buzz					=>		v2d_distance_output,
--				 amp_wave					=>		amp_wa
--           );
--			  
buzzer_frequency: freq_buzz_gen
      port map (
		clk 					=>		clk,
		reset 				=> 	reset,
		freq_clk				=> 	freq_clk,
		freq_buzz			=> 	buzzer
		);		
		
		
--buzzer_multiplexer: MUX_BUZZER
--      port map (
--		in1 		=>		freq_wa,
--		in2 		=> 	amp_wa,
--		s 			=> 	switch_buzzer,
--		mux_out  => 	buzzer
--		);		
		
clk_div: clk_divider_buzz
      port map (
		clk 			=>		clk,
		reset 		=> 	reset,
		enable 		=> 	'1',
		dis_freq  	=> 	v2d_distance_output,
		clock_out 	=>		freq_clk
		);	
		

end Behavioral;
