
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sim_Puerta is
port (
	sentido : in std_logic_vector (1 downto 0);
	estado_sim : out std_logic_vector (1 downto 0);		--Estados de la puerta segun display. "00" Abierto total.
	clk : in std_logic;
	f.carrera : in std_logic_vector (1 downto 0)		--Sensores que indican apertura o cierre completos.
	);
end;

architecture Behavioral of Sim_Puerta is

begin

end;
