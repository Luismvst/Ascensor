
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sim_Piso is
port (
	sentido : in std_logic_vector (1 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	piso : out std_logic_vector (6 downto 0)
	);
end;

architecture Behavioral of Sim_Piso is

signal piso_actual : std_logic_vector (3 downto 0):="011";

begin
	Sim_Piso : process (clk, reset)
	begin
		if reset = '1' then
			piso_actual <= "011";
		elsif rising_edge (clk) then
			if sentido = "10" then
				piso_actual <= piso_actual +1;
			elsif sentido = "01" then
				piso_actual <= piso_actual -1 ;
			end if;
		end if;
	end process;

	Sim_Process : process 
	begin
		case (piso_actual) is
			when "001" => 
				piso <= "0000001";
			when "010" => 
				piso <= "0000010";
			when "011" => 
				piso <= "0000100",
			when "100" => 
				piso <= "0001000";
			when "101" => 
				piso <= "0010000";
			when "110" => 
				piso <= "0100000";
			when "111" => 
				piso <= "1000000";	
		end case;
	end process;
end;			

