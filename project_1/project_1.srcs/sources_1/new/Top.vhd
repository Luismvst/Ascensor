----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.12.2017 20:41:35
-- Design Name: 
-- Module Name: Top - Behavioral
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

entity Top is
    Port ( 
        segment : out std_logic_vector ( 6 downto 0 );
        code    : in std_logic_vector (3 downto 0 );
        digsel  : in std_logic_vector (3 downto 0);
        digctrl : out std_logic_vector (3 downto 0);
        clk     : in std_logic_vector (3 downto 0);
        
                 
    );
end Top;

architecture Behavioral of Top is

    COMPONENT Decoder 
    PORT (
        code:   in std_logic_vector ( 3 downto 0);
        led:    out std_logic_vector ( 6 downto 0 )
        );
    END COMPONENT;        
begin
    Inst_decoder:   Decoder 
    PORT MAP (
        code => code;
        led => segment;
        digsel => digctrl      


end Behavioral;
