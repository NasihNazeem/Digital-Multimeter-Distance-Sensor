-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Making a new type in the package
package HexArrays is
	type HexType is array (0 to 5) of STD_LOGIC_VECTOR(7 downto 0); -- Create Hex Array
	type NumHexType is array (0 to 5) of STD_LOGIC_VECTOR (3 downto 0); -- Create Num_Hex Array
end package HexArrays;

-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.HexArrays.all;

entity SevenSegment is
    Port ( DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0);
           Num_Hex 															  : in  NumHexType;
           HEX                      									  : out HexType 
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
										( 	H => Hex(I), 
											input => Num_Hex(I), 
											DP => DP_in(I)
										);
		end generate Behavioral_Decoder;

		
end Behavioral;

---- --- Seven segment component
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--

--
----Have to use libraries again
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
----use work.HexArrays.all;
--
--entity SevenSegment is
--    Port ( DP_in   : in  STD_LOGIC_VECTOR (5 downto 0);
--           Num_Hex : in  NumHexType;
--           Hex     : out HexType
--          );
--end SevenSegment;
--architecture Behavioral of SevenSegment is
--
----Note that component declaration comes after architecture and before begin (common source of error).
--   Component SevenSegment_decoder is 
--      port(  H     : out STD_LOGIC_VECTOR (7 downto 0);
--             input : in  STD_LOGIC_VECTOR (3 downto 0);
--             DP    : in  STD_LOGIC                               
--          );                  
--   end  Component;   
--begin
--
----Note that port mapping begins after begin (common source of error).
--
--Behavioral_Decoder:
--		for I in 0 to 5 generate
--			DECODERx : SevenSegment_decoder port map
--			( H => Hex(I), input => Num_Hex(I), DP => DP_in(I));
--		end generate Behavioral_Decoder;      
--		
--end Behavioral;