Motor_Puerta.vhd


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Motor_Puerta is
	PORT (
		clk, reset : in std_logic;
		accion_motor_puerta: in std_logic_vector (1 downto 0);
		motor_puerta_abrir: out std_logic;
		motor_puerta_cerrar: out std_logic
		);
end Motor_Puerta;

architecture Behavioral of Motor_Puerta is

begin
	motor_puerta : process (clk, reset)
	begin
		if reset = '1' then
			motor_puerta_abrir = '0';
			motor_puerta_cerrar ='0';
		elsif rising_edge (clk) then
			if accion_motor_puerta ="10" then
				motor_puerta_abrir <= '1';
			elsif accion_motor_puerta = "01" then
				motor_puerta_cerrar <= '1';
			else 
				motor_puerta_cerrar <= '0';
				motor_puerta_abrir <= '0';
			end if;
		end if;
	end process;
end Behavioral;