----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2019 11:48:55
-- Design Name: 
-- Module Name: display_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_tb is
--  Port ( );
end display_tb;

architecture Behavioral of display_tb is
component display is
     Port ( clk : in STD_LOGIC; --Basys 3 clock (100 MHz)
          tMinutes,tSeconds:in STD_LOGIC_VECTOR(2 downto 0);    --actual values for the tenths of minutes and seconds to be displayed
          uMinutes,uSeconds:in STD_LOGIC_VECTOR(3 downto 0);    --actual values for the units of minutes and seconds to be displayed
          ledAnode : out STD_LOGIC_VECTOR (3 downto 0);  --Dictates which 7 segment display to be ON at one time 
          ledOut : out STD_LOGIC_VECTOR (6 downto 0));  --Holds the value to be displayed on one 7 segment display
end component;
constant T_clk : time := 200ms;
-- divided clock period (useful for specifying stimulus - short periods between changes)
constant sim_clk : time := 8 * T_clk;
-- number of clock cycles to simulate
constant n_cycles : integer := 8;
signal clk: STD_LOGIC;
signal ledAnode : STD_LOGIC_VECTOR (3 downto 0);
signal ledOut : STD_LOGIC_VECTOR (6 downto 0);
signal tMinutes,tSeconds: STD_LOGIC_VECTOR(2 downto 0);   
signal uMinutes,uSeconds: STD_LOGIC_VECTOR(3 downto 0);
begin
DUT: display Port map(clk=>clk,tMinutes=>tMinutes,tSeconds=>tSeconds,uMinutes=>uMinutes,uSeconds=>uSeconds,ledAnode=>ledAnode,ledOut=>ledOut);
clk_gen : process
   begin     
     while now <= (n_cycles*sim_clk) loop       
         clk <= '1'; wait for T_clk/2;
         clk <= '0'; wait for T_clk/2;
       end loop;
	wait;
   end process;
stimuli:process
   begin
        tMinutes<= "000";
        uMinutes<= "0000";
        tSeconds<= "000";
        uSeconds<= "0000"; wait for 1000ms;
        tMinutes<= "001";
        uMinutes<= "0001";
        tSeconds<= "001";
        uSeconds<= "0001"; wait for 1000ms;
        tMinutes<= "010";
        uMinutes<= "0010";
        tSeconds<= "010";
        uSeconds<= "0010"; wait for 1000ms;
        tMinutes<= "011";
        uMinutes<= "0011";
        tSeconds<= "011";
        uSeconds<= "0011"; wait for 1000ms;
        tMinutes<= "100";
        uMinutes<= "0100";
        tSeconds<= "100";
        uSeconds<= "0100"; wait for 1000ms;
        tMinutes<= "101";
        uMinutes<= "0101";
        tSeconds<= "101";
        uSeconds<= "0101"; wait for 1000ms;
        tMinutes<= "101";
        uMinutes<= "0110";
        tSeconds<= "101";
        uSeconds<= "0110"; wait for 1000ms;
        tMinutes<= "101";
        uMinutes<= "0111";
        tSeconds<= "101";
        uSeconds<= "0111"; wait for 1000ms;
        tMinutes<= "101";
        uMinutes<= "1000";
        tSeconds<= "101";
        uSeconds<= "1000"; wait for 1000ms;
        tMinutes<= "101";
        uMinutes<= "1001";
        tSeconds<= "101";
        uSeconds<= "1001"; wait for 1000ms;
        tMinutes<= "110";
        uMinutes<= "1010";
        tSeconds<= "110";
        uSeconds<= "1010"; wait for 1000ms;
   wait;
   end process;

end Behavioral;
