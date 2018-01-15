----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2017 20:00:47
-- Design Name: 
-- Module Name: Decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( 
        reset : in std_logic;
        clk : in std_logic;
        code : IN STD_LOGIC_VECTOR (3 downto 0);    --Codifica nuestro piso actual
        led : OUT STD_LOGIC_VECTOR (6 downto 0);          
        modo : in std_logic_vector (1 downto 0)   --El modo es si subimos, bajamos o nos paramos   
        
    );
end Decoder;

architecture Behavioral of Decoder is

signal num_led : std_logic_vector (6 downto 0);
signal letras_led : std_logic_vector (6 downto 0);
shared variable flag : std_logic := '0';    --identifica donde nos encontramos, si escribiendo S, B o P ó 1, 2, 3, 4. 
--Valor inicial de 0. Si flag = 0, identificamos motores (movimiento). Si está a 1, identificamos valores de piso

begin 

    display: process (reset, clk)
    begin
        if reset = '1' then
            num_led <= "0000000";   --Se encenderá todo, para darle un toque retro al reset
            letras_led <= "0000000";
            flag := '0';
            led <= "0000000";
            --dig-ctrl <= "0000";
        elsif rising_edge (clk) then --Le pondremos una frecuencia de reloj acorde
            if flag = '0' then
                case (code) is --leemos la entrada para saber qué nos están mandando dibujar en el display
                    when "0000" =>
                        num_led <= "0000001";   --numero 0
                    when "0001" => 
                        num_led <= "1001111";   --numero 1
                    when "0010" =>
                        num_led <= "0010010";   --numero 2
                    when "0011" =>
                        num_led <= "0000110";   --numero 3
                    when others => 
                        num_led <= "1001001";   --dos barras verticales como un pausa ||
                end case;
                
                flag := '1';
                --dig-ctrl <= "1110" ;  --No se exactamente qué significa esto
                led <= num_led;
                
            elsif flag = '1' then 
                case (modo) is
                    when "10" =>    --Ascensor Sube
                        letras_led <= "0011100";    --Dibujo de subir. Cuadrado superior
                    when "01" =>    --Ascensor Baja
                        letras_led <= "1100010";    --Dibujo de bajar. Cuadrado inferior
                    when "00" =>    --Ascensor Parado
                        letras_led <= "1111110";    --Dibujo de parado. Linea intermedia
                    when others => 
                        letras_led <= "1001000";    --Dibujo de una H. Significa que algo malo ocurre.
                end case;
                
                flag := '0';
                --dig-ctrl <= "0111" ;  --No se exactamente qué significa esto
                led <= letras_led;
            end if;
        end if;
    end process;
    
    end architecture Behavioral;
       