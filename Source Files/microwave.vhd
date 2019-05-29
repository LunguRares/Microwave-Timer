----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2019 12:20:18
-- Design Name: 
-- Module Name: microwave - Behavioral
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

entity microwave is
  Port (clk,startButton: in STD_LOGIC;
        uSecSwitch,uMinSwitch,tSecSwitch,tMinSwitch:in STD_LOGIC_VECTOR(3 downto 0);
        ledDone:out STD_LOGIC_VECTOR(15 downto 0);
        anode: out STD_LOGIC_VECTOR (3 downto 0);
        segs: out STD_LOGIC_VECTOR (6 downto 0));
end microwave;

architecture Behavioral of microwave is
signal enable,reset,done:STD_LOGIC;
signal uSec,tSec,uMin,tMin:STD_LOGIC_VECTOR(3 downto 0);

component display is
    Port ( clk: in STD_LOGIC;
           tMinutes,uMinutes,tSeconds,uSeconds : in STD_LOGIC_VECTOR (3 downto 0);
           anode : out STD_LOGIC_VECTOR (3 downto 0);
           segs : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component dCountModule is
  Port (clk,reset,enable:in STD_LOGIC; 
        uSecSet,tSecSet,uMinSet,tMinSet:in STD_LOGIC_VECTOR(3 downto 0);
        done: out STD_LOGIC;
        ledDone :out STD_LOGIC_VECTOR(15 downto 0);
        uSeconds,tSeconds,uMinutes,tMinutes:out STD_LOGIC_VECTOR(3 downto 0));
end component;

begin
    start: process(startButton,done,uSecSwitch,tSecSwitch,uMinSwitch,tMinSwitch)
    variable status: std_logic := '0'; --status = 1 // microwave counting down 
        begin
            if startButton = '0' and done = '0' then
                if status = '1' then
                    enable <= '1';
                else
                    enable <= '0'; 
                    reset <='0';
                end if;
            end if;
            if startButton = '0' and done = '1' then
               status:= '1';
               enable <= '0'; 
               reset <='1';
            end if;
            if startButton = '1' and done = '0' and uSecSwitch < "1010" and tSecSwitch < "0110" and uMinSwitch < "1010" and tMinSwitch < "0110" then
                    enable <= '1'; 
                    reset <='0';
                    status:= '1';
            end if;
            if startButton = '1' and done = '1' then
               enable <= '0'; 
               reset <='1';
            end if;
        end process;
    
    segsDisplay: display port map(clk => clk, tMinutes => tMin, uMinutes => uMin, tSeconds => tSec, uSeconds => uSec, anode => anode, segs => segs);
    count: dCountModule port map(clk => clk, reset => reset, enable => enable, uSecSet => uSecSwitch, tSecSet => tSecSwitch, 
                                 uMinSet => uMinSwitch, tMinSet => tMinSwitch, done => done, ledDone => ledDone,
                                 uSeconds => uSec, tSeconds => tSec, uMinutes => uMin, tMinutes => tMin);
end Behavioral;
