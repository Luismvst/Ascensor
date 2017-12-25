
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder_tb is
end Decoder_tb;

architecture Behavioral of Decoder_tb is
    
    COMPONENT decoder
    PORT(
        code: IN STD_LOGIC_VECTOR (3 downto 0);
        led : IN STD_LOGIC_VECTOR (6 downto 0)
    );
    END COMPONENT;
    
    SIGNAL code : STD_LOGIC_VECTOR (3 downto 0);
    SIGNAL led: STD_LOGIC_VECTOR (6 downto 0);
    
    TYPE vtest is record
        code : STD_LOGIC_VECTOR (3 downto 0);
        led : STD_LOGIC_VECTOR (6 downto 0);
    END RECORD;
    
    TYPE vtest_vector IS ARRAY (natural range <>) OF vtest;
        CONSTANT test : vtest_vector := (
            (code => "0000", led => "0000001"),
            (code => "0001", led => "1001111"),
            (code => "0010", led => "0010010"),
            (code => "0011", led => "0000110"),
            (code => "0100", led => "1001100"),
            (code => "0101", led => "0100100"),
            (code => "0110", led => "0100000"),
            (code => "0111", led => "0001111"),
            (code => "1000", led => "0000000"),
            (code => "1001", led => "0000100"),
            (code => "1010", led => "1111110"),
            (code => "1011", led => "1111110"),
            (code => "1100", led => "1111110"),
            (code => "1101", led => "1111110"),
            (code => "1110", led => "1111110"),
            (code => "1111", led => "1111110"),
            
begin
    uut : decoder PORT MAP (
        code => code,
        led => led
    );
    
    tb : process 
    begin
        for i IN 0 TO test'HIGH loop
            code <= test(i).code;
            wait for 20 ns;
            assert led  = test(i).led
            REPORT "Salida incorrecta."
            SEVERITY FAILURE;
        END loop;
        assert false
        REPORT "Simulacion finalizada. Test superado."
        SEVERITY FAILURE;
        END process;    
        
end Behavioral;
