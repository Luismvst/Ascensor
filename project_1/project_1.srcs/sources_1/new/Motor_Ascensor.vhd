

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Control_Motor_Ascensor is
    PORT (
        clk, reset : in std_logic;
        accion_motor : in std_logic_vector (1 downto 0);
        motor : out std_logic_vector (1 downto 0)
        );
end Control_Motor_Ascensor;

architecture Behavioral of Control_Motor_Ascensor is

begin
    proceso_motor: process (clk, reset)
    begin
        if reset = '1' then
            motor <= "00";
        elsif rising_edge (clk ) then 
            if (accion_motor = "10" ) then  --Subir
            	motor <= "10";
        	elsif (accion_motor = "01") then
        		motor <= "01";
    		else
    			motor <= "00";
		    end if;
        end if;
	end process; 
	
end Behavioral;
