Sim_Piso-tb.vhd

entity Sim_Piso_tb is
end;

architecture behavioral of Sim_Piso_tb is

component Sim_Piso is
port (
	clk, reset : in std_logic; 
	sentido : in std_logic_vector (1 downto 0);
	piso : out std_logic_vector (6 downto 0)
	);
end component;

--Inputs
signal clk, reset : std_logic;
signal sentido : in std_logic_vector (1 downto 0);

--Outputs
signal piso : std_logic_vector (6 downto 0);

--Constantes
constant clk_period : time := 10 ns;

begin
	uut : Sim_Piso 	port map (
		clk => clk,
		reset => reset,
		sentido => sentido,
		piso => piso
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
		assert piso = "0000100"
			severity failure
		sentido <= "01";
		wait for 10 ns
		assert piso = "0000010"
			severity failure
		wait for 40 ns;
		assert piso <= "0000001"
			severity failure
		

		assert false
			report "Todo correcto Sim_Piso"
			severity failure
