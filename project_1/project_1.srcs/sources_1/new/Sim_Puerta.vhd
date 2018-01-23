
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Sim_Puerta is
port (
	sentido : in std_logic_vector (1 downto 0);
	estado_sim : out std_logic_vector (1 downto 0);		--Estados de la puerta segun display. "11" Abierto total.
	clk : in std_logic;
	reset : in std_logic;
	f_carrera : out std_logic_vector (1 downto 0)		--Sensores que indican apertura o cierre completos.
	);
end;

architecture Behavioral of Sim_Puerta is

signal estado : std_logic_vector (1 downto 0):="01";
signal f_carr : std_logic_vector (1 downto 0) := "00";


begin
	Sim_puerta : process (clk, reset)
	begin
		if reset = '1' then
			estado <= "11";
			f_carr <= "10";
		elsif rising_edge (clk) then
			if sentido = "00" then 
			     estado <= estado;
			elsif sentido = "01" and estado /= "00" then
				estado <= estado - 1;
			elsif sentido <= "10" and estado /= "11" then
				estado <= estado + 1;
			end if;
            if estado = "11" then
                f_carr <= "10";
            elsif estado = "00" then
                f_carr <= "01";
            else 
                f_carr <= "00";
			end if;
		end if;
	end process;
	
	f_carrera <= f_carr;
	estado_sim <= estado;

end;
