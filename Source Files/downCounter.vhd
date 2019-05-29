----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2019 11:49:41
-- Design Name: 
-- Module Name: NineDownCounter - Behavioral
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

entity downCounter is
Port (clk,reset,enable: in STD_LOGIC;
       data:in STD_LOGIC_VECTOR(3 downto 0);
       Q : out STD_LOGIC_VECTOR(3 downto 0));
end downCounter;

architecture arch5 of downCounter is
begin
    count:process(clk,reset,enable)
    variable REG: unsigned(3 downto 0):= "0000";
    begin
        if reset= '1' then
            REG:= "0000";
        elsif enable = '0' then 
            if unsigned(data) < "0110" then
                REG:= unsigned(data);
            else
                REG:= "1110";
            end if;
        elsif rising_edge(clk) then
            if REG ="0000" then
                REG := "0101";
            else
                REG:= REG - 1;
            end if;
        end if;
        Q <= STD_LOGIC_VECTOR(REG);
    end process;
end arch5;

architecture arch9 of downCounter is
begin
    count:process(clk,reset,enable)
    variable REG: unsigned(3 downto 0):= "0000";
    begin
        if reset= '1' then
            REG:= "0000";
        elsif enable = '0' then 
            if unsigned(data) < 10 then
                REG:= unsigned(data);
            else
                REG:= "1110";
            end if;
        elsif rising_edge(clk) then
            if REG ="0000" then
                REG := "1001";
            else
                REG:= REG - 1;
            end if;
        end if;
        Q <= STD_LOGIC_VECTOR(REG);
    end process;
end arch9;
