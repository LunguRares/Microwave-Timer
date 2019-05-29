----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2019 21:14:31
-- Design Name: 
-- Module Name: display - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity display is
    Port ( clk: in STD_LOGIC;
           tMinutes,uMinutes,tSeconds,uSeconds : in STD_LOGIC_VECTOR (3 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           segs : out STD_LOGIC_VECTOR (6 downto 0));
end display;

architecture Behavioral of display is
    component sevenSegDecoder is
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
               segs : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    signal tMinutesSegs,uMinutesSegs,tSecondsSegs,uSecondsSegs : STD_LOGIC_VECTOR (6 downto 0);
    
    shared variable ledNo: natural range 0 to 3;
    constant max_count : integer := 156250;  --used for selecting the clock frequency (320Hz)
    signal divClk: std_logic;
begin
    -- clock divider process
---------------------------------
    clk_divide : process (clk) is
    variable count : unsigned(20 downto 0):= to_unsigned(0,21);   -- required to count up to 1,250,000!
    variable clk_int : std_logic := '0';                          -- this is a clock internal to the process
    begin
      if rising_edge(clk) then 
        if count < max_count-1 then     -- highest value count should reach is 1,249,999.
          count := count + 1;           -- increment counter
        else
          count := to_unsigned(0,21);   -- reset count to zero
          clk_int := not clk_int;       -- invert clock variable every time counter resets
        end if;
        divClk <= clk_int;                 -- assign clock variable to internal clock signal
      end if; 
    end process;
    
    tMinutesDecoder: sevenSegDecoder port map(x => tMinutes, segs => tMinutesSegs);
    uMinutesDecoder: sevenSegDecoder port map(x => uMinutes, segs => uMinutesSegs);
    tSecondsDecoder: sevenSegDecoder port map(x => tSeconds, segs => tSecondsSegs);
    uSecodnsDecoder: sevenSegDecoder port map(x => uSeconds, segs => uSecondsSegs);

    -- 7 segment values selector process
------------------------------------
    anodeSelector: process (divClk) is
    begin
        if rising_edge(divClk) then
            case ledNo is 
                when 0 => anode <= "0111"; 
                          segs <= tMinutesSegs; 
                          ledNo := 1; -- light up only the first 7 segment display
                when 1 => anode <= "1011"; 
                          segs <= uMinutesSegs; 
                          ledNo := 2; -- light up only the second 7 segment display
                when 2 => anode <= "1101"; 
                          segs <= tSecondsSegs; 
                          ledNo := 3; -- light up only the third 7 segment display
                when 3 => anode <= "1110"; 
                          segs <= uSecondsSegs; 
                          ledNo := 0; -- light up only the fourth 7 segment display
                when others => anode <= "1111"; 
                               ledNo := 0; -- error occured so don't display anything
            end case;
        end if;
    end process;

end Behavioral;
