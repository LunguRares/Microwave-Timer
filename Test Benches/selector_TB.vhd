----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2019 11:52:22
-- Design Name: 
-- Module Name: selector_TB - Behavioral
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

entity selector_TB is
--  Port ( );
end selector_TB;

architecture Behavioral of selector_TB is
component selector is
    Port ( bUp ,bDown,bEn,switch,reset,clk_in: in STD_LOGIC;
           numToDisplay: out STD_LOGIC_VECTOR(11 downto 0);
           tMinutes,tSeconds:out STD_LOGIC_VECTOR(2 downto 0);
           uMinutes,uSeconds:out STD_LOGIC_VECTOR(3 downto 0));
end component;
signal bUp,bDown,bEn,switch,reset,clk_in:STD_LOGIC;
signal numToDisplay : STD_LOGIC_VECTOR(11 downto 0);
signal tMinutes,tSeconds: STD_LOGIC_VECTOR(2 downto 0);
signal uMinutes,uSeconds: STD_LOGIC_VECTOR(3 downto 0);
-- clock period - actual clock input is 100MHz (see just above the "Basys 3" logo on the board)
constant T_clk : time := 1000ms;
-- divided clock period (useful for specifying stimulus - short periods between changes)
constant sim_clk : time := 5 * T_clk;
-- number of clock cycles to simulate
constant n_cycles : integer := 20;

begin
DUT: selector port map (bUp=> bUp, bDown=> bDown,bEn=> bEn, switch=>switch,reset=>reset,clk_in=>clk_in,numToDisplay=>numToDisplay,tMinutes=>tMinutes,tSeconds=>tSeconds,uMinutes=>uMinutes,uSeconds=>uSeconds);
 clk_gen : process
   begin     
     while now <= (n_cycles*sim_clk) loop       
         clk_in <= '0'; wait for T_clk/2;
         clk_in <= '1'; wait for T_clk/2;
       end loop;
	wait;
   end process;
stimuli:process
begin
bEn<='0';
bUp<='0';
switch<='0';
reset<= '0'; wait for 1000ms;
reset<= '1'; wait for 1000ms;
reset<= '0'; wait for 1000ms;
for I in 0 to 120 loop
	bUp<='0';wait for 50ms;
    bUp<='1';wait for 50ms;
	end loop;
wait;
end process;

end Behavioral;
