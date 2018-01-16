----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2017 19:36:14
-- Design Name: 
-- Module Name: Clock_Divider_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
            --Mantener estado de reset un ratito
            wait for 100 ns;
            
            --Estimulo
            reset <= '1';
            wait for 50 ns;
            reset <= '0';
            wait;
        end process;
        
end Behavioral;
