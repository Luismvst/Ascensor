
library ieee;
use ieee.std_logic_1164.all;

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is

    component FSM
        port (clk                 : in std_logic;
              reset               : in std_logic;
              f_carrera_puerta    : in std_logic_vector (1 downto 0);
              boton_stop          : in std_logic;
              sensor_apertura     : in std_logic;
              sensor_presencia    : in std_logic;
              boton               : in std_logic_vector (2 downto 0);
              piso                : in std_logic_vector (2 downto 0);
              destino             : out std_logic_vector (2 downto 0);
              accion_motor        : out std_logic_vector (1 downto 0);
              accion_motor_puerta : out std_logic_vector (1 downto 0));
    end component;

    signal clk                 : std_logic;
    signal reset               : std_logic;
    signal f_carrera_puerta    : std_logic_vector (1 downto 0);
    signal boton_stop          : std_logic;
    signal sensor_apertura     : std_logic;
    signal sensor_presencia    : std_logic;
    signal boton               : std_logic_vector (2 downto 0);
    signal piso                : std_logic_vector (2 downto 0);
    signal destino             : std_logic_vector (2 downto 0);
    signal accion_motor        : std_logic_vector (1 downto 0);
    signal accion_motor_puerta : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FSM
    port map (clk                 => clk,
              reset               => reset,
              f_carrera_puerta    => f_carrera_puerta,
              boton_stop          => boton_stop,
              sensor_apertura     => sensor_apertura,
              sensor_presencia    => sensor_presencia,
              boton               => boton,
              piso                => piso,
              destino             => destino,
              accion_motor        => accion_motor,
              accion_motor_puerta => accion_motor_puerta);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        f_carrera_puerta <= (others => '0');
        boton_stop <= '0';
        sensor_apertura <= '0';
        sensor_presencia <= '0';
        boton <= (others => '0');
        piso <= (others => '0');

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_FSM of tb_FSM is
    for tb
    end for;
end cfg_tb_FSM;