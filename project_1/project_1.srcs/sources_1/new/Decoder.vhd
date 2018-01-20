
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Display7seg is
    Port ( 
        reset : in std_logic;
        clk : in std_logic;
        destino : IN STD_LOGIC_VECTOR (2 downto 0);    
        actual : in std_logic_vector (2 downto 0);
        led : OUT STD_LOGIC_VECTOR (6 downto 0);
        control : out std_logic_vector (7 downto 0);          
        modo_motor: in std_logic_vector (1 downto 0);   --El modo_motor es si subimos, bajamos o nos paramos   
        modo_puerta : in std_logic_vector (1 downto 0)
        --puntiquitillitos puntitos
        
    );
end Display7seg;

architecture Behavioral of Display7seg is

signal num_led : std_logic_vector (6 downto 0);
signal letras_led : std_logic_vector (6 downto 0);
shared variable flag : std_logic_vector := '0';    --identifica donde nos encontramos, si escribiendo S, B o P ó 1, 2, 3, 4. 
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
                case (code) is 
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
                case (modo_motor) is
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
       