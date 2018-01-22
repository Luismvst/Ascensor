MotorAscensor-tb.vhd

-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 22.1.2018 14:06:16 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_Control_Motor_Ascensor is
end tb_Control_Motor_Ascensor;

architecture tb of tb_Control_Motor_Ascensor is

    component Control_Motor_Ascensor
        port (clk          : in std_logic;
              reset        : in std_logic;
              accion_motor : in std_logic_vector (1 downto 0);
              motor        : out std_logic_vector (1 downto 0));
    end component;

    signal clk          : std_logic;
    signal reset        : std_logic;
    signal accion_motor : std_logic_vector (1 downto 0);
    signal motor        : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Control_Motor_Ascensor
    port map (clk          => clk,
              reset        => reset,
              accion_motor => accion_motor,
              motor        => motor);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        accion_motor <= (others => '0');

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

configuration cfg_tb_Control_Motor_Ascensor of tb_Control_Motor_Ascensor is
    for tb
    end for;
end cfg_tb_Control_Motor_Ascensor;

