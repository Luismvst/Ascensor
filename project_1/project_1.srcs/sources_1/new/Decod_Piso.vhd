
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decod_Piso is
Port (
	entrada: in std_logic_vector (6 downto 0);
	salida : out std_logic_vector (2 downto 0);
	clk : in std_logic
	 );
end Decod_Piso;

architecture Behavioral of Decod_Piso is

begin
    Decoder_piso : process (clk)
    begin 
        if rising_edge (clk) then
            case entrada is
                when "0000001" => salida <= "001"; 
                when "0000010" => salida <= "010"; 
                when "0000100" => salida <= "011"; 
                when "0001000" => salida <= "100";
                when "0010000" => salida <= "101";
                when "0100000" => salida <= "110";   
                when "1000000" => salida <= "111";
                when others =>  salida <= "000";
                    
                    
            end case;
        end if;
    end process;
	


end Behavioral;
