
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
        digsel  : in std_logic_vector (3 downto 0);
        digctrl : out std_logic_vector (3 downto 0);
        
        --Para la Pantallita de fuera
        display_number : out std_logic_vector (  6 downto 0 );
        display_selection : out std_logic_vector ( 3 downto 0 );
           
        --Para el Clock-Divider
        reset     : in std_logic;
        clk       : in std_logic; 
        clk_out   : out std_logic;
        startstop : in std_logic
        
        --Para el Ascensor
        --Hay que darle una vuelta a la implementacion fisica de la FPGA
        --con el ascensor y ClockDivider porque estos deben de ser los cables de conexion que se
        --unan a la placa con cada entrada y salida del mismo
        --NO ESTÁ BIEN IMPLEMENTADO, REVISAR
        
        --boton_A   : in std_logic_vector (2 downto 0);   --A => Ascensor
        --piso_A    : in std_logic_vector (2 downto 0);
        --puerta_A  : in std_logic;
        --clk_A     : in std_logic;
        --reset_A   : in std_logic;
        --motor_A   : out std_logic_vector (1 downto 0);
        --motor_puerta_A    : out std_logic
        
    );
end Top;

architecture Behavioral of Top is
    
    signal clk_display: std_logic;
    signal clk_counter: std_logic;
    
    --Para el ascensor
    signal boton : std_logic_vector (2 downto 0);
    signal piso : std_logic_vector (2 downto 0);
    signal puerta : std_logic;
    signal motor : std_logic_vector (1 downto 0);
    signal motor_puerta: std_logic;
    
    
    COMPONENT decoder 
    PORT (
        code    : in std_logic_vector ( 3 downto 0);
        led     : out std_logic_vector ( 6 downto 0 )
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
    
    COMPONENT Ascensor
    PORT (
        boton   : in std_logic_vector (2 downto 0);
        piso    : in std_logic_vector (2 downto 0);
        puerta  : in std_logic;
        clk     : in std_logic;
        reset   : in std_logic;
        motor   : out std_logic_vector (1 downto 0);
        motor_puerta    : out std_logic
       );
    END COMPONENT;
    
begin
    Inst_Decoder:   Decoder 
    PORT MAP (
        code => code,
        led => segment
        --digsel => digctrl
        );
    Inst_Clock_Divider:     Clock_Divider
    GENERIC MAP ( frec => 50000000 )
    PORT MAP (
        --Mirar aquí cómo deberían ir las cosas puestas,
        -- creo que no está bien
        clk => clk,
        -- Esto significa que el reloj de Top (supuesta la capa menos especializada
        --y por tanto la más hardware de todas) pasa su valor al Clock_Divider
        clk_out => clk_display,
        --Aquí el Clock_Divider nos ofrece su salida que estime        
        reset => reset
        );
    Inst_Ascensor:      Ascensor
    PORT MAP (
        reset => reset,
        clk => clk,
        boton => boton,
        piso => piso,
        puerta => puerta,
        motor => motor,
        motor_puerta => motor_puerta
        );
        
        
            

  
end Behavioral;
