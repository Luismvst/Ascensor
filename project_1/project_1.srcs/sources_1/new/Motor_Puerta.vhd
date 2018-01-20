
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Motor_Puerta is
	PORT (
		clk, reset : in std_logic;
		accion_motor_puerta: in std_logic_vector (1 downto 0);
		sensor_presencia : in std_logic;
		motor_puerta: out std_logic_vector (1 downto 0)
		);
end Control_Motor_Puerta;

architecture Behavioral of Control_Motor_Puerta is

begin
	motor_puerta : process (clk, reset)
	begin
		if reset = '1' then
			motor_puerta = '0';
		elsif rising_edge (clk) then
			if accion_motor_puerta ='1' then
				motor_puerta <= '1';
			else 
				motor_puerta <= '0';
			end if;
		end if;
	end process;
end Behavioral;