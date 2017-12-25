
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( 
        code : IN STD_LOGIC_VECTOR (3 downto 0);
        led : OUT STD_LOGIC_VECTOR (6 downto 0)
    );
end Decoder;

architecture dataflow of Decoder is

begin
    WITH code SELECT 
        led <=  "0000001"   when "0000",
                "1001111"   when "0001",
                "0000110"   when "0010",
                "1001100"   when "0100",
                "0100100"   when "0101",
                "0100000"   when "0110",
                "0001111"   when "0111",
                "0000000"   when "1000",
                "0000100"   when "1001",
                "1111110"   when others;
end dataflow;
