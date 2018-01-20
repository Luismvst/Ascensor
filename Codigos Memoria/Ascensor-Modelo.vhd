Ascensor-Modelo.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ascensor is
  Port ( 
        boton: IN STD_LOGIC_VECTOR (2 downto 0);
        piso:  IN STD_LOGIC_VECTOR (2 downto 0);
        puerta:IN STD_LOGIC;
        clk,reset: IN STD_LOGIC;
        motor: OUT STD_LOGIC_VECTOR (1 downto 0);
        motor_puerta: OUT STD_LOGIC --Es posible que haga un vector de este motor más adelante.         
  );
end entity Ascensor;

architecture Behavioral of Ascensor is
    TYPE estado IS (inicia, cerrar, marcha);
    SIGNAL presente: estado:=inicia;
    SHARED VARIABLE boton_pulsado: STD_LOGIC_VECTOR (2 downto 0):=boton;
    begin
    p1 : process  (reset, clk) --FSM
        begin
        if reset = '1' then presente <= inicia;
        elsif rising_edge (clk) then
            case presente is
                when inicia=> 
                    if boton/="000" and boton/=piso then
                        presente <= cerrar;
                        boton_pulsado:=boton;
                    end if;
                when  cerrar => 
                    if puerta = '0' then 
                        presente <= marcha; --Sin obstaculo
                    end if;
                when marcha => 
                    if boton=piso then 
                        presente <= inicia; --Llegamos al piso indicado
                    end if;
             end case;
         end if;
         end process;
         
    p2 :  process (presente)  --SALIDA  ->  Solo al cambiar de estado 
        begin
        case presente is
            when marcha => 
                motor_puerta <= '1';    --Cerramos la puerta del ascensor
                if boton_pulsado > piso then
                    motor <= "10";          --Ascensor sube
                else 
                    motor <= "01";          --Ascensor baja
                end if;
             when others =>                 
                    motor <= "00";          --Ascensor parado
                    motor_puerta <= '0';    --Abrir puerta 
        end case;
        end process; 
end architecture Behavioral;	