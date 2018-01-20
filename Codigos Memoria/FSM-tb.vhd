FSM-tb.vhd

entity fsm_tb is
end;

architecture behavioral of fsm_tb is

component fsm is
port (
	clk, reset : in std_logic; 
	puerta_abierta : in std_logic;
	puerta_cerrada : in std_logic;
	sensor_piso : in std_logic;	--Nos indica que se encuentra en un piso adecuado para parar ( nosotros lo paramos como sensor externo)
	boton: in std_logic_vector (2 downto 0);
	piso : out std_logic_vector (3 downto 0);
	--El boton tiene un estado de reposo que es el 000 (no hay nada pulsandolo)
	boton_pulsado : out std_logic_vector (2 downto 0);
	accion_motor: out std_logic_vector (1 downto 0);
	accion_motor_puerta: out std_logic_vector (1 downto 0)
	);
end component;

--Inputs
signal clk, reset, puerta_cerrada, puerta_abierta, sensor_piso : std_logic;
signal boton : std_logic_vector (2 downto 0);
signal piso : std_logic_vector (3 downto 0);

--Outputs
signal boton_pulsado : std_logic_vector ( 2 downto 0);
signal accion_motor, accion_motor_puerta : std_logic_vector (1 downto 0);

--Constantes
constant clk_period : time := 10 ns;

begin
	uut : fsm 	port map (
		clk => clk,
		puerta_abierta => puerta_abierta,
		puerta_cerrada => puerta_cerrada,
		sensor_piso => sensor_piso,
		boton => boton,
		piso => piso,
		boton_pulsado => boton_pulsado,
		accion_motor => accion_motor,
		accion_motor_puerta => accion_motor_puerta
		);

	--Clock Process definition
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	--Stimulus process
	stim_process: process
	begin
		reset <= '0';
		boton <= "000";
		sensor_piso <= '1';
		puerta_cerrada <= '1';
		puerta_abierta <= '0';
		wait for 30 ns;
		boton = "001";
		sensor_piso='0';
		wait for 30 ns,
		sensor_piso='1';
		wait for 30 ns;
		puerta_abierta= '1';
		wait for 30 ns;
		boton="011";
		wait for 30 ns;
		puerta_cerrada='0';
		wait for 30 ns;
		puerta_abierta='1';
		wait for 30 ns;
		boton="011";
		wait for 30 ns;
		puerta_cerrada='1';
		wait for 30 ns;
		sensor_piso='0';
		wait for 30 ns;
		sensor_piso='1';
		wait for 30 ns;

		assert piso = "011"
			report "Algo no va bien . . . "
			severity failure

		puerta_abierta = '1';
		wait for 30 ns;
		
		wait for 30 ns;
		assert false;
			report "De puuta Madre, sale bien por ahora"
			severity failure



