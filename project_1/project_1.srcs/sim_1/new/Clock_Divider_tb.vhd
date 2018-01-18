
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Clock_Divider_tb is
end Clock_Divider_tb;

architecture Behavioral of Clock_Divider_tb is

    --Declaración de componentes
    COMPONENT Clk_Divider 
    PORT(
        clk: IN STD_LOGIC;
        reset: IN STD_LOGIC;
        clk_out: IN STD_LOGIC
    );
    end COMPONENT;
    
    --Inputs
    signal clk: STD_LOGIC := '0';
    signal reset: STD_LOGIC := '0';
    signal clk_out: STD_LOGIC := '0';
    
    --Definicion de periodos de reloj
    constant clk_period : time := 10 ns;
    
    begin
        --instanciacion test
        uut : clk_divider PORT MAP (
            clk  => clk,
            reset => reset,
            clk_out => clk_out
        );
        
        --Definicion del proceso Clock
        clk_process : process 
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
        
        --Stimulus process
        stim_process : process 
        begin
            --Mantener estado de inicio
            wait for 100 ns;
            
            --Estimulo
            reset <= '1';
            wait for 50 ns;
            reset <= '0';
            wait for 50 ns;
            
            assert false;
                        report "Simulacion finalizada"
                        severity failure;
        end process;
        
end Behavioral;
