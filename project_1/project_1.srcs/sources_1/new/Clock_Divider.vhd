
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Clock_Divider is
    Generic (
        frec: integer:=50000000         -- frec de 50 MHz
        --Valor por defecto para 1 Hz
    );            
    Port ( 
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_out : OUT STD_LOGIC
    );
end Clock_Divider;

architecture Behavioral of Clock_Divider is
SIGNAL clk_sig: STD_LOGIC;

begin

    process (reset, clk)
    variable count: integer;
    
    begin
    if(reset='1')   then
        count := 0;
        clk_sig<='0';
    elsif rising_edge(clk)  then
        if (count = frec)   then
            count := 0;
            clk_sig<=not (clk_sig);
        else 
            count := count + 1;
        end if;
    end if;
    end process;
    
clk_out <= clk_sig;

end Behavioral;
