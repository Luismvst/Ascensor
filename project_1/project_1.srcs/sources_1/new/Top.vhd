
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

entity Top is
    Port ( 
       sensor_presencia : in std_logic;             --Célula de la puerta que detecta la presencia en el arco de la puerta. 
       sensor_apertura : in std_logic;              --Detecta que la puerta está alineada con el suelo para poder abrirse.
       boton : in std_logic_vector (6 downto 0);    --detecta el botón pulsado por el            

       segment : out std_logic_vector (6 downto 0);
       --puntitos_puerta : out std_logic_vector (1 downto 0);
       ctrl : out std_logic_vector (7 downto 0)
    );
end Top;

architecture Structural of Top is
    
    --Tipos de relojes
    signal 60Hz: std_logic;
    signal 1Hz: std_logic; 
    
    --FSM
    signal f_carrera_puerta : std_logic_vector (1 downto 0);
    signal piso_actual : std_logic_vector (2 downto 0);
    signal boton_decod : std_logic_vector (2 downto 0);
    signal puerta_fsm : std_logic_vector (1 downto 0);  --Fsm manda accion sobre los motores de la puerta.
    signal motor_fsm : std_logic_vector (1 downto 0);   --Fsm manda accion sobre los motroes del ascensor.
    signal destino_fsm : std_logic_vector (2 downto 0);

    --Simulaciones de motores
    --Inputs
    signal motor_puerta : std_logic_vector (1 downto 0);
    signal motor_ascensor: std_logic_vector (1 downto 0);
    --Outputs
    signal puerta_sim : std_logic_vector (1 downto 0);
    signal piso_sim : std_logic_vector (1 downto 0);
          
    COMPONENT Display7seg
    PORT (
        reset : in std_logic;
        clk : in std_logic;
        destino : IN STD_LOGIC_VECTOR (2 downto 0);    
        actual : in std_logic_vector (2 downto 0);
        led : OUT STD_LOGIC_VECTOR (6 downto 0);
        control : out std_logic_vector (7 downto 0);          
        modo_motor: in std_logic_vector (1 downto 0);  
        modo_puerta : in std_logic_vector (1 downto 0)
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
        clk, reset : in std_logic; 
        f_carrera_puerta : in std_logic_vector (1 downto 0);
        sensor_apertura : in std_logic; 
        boton: in std_logic_vector (2 downto 0);
        piso : in std_logic_vector (2 downto 0);
        destino : out std_logic_vector (2 downto 0);
        accion_motor: out std_logic_vector (1 downto 0);
        accion_motor_puerta: out std_logic_vector (1 downto 0)
       );
    END COMPONENT;
    
    COMPONENT Control_Motor_Puerta
    PORT (
        clk, reset : in std_logic;
        accion_motor_puerta: in std_logic_vector (1 downto 0);
        sensor_presencia : in std_logic;
        motor_puerta: out std_logic_vector (1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Control_Motor_Ascensor
    PORT (
        clk, reset : in std_logic;
        accion_motor : in std_logic_vector (1 downto 0);
        motor : out std_logic_vector (2 downto 0)
        );
    END COMPONENT;

    COMPONENT Sim_Puerta 
    PORT (
        sentido : in std_logic_vector (1 downto 0);
        estado_sim : out std_logic_vector (1 downto 0);
        clk : in std_logic;
        f_carrera : in std_logic_vector (1 downto 0)
        );
    END COMPONENT;

    COMPONENT Sim_Piso 
    PORT (
        sentido : in std_logic_vector (1 downto 0);
        clk : in std_logic;
        piso : out std_logic_vector (6 downto 0)
        );
    END COMPONENT;

    COMPONENT Decod_Piso
    PORT (
        boton: in std_logic_vector (6 downto 0);
        boton_decod : out std_logic_vector (2 downto 0);
        clk : in std_logic
        );
    END COMPONENT;
begin
    
    Inst_Clock_Divider_FSM:     Clock_Divider
    GENERIC MAP ( frec => 50000000 )
    PORT MAP (
        clk => clk,
        clk_out => 1Hz,     
        reset => reset
        );
        
    Inst_Clock_Divider_Display:     Clock_Divider
    GENERIC MAP ( frec => 3000000000 )
    PORT MAP (
        clk => clk,
        clk_out => 60Hz,     
        reset => reset
        );
                
    Inst_Decoder:   Display7seg 
    PORT MAP (
        clk => 60Hz,
        reset => reset,
        destino => destino_fsm,
        actual => piso_actual,
        led => segment,
        control => ctrl,
        modo_puerta => puerta_sim,
        modo_motor => motor_ascensor
        );                       
                
    Inst_FSM:     FSM
    PORT MAP (
        clk => 1Hz,
        reset => reset,
        boton => boton_decod,
        f_carrera_puerta => f_carrera_puerta,
        piso => piso_actual,
        sensor_apertura => sensor_apertura,
        accion_motor => motor_fsm,
        accion_motor_puerta => puerta_fsm
        );
        
    Inst_Motor_Puerta:  Control_Motor_Puerta
    PORT MAP ( 
        clk => 60Hz,
        reset => reset,
        accion_motor_puerta => puerta_fsm,
        motor_puerta => motor_puerta
        );
        
    Inst_Motor_Ascensor : Control_Motor_Ascensor
    PORT MAP (
        clk=> 60Hz,
        reset => reset,
        accion_motor => motor_fsm,
        motor => motor
        );            

    Inst_Sim_Piso : Sim_Piso
    PORT MAP (
        clk => 1Hz,
        sentido => motor_ascensor,
        piso => piso_sim
        );

    Inst_Sim_Puerta : Sim_Puerta 
    PORT MAP (
        clk => 1Hz,
        sentido => motor_puerta,
        estado_sim => puerta_sim,
        f.carrera => f.carrera_puerta
        );

    Inst_Decod_Boton : Decod_Piso
    PORT MAP (
        entrada => boton,
        clk => 60Hz,
        salida => boton_decod
        );

    Inst_Decod_Piso : Decod_Piso
    PORT MAP (
        clk => 60Hz,
        entrada => piso_sim,
        salida => piso_actual
        );

  
end Structural;
