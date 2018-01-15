
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( 
        --Para el Decoder
        segment : out std_logic_vector ( 6 downto 0 );
        code    : in std_logic_vector (3 downto 0 );
       
       --Reloj y reset general
        reset     : in std_logic;
        clk       : in std_logic; 
        
        --Para el Ascensor
        --Hay que darle una vuelta a la implementacion fisica de la FPGA
        --con el ascensor y ClockDivider porque estos deben de ser los cables de conexion que se
        --unan a la placa con cada entrada y salida del mismo
        --NO ESTÁ BIEN IMPLEMENTADO, REVISAR
        
        sensor_piso : in std_logic; --Sensor que verifica su estado para realizar la operación de abrir puertas tras haber realizado el movimiento. Para no hacer fugaz la etapa.
        boton_pulsado   : in std_logic_vector (2 downto 0);     --Boton presionado en la FPGA  
        piso_actual   : in std_logic_vector (2 downto 0);     --Piso en el que nos encontramos
        puerta  : out std_logic;
        piso : in std_logic_vector (3 downto 0)
        --motor   : out std_logic_vector (1 downto 0)   --Tanto para subir como para bajar... Quizás luego quitemos el vector y hagamos dos separadas de subir y bajar
        --motor_puerta_A    : out std_logic
        
    );
end Top;

architecture Behavioral of Top is
    
    signal clk_display: std_logic;
    signal clk_ascensor: std_logic;
    
    --Decoder
    signal modo : std_logic_vector (1 downto 0);
    
    --Para el ascensor
    signal boton : std_logic_vector (2 downto 0);
    signal motor_puerta: std_logic;
    signal abriendo_puerta : std_logic;
    signal cerrando_puerta : std_logic;
    signal motor: std_logic_vector(1 downto 0);
    
    
    COMPONENT decoder 
    PORT (
        clk     : in std_logic;
        reset   : in std_logic;
        code    : in std_logic_vector ( 3 downto 0);
        led     : out std_logic_vector ( 6 downto 0 );
        modo : in std_logic_vector (1 downto 0)
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
        accion_motor_puerta    : out std_logic;
        sensor_piso : in std_logic;
        boton_pulsado : out std_logic_vector (2 downto 0)
       );
    END COMPONENT;
    
begin
    Inst_Decoder:   Decoder 
    PORT MAP (
        clk => clk,
        code => code,
        led => segment,
        reset => reset, 
         modo => modo
        );
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
    Inst_FSM:     FSM
    PORT MAP (
        reset => reset,
        boton => boton,
        piso => piso,
        clk => clk,
        sensor_piso => sensor_piso,
        abriendo_puerta => abriendo_puerta,
        cerrando_puerta => cerrando_puerta,
        accion_motor => motor,
        accion_motor_puerta => motor_puerta
        );
        
        
            

  
end Behavioral;
