
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Display7seg is
    Port ( 
        reset : in std_logic;
        clk : in std_logic;
        destino : IN STD_LOGIC_VECTOR (2 downto 0);    
        actual : in std_logic_vector (2 downto 0);
        led : OUT STD_LOGIC_VECTOR (6 downto 0);
        ctrl : out std_logic_vector (7 downto 0);          
        modo_motor: in std_logic_vector (1 downto 0);   --El modo_motor es si subimos, bajamos o nos paramos   
        modo_puerta : in std_logic_vector (1 downto 0)
        --puntiquitillitos puntitos
        
    );
end Display7seg;

architecture Behavioral of Display7seg is

signal num_led : std_logic_vector (6 downto 0):="1111111";
signal flag : std_logic_vector (2 downto 0);   
signal control : std_logic_vector (7 downto 0):="11111111";
begin 

    display_piso: process (reset, clk)
    begin
        if reset = '1' then
            num_led <= "1111001";   --Se encenderá todo, para darle un toque retro al reset
            flag <= "000";
            control <= "11111001";
        elsif rising_edge (clk) then --Le pondremos una frecuencia de reloj acorde
            if flag = "000" then
                control <= "11111110";
                case (destino) is 
                    when "001" => 
                        num_led <= "1001111";   --numero 1
                    when "010" =>
                        num_led <= "0010010";   --numero 2
                    when "011" =>
                        num_led <= "0000110";   --numero 3
                    when "100" =>
                        num_led <= "1001100";   --numero 4
                    when "101" =>
                        num_led <= "0100100";   --numero 5
                    when "110" =>
                        num_led <= "0100000";   --numero 6
                    when "111" =>
                        num_led <= "0001111";   --numero 7
                    when others => 
                        num_led <= "1111110";   --rallita de espera snif
                end case;
                
                flag <= flag + 1;
                
            elsif flag = "001" then 
                control <= "11111101" ;
                case (modo_motor) is
                    when "10" =>    --Ascensor Sube
                        num_led <= "1111100";    --Dibujo de subir
                    when "01" =>    --Ascensor Baja
                        num_led <= "1111010";    --Dibujo de bajar. Cuadrado inferior
                    when "00" =>    --Ascensor Parado
                        num_led <= "1111110";    --Dibujo de parado. Linea intermedia
                    when others => 
                        num_led <= "1001000";    --Dibujo de una H. Significa que algo malo ocurre.
                end case;
                
                flag <= flag + 1;                

            elsif flag = "010" then
                control <= "11111011" ;
                case (modo_motor) is
                    when "10" =>    --Ascensor Sube
                        num_led <= "1011110";    --Dibujo de subir
                    when "01" =>    --Ascensor Baja
                        num_led <= "1101110";    --Dibujo de bajar. Cuadrado inferior
                    when "00" =>    --Ascensor Parado
                        num_led <= "1111110";    --Dibujo de parado. Linea intermedia
                    when others => 
                        num_led <= "1001000";    --Dibujo de una H. Significa que algo malo ocurre.
                end case;  

                flag <= flag + 1;                

            elsif flag = "011" then
                control <= "11110111" ;
                case (actual) is                
                    when "001" => 
                        num_led <= "1001111";   --numero 1
                    when "010" =>
                        num_led <= "0010010";   --numero 2
                    when "011" =>
                        num_led <= "0000110";   --numero 3
                    when "100" =>
                        num_led <= "1001100";   --numero 4
                    when "101" =>
                        num_led <= "0100100";   --numero 5
                    when "110" =>
                        num_led <= "0100000";   --numero 6
                    when "111" =>
                        num_led <= "0001111";   --numero 7
                    when others => 
                        num_led <= "1111110";   --rallita de espera snif
                end case;
                
                flag <= flag + 1;                

            elsif flag = "100" then
                control <= "11101111" ;
                case (modo_puerta) is
                    when "10" =>   
                        num_led <= "1001001";   
                    when others => 
                        num_led <= "1001111";    
                end case;  

                flag <= flag + 1;       

            elsif flag = "101" then
                control <= "11011111" ;
                case (modo_puerta) is
                    when "01" =>   
                        num_led <= "1001111";    
                    when "00" => 
                        num_led <= "1111001";    
                    when others => 
                        num_led <= "1111111";   
                end case;  

                flag <= flag + 1;          

            elsif flag = "110" then
                control <= "10111111" ;
                case (modo_puerta) is
                    when "01" =>   
                        num_led <= "1111001";    
                    when "00" => 
                        num_led <= "1001111";    
                    when others => 
                        num_led <= "1111111";   
                end case;  

                flag <= flag + 1;  

            elsif flag = "111" then
                control <= "01111111" ;
                case (modo_puerta) is
                    when "01" =>   
                        num_led <= "1001001";   
                    when others => 
                        num_led <= "1111001";   
                end case;  

                flag <= flag + 1;  

            end if;
        end if;

    end process;

    led <= num_led;
    ctrl <= control;
    
end architecture Behavioral;
       