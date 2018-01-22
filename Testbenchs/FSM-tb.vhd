FSM-tb.vhd

entity fsm_tb is
end;

architecture behavioral of fsm_tb is

component fsm is
port (
	clk, reset : in std_logic; 
	f_carrera_puerta : in std_logic_vector (1 downto 0);
	boton_stop : in std_logic;
	sensor_apertura : in std_logic;	--Nos indica que se encuentra en un piso adecuado para parar ( nosotros lo paramos como sensor externo)
	sensor_presencia : in std_logic;
	boton: in std_logic_vector (2 downto 0);
	piso : in std_logic_vector (2 downto 0);
	--El boton tiene un estado de reposo que es el 000 (no hay nada pulsandolo)
	destino : out std_logic_vector (2 downto 0);
	accion_motor: out std_logic_vector (1 downto 0);
	accion_motor_puerta: out std_logic_vector (1 downto 0)
	);
end component;

--Inputs
signal clk, reset, boton_stop, sensor_apertura, sensor_presencia : std_logic;
signal boton, piso : std_logic_vector (2 downto 0);
signal piso : std_logic_vector (3 downto 0);

--Outputs
signal destino : std_logic_vector ( 2 downto 0);
signal accion_motor, accion_motor_puerta : std_logic_vector (1 downto 0);

--Constantes
constant clk_period : time := 10 ns;

begin
	uut : fsm 	port map (
		clk => clk,
		reset => reset,
		f_carrera_puerta => f_carrera_puerta,
		boton_stop => boton_stop,
		sensor_apertura => sensor_apertura,
		boton => boton,
		piso => piso,
		destino => destino,
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
		reset <= '1';
		boton <= "000";
		sensor_apertura <= '1';
		sensor_presencia <= '0';
		f_carrera_puerta <= "10";
		piso <= "010";
		boton_stop <= '0'
		wait for 30 ns;
		assert accion_motor = "00" and accion_motor_puerta ="01" and destino = "001"
			report "ERROR"
			severity failure
		f_carrera_puerta <= "01";
		wait for 30 ns,
		assert accion_motor = "01" and accion_motor_puerta ="00" and destino = "001"
			report "ERROR"
			severity failure
		piso <= "001";
		wait for 30 ns,
		assert accion_motor = "00" and accion_motor_puerta ="10" and destino = "001"
			report "ERROR"
			severity failure
		f_carrera_puerta <= "10"
		wait for 30 ns,
		assert accion_motor = "00" and accion_motor_puerta = "00" and destino = "000"
			report "ERROR"
			severity failure
		boton = "011"
		wait for 30 ns,
		assert accion_motor = "00" and accion_motor_puerta = "01" and destino = "011"
			report "ERROR"
			severity failure
		f_carrera_puerta <= "01";
		wait for 30 ns,
		assert accion_motor = "10" and accion_motor_puerta = "00" and destino = "011"
			report "ERROR"
			severity failure
		piso <= "011";
		wait for 30 ns,
		assert accion_motor = "00" and accion_motor_puerta = "10" and destino = "011"
			report "ERROR"
			severity failure
		f_carrera_puerta <= "10"
		wait for 30 ns,
		assert accion_motor = "00" and accion_motor_puerta = "00" and destino = "000"
			report "ERROR"
			severity failure
		assert false
			report "Todo correcto en FSM"
			severity failure
	end process;
	end;