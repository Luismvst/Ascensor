
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
        
        --Para el Clock-Divider
        reset_C     : in std_logic; --C => Clock
        clk_CD     : in std_logic;  --CD => ClockDivider
        clk_out_CD : out std_logic;
        
        --Para el Ascensor
        --Hay que darle una vuelta a la implementacion fisica de la FPGA
        --con el ascensor y ClockDivider porque estos deben de ser los cables de conexion que se
        --unan a la placa con cada entrada y salida del mismo
        --NO ESTÁ BIEN IMPLEMENTADO, REVISAR
        
        boton_A   : in std_logic_vector (2 downto 0);   --A => Ascensor
        piso_A    : in std_logic_vector (2 downto 0);
        puerta_A  : in std_logic;
        clk_A     : in std_logic;
        reset_A   : in std_logic;
        motor_A   : out std_logic_vector (1 downto 0);
        motor_puerta_A    : out std_logic
        
    );
end Top;

architecture Behavioral of Top is

    COMPONENT Decoder 
    PORT (
        code    : in std_logic_vector ( 3 downto 0);
        led     : out std_logic_vector ( 6 downto 0 )
        );
    END COMPONENT;        
    
    COMPONENT Clock_Divider
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
        code => code;
        led => segment;
        digsel => digctrl
        );
    Inst_Clock_Divider:     Clock_Divider
    PORT MAP (
        --Mirar aquí cómo deberían ir las cosas puestas,
        -- creo que no está bien
        clk_CD => clk;
        -- Esto significa que el reloj de Top (supuesta la capa menos especializada
        --y por tanto la más hardware de todas) pasa su valor al Clock_Divider
        clk_out => clk_out_CD;
        --Aquí el Clock_Divider nos ofrece su salida que estime        
        reset_C => reset
        );
    Inst_Ascensor:      Ascensor
    PORT MAP (
        reset_A => reset;
        clk_out_CD => clk;
        boton_A => boton;
        piso_A => piso;
        puerta_A => puerta;
        motor => motor_A;
        motor_puerta => motor_puerta_A
        );
        
        
            

  
end Behavioral;
