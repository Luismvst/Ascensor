
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ascensor is
  Port ( 
        boton:      in std_logic_vector (2 downto 0); 
        piso:       in std_logic_vector (2 downto 0);
        puerta:     in std_logic;
        clk,reset:  in std_logic;
        motor:      out std_logic_vector (1 downto 0);
        motor_puerta: out std_logic --Es posible que haga un vector de este motor más adelante.         
  );
end entity Ascensor;

architecture Behavioral of Ascensor is
    TYPE estado IS (reposo, cerrar, marcha, abrir);
    SIGNAL presente: estado:=reposo; --Dar una vuelta luego
    SHARED VARIABLE destino: std_logic_vector (2 downto 0):=boton;
    begin
    p1 : process  (reset, clk) --FSM (Finite State Machine)
        begin
        if reset = '1' then presente <= reposo;
        elsif rising_edge (clk) then    
            case presente is
                when reposo=> 
                -- Estado no pulsado de boton = '000'
                    if boton /= "000" and boton /= piso then                        
                        destino:=boton;
                        presente <= cerrar;
                    end if;
                when  cerrar => 
                    if puerta = '0' then 
                        presente <= marcha; --Vamoh que no' vamoh
                    end if;
                when marcha => 
                    if destino=piso then 
                        presente <= abrir; --Llegamos al piso indicado
                    end if;
                when abrir => 
                    if puerta = '1' then
                        presente <= reposo;
                    end if;
             end case;
         end if;
         end process;
         
    p2 :  process (presente)  --SALIDA  ->  Solo al cambiar de estado 
        begin
        case presente is
            when cerrar => 
                motor_puerta <= '1';    --Cerramos la puerta del ascensor
            when abrir =>
                motor_puerta <= '0';
            when marcha =>              --Abrimos la puerta del ascensor
                if destino > piso then
                    motor <= "10";          --Ascensor sube
                else --destino < piso then
                    motor <= "01";          --Ascensor baja
                end if;
            when reposo => 
                    motor <= "00";          --Ascensor parado
            when others =>                  --Estado de seguridad por si acaso 
                    motor <= "00";          --Ascensor parado
                    motor_puerta <= '0';    --Abrir puerta 
        end case;
        end process; 
end architecture Behavioral;
