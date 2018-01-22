Sim_Puerta-tb.vhd

entity Sim_Puerta_tb is
end;

architecture behavioral of Sim_Puerta_tb is

component Sim_Puerta is
port (
	clk, reset : in std_logic; 
	sentido : in std_logic_vector (1 downto 0);
	estado_sim : out std_logic_vector (1 downto 0);
	f_carrera : out std_logic_vector (1 downto 0)
	);
end component;

--Inputs
signal clk, reset : std_logic;
signal sentido : in std_logic_vector (1 downto 0);

--Outputs
signal estado_sim, f_carrera : std_logic_vector (1 downto 0);

--Constantes
constant clk_period : time := 10 ns;

begin
	uut : Sim_Puerta 	port map (
		clk => clk,
		reset => reset,
		sentido => sentido,
		estado_sim => estado_sim,
		f_carrera => f_carrera,
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
		sentido <= "00";
		wait for 30 ns;
		assert estado_sim = "01" and f_carrera = "00"
			severity failure
		sentido <= "01";
		wait for 40 ns
		assert estado_sim = "00" and f_carrera = "01"
			severity failure
		sentido <= "00"
		wait for 40 ns;
		assert estado_sim = "00" and f_carrera = "01"
			severity failure
		sentido <= "10"
		wait for 40 ns;
		assert estado_sim = "11" and f_carrera = "10"
			severity failure

		assert false
			report "Todo correcto Sim_Puerta"
			severity failure

	end process;
end;

