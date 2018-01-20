
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Top is
    Port ( 
        --Para el Decoder
        segment : out std_logic_vector ( 6 downto 0 );  --La salida de los leds
       
       --Reloj y reset general
        reset     : in std_logic;  
        clk       : in std_logic; 
        
        --Para el Ascensor
        
         --Sensor que verifica su estado para realizar la operación de abrir puertas tras haber realizado el movimiento. Para no hacer fugaz la etapa.
        sensor_piso : in std_logic; 
        
        boton_pulsado  : in std_logic_vector (3 downto 0);     --Boton presionado en la FPGA  
        puerta  : out std_logic;                                --Nos muestra la puerta abierta o cerrada
        puerta_abierta : in std_logic;                         --para no realizar etapas fugaces, el sensor que verifica que la puerta se ha abierto.
        puerta_cerrada : in std_logic;                          --Lo mismo que abriendo puerta pero al contrario                   
        motor_subir   : out std_logic;                          --Motor sube
        motor_bajar : out std_logic;                            --Motor baja
        motor_puerta_abrir: out std_logic;                    --Motor puerta ( 1 cierra,  0 abre )
        motor_puerta_cerrar: out std_logic                    --Motor puerta ( 1 cierra,  0 abre )
        
    );
end Top;

architecture Behavioral of Top is
    
    --Tipos de relojes
    signal clk_display: std_logic;
    signal clk_ascensor: std_logic;
    
    --Decoder
    signal modo : std_logic_vector (1 downto 0);
    signal code : std_logic_vector (3 downto 0);
    
    --Ascensor
    signal piso_actual : std_logic_vector (2 downto 0);
    signal piso : std_logic_vector (3 downto 0);  
    signal boton : std_logic_vector (3 downto 0);
    signal s_motor_puerta: std_logic_vector (1 downto 0);
    signal s_motor: std_logic_vector(1 downto 0);  
       
    COMPONENT Decoder 
    PORT (
        clk     : in std_logic;
        reset   : in std_logic;
        code    : in std_logic_vector ( 3 downto 0);
        led     : out std_logic_vector ( 6 downto 0 );
        modo    : in std_logic_vector (1 downto 0)
        );
    END COMPONENT;        
    
    COMPONENT Clock_Divider
    GENERIC (frec: integer := 50000000 );
    PORT ( 
        clk     : in std_logic;
        reset   : in std_logic;
        clk_out : out std_logic
        );
    END COMPONENT;
    
    COMPONENT FSM
    PORT (
        boton   : in std_logic_vector (2 downto 0);
        piso    : in std_logic_vector (2 downto 0);
        abriendo_puerta  : in std_logic; 
        cerrando_puerta : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic;
        accion_motor   : out std_logic_vector (1 downto 0);
        accion_motor_puerta    : out std_logic_vector (1 downto 0);
        sensor_piso : in std_logic;
        boton_pulsado : out std_logic_vector (2 downto 0)
       );
    END COMPONENT;
    
    COMPONENT Motor_Puerta
    PORT (
        clk : in std_logic;
        reset : in std_logic;
        accion_motor_puerta : in std_logic_vector (1 downto 0);
        motor_puerta_abrir : out std_logic;
        motor_puerta_cerrar : out std_logic
        );
    END COMPONENT;
    
    COMPONENT Motor_Ascensor
    PORT (
        clk, reset : in std_logic;
        accion_motor: in std_logic_vector (1 downto 0);
        motor_subir : out std_logic;
        motor_bajar: out std_logic
        );
    END COMPONENT;
    
begin
    
    Inst_Clock_Divider_FSM:     Clock_Divider
    GENERIC MAP ( frec => 50000000 )
    PORT MAP (
        clk => clk,
        clk_out => clk_ascensor,     
        reset => reset
        );
        
    Inst_Clock_Divider_Display:     Clock_Divider
    GENERIC MAP ( frec => 50000000 )
    PORT MAP (
        clk => clk,
        clk_out => clk_display,     
        reset => reset
        );
                
    Inst_Decoder:   Decoder 
    PORT MAP (
        clk => clk_display,
        code => code,
        led => segment,
        reset => reset, 
        modo => modo
        );                       
                
    Inst_FSM:     FSM
    PORT MAP (
        reset => reset,
        boton => boton,
        piso => piso,
        clk => clk_ascensor,
        sensor_piso => sensor_piso,
        abriendo_puerta => abriendo_puerta,
        cerrando_puerta => cerrando_puerta,
        accion_motor => s_motor,
        accion_motor_puerta => s_motor_puerta
        );
        
    Inst_Motor_Puerta:  Motor_Puerta
    PORT MAP ( 
        clk => clk,
        reset => reset,
        accion_motor_puerta => s_motor_puerta,
        motor_puerta => motor_puerta_ascensor
        );
        
    Inst_Motor_Ascensor : Motor_Ascensor
    PORT MAP (
        clk=> clk,
        reset => reset,
        accion_motor => s_motor,
        motor_subir => motor_subir,
        motor_bajar => motor_bajar
        );            

  
end Behavioral;
