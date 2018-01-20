Motor_Ascensor.vhd


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Motor_Ascensor is
    PORT (
        clk, reset : in std_logic;
        accion_motor : in std_logic_vector (1 downto 0);
        motor_subir : out std_logic;
        motor_bajar : out std_logic
        );
end Motor_Ascensor;

architecture Behavioral of Motor_Ascensor is

begin
    motor: process (clk, reset)
    begin
        if reset = '1' then
            motor_subir <= '0';
            motor_bajar <= '0';
        elsif rising_edge (clk ) then 
            if (accion_motor = "10" ) then  --Subir
            	motor_subir <= '1';
            	motor_bajar <= '0';
        	elsif (accion_motor = "01") then
        		motor_subir <= '0';
        		motor_bajar <= '1';
    		else
    			motor_subir <= '0';
    			motor_bajar <= '0';
		    end if;
        end if;
	end process; 
	
end Behavioral;