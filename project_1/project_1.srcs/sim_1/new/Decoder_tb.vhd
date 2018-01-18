library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Decoder_tb is
end Decoder_tb;

architecture Behavioral of Decoder_tb is
    
    COMPONENT Decoder
    PORT(
        reset : in std_logic;
        clk : in std_logic;
        code: IN STD_LOGIC_VECTOR (3 downto 0);
        led : out STD_LOGIC_VECTOR (6 downto 0);
        modo : in std_logic_vector (1 downto 0)
    );
    END COMPONENT;
    
    --Inputs
    SIGNAL code : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal reset : std_logic := '0';
    signal clk : std_logic := '0';
    signal modo : std_logic_vector (1 downto 0) := (others => '0');
    
    --Outputs
    SIGNAL led: STD_LOGIC_VECTOR (6 downto 0);
    --signal control : std_logic_vector (3 downto 0);
    --No hay reloj en Port List. Cambiar <clock> debajo por su nombre apropiado
    constant clk_period : time := 10 ns;
    
    begin
        uut : Decoder 
        PORT MAP (
            clk=> clk,
            reset => reset,
            code => code,
            modo => modo,
            led => led
            --control => control
            );
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
            --insert stimulus here
            --Historieta: sin reset, nos mantenemos en el piso 0 parados. 
            --Bajamos de piso 1. Reset y subimos al 3. Subimos del piso 4. 
            --Y bajamos otra vez sin reset del 1
            reset <= '0';
            code <= "0000";
            modo <= "00";
            wait for 20 ns;
            code <= "001";
            modo <= "01";
            wait for 20 ns;
            reset <= '1';
            code <= "0010":
            modo <= "10";
            wait for 20 ns;
            code <= "0011";
            modo <= "10";
            wait for 20 ns;
            reset <= '0';
            code <= "0001";
            modo <= "01";
            wait for 20 ns;
            
            assert false
                report "Simulación finalizada. Test superado"
                severity failure;
        end process;                                  
end Behavioral;
