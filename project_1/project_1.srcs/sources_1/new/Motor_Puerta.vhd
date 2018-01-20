
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Motor_Puerta is
	PORT (
		clk: in std_logic;
		accion_motor_puerta: in std_logic_vector (1 downto 0);
		motor_puerta: out std_logic_vector (1 downto 0)
		);
end Control_Motor_Puerta;

architecture Behavioral of Control_Motor_Puerta is

begin
	motor_puerta : process (clk)
	begin
		if rising_edge (clk) then
			if accion_motor_puerta ="10" then	--Abrir
				motor_puerta <= "10";
			elsif accion_motor_puerta = "01" then
				motor_puerta <= "01";
			else motor_puerta <= "00";
			end if;
		end if;
	end process;
end Behavioral;