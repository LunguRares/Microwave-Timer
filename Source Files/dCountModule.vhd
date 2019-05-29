----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2019 12:29:01
-- Design Name: 
-- Module Name: dCountModule - Behavioral
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

entity dCountModule is
  Port (clk,reset,enable:in STD_LOGIC; 
        uSecSet,tSecSet,uMinSet,tMinSet:in STD_LOGIC_VECTOR(3 downto 0);
        done: out STD_LOGIC;
        ledDone :out STD_LOGIC_VECTOR(15 downto 0);
        uSeconds,tSeconds,uMinutes,tMinutes:out STD_LOGIC_VECTOR(3 downto 0));
end dCountModule;

architecture Behavioral of dCountModule is
    component downCounter is
    Port (clk,reset,enable: in STD_LOGIC;
           data:in STD_LOGIC_VECTOR(3 downto 0);
           Q : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    constant max_count : integer := 50000000;  --used for selecting the clock frequency (1Hz)
    signal uSecClock, tSecClock, uMinClock, tMinClock: STD_LOGIC := '0';    
    signal uSec, tSec, uMin, tMin: STD_LOGIC_VECTOR(3 downto 0); 
     for tSecCounter: downCounter use entity work.downCounter(arch5);   
     for tMinCounter: downCounter use entity work.downCounter(arch5);   
begin

    uSecClockGenerator: process(clk) 
        variable count : unsigned(25 downto 0):= to_unsigned(0,26);   -- required to count up to 1,250,000!
        variable clk_int : std_logic := '1';                          -- this is a clock internal to the process
    begin
        if rising_edge(clk) then 
            if count < max_count-1 then     -- highest value count should reach is 1,249,999.
            count := count + 1;           -- increment counter
        else
            count := to_unsigned(0,26);   -- reset count to zero
            clk_int := not clk_int;       -- invert clock variable every time counter resets
        end if;
            uSecClock <= clk_int;                 -- assign clock variable to internal clock signal
      end if; 
    end process;
    
    tSecClockGenerator: process(uSecClock,uSec,enable) 
    begin
        if enable = '0' then 
            tSecClock <= '0';
        elsif rising_edge(uSecClock) then
            if uSec = "0000" then 
                tSecClock <= '1';
            else 
                tSecClock <= '0';
            end if;
        end if;
    end process;
    
    uMinClockGenerator: process(uSec,tSec,uSecClock,enable) 
    begin
        if enable = '0' then 
            uMinClock <= '0';
        elsif rising_edge(uSecClock) then 
            if tSec = "0000" and uSec = "0000" then       
                uMinClock <= '1';
            else 
                uMinClock <= '0';
            end if;
        end if;
    end process;
    
    tMinClockGenerator: process(uSecClock,uMin,tSec,uSec,enable) 
        begin
            if enable = '0' then 
                tMinClock <= '0';
            elsif rising_edge(uSecClock) then 
                if uMin = "0000" and tSec = "0000" and uSec = "0000" then 
                    tMinClock <= '1';
                else 
                    tMinClock <= '0';
                end if;
            end if;
        end process;
        
    doneProcess: process(uSec,tSec,uMin,tMin,enable,uSecClock)
    begin
        if rising_edge(uSecClock) then
            if uSec = "0000" and tSec = "0000" and uMin = "0000" and tMin = "0000" then 
                if enable = '1' then 
                    done <= '1';
                    ledDone <= "1111111111111111";
                else 
                    done <= '0';
                end if;
            else
                done <= '0';
                ledDone <= "0000000000000000";
            end if;
        end if;
    end process;
        
    uSecCounter: downCounter port map(clk => uSecClock, reset => reset, enable => enable, data => uSecSet, Q => uSec);
    tSecCounter: downCounter port map(clk => tSecClock, reset => reset, enable => enable, data => tSecSet, Q => tSec);
    uMinCounter: downCounter port map(clk => uMinClock, reset => reset, enable => enable, data => uMinSet, Q => uMin);
    tMinCounter: downCounter port map(clk => tMinClock, reset => reset, enable => enable, data => tMinSet, Q => tMin);
    
    
    uSeconds <= uSec;
    tSeconds <= tSec;
    uMinutes <= uMin;
    tMinutes <= tMin;
end Behavioral;
