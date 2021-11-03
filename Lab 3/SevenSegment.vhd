-- --- Seven segment component

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package HexArrays is
	type HexType is array (0 to 5) of STD_LOGIC_VECTOR(7 downto 0); -- Create Hex Array
	type NumHexType is array (0 to 5) of STD_LOGIC_VECTOR (3 downto 0); -- Create Num_Hex Array
end package HexArrays;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.HexArrays.all;


entity SevenSegment is
    Port ( DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0);
           --Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
           --HEX0,HEX1,HEX2,HEX3,HEX4,HEX5                         : out STD_LOGIC_VECTOR (7 downto 0)
			  Num_Hex 														  	  : in  NumHexType;
			  Hex                      									  : out HexType
          );
end SevenSegment;
architecture Behavioral of SevenSegment is


--Note that component declaration comes after architecture and before begin (common source of error).
   Component SevenSegment_decoder is 
      port(  H     : out STD_LOGIC_VECTOR (7 downto 0);
             input : in  STD_LOGIC_VECTOR (3 downto 0);
             DP    : in  STD_LOGIC                               
          );                  
   end  Component;   
begin

--Note that port mapping begins after begin (common source of error).
	Behavioral_Decoder:
		for I in 0 to 5 generate
			DECODERx : SevenSegment_decoder port map
			( H => Hex(I), input => Num_Hex(I), DP => DP_in(I));
		end generate Behavioral_Decoder;
end Behavioral;