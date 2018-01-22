Sim_Piso-tb2.vhd

-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 22.1.2018 14:07:18 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_Sim_Piso is
end tb_Sim_Piso;

architecture tb of tb_Sim_Piso is

    component Sim_Piso
        port (sentido : in std_logic_vector (1 downto 0);
              clk     : in std_logic;
              reset   : in std_logic;
              piso    : out std_logic_vector (6 downto 0));
    end component;

    signal sentido : std_logic_vector (1 downto 0);
    signal clk     : std_logic;
    signal reset   : std_logic;
    signal piso    : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Sim_Piso
    port map (sentido => sentido,
              clk     => clk,
              reset   => reset,
              piso    => piso);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        sentido <= (others => '0');

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

configuration cfg_tb_Sim_Piso of tb_Sim_Piso is
    for tb
    end for;
end cfg_tb_Sim_Piso;