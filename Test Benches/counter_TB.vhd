----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2019 10:03:09
-- Design Name: 
-- Module Name: counter_TB - Behavioral
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

entity counter_TB is
--  Port ( );
end counter_TB;

architecture Behavioral of counter_TB is
component downCounter is
    Port ( set : in STD_LOGIC_VECTOR (11 downto 0);
           enable : in STD_LOGIC;
           clk_in: in STD_LOGIC;
           numberOut : out STD_LOGIC_VECTOR (11 downto 0));
end component;
signal set:std_logic_vector(11 downto 0); 
signal enable,clk_in: std_logic;
signal numberOut:std_logic_vector(11 downto 0); 

-- clock period - actual clock input is 100MHz (see just above the "Basys 3" logo on the board)
constant T_clk : time := 1000ms;
-- divided clock period (useful for specifying stimulus - short periods between changes)
constant sim_clk : time := 5 * T_clk;

-- number of clock cycles to simulate
constant n_cycles : integer := 10;

begin
DUT: downCounter port map (set=> set, enable=> enable,clk_in=> clk_in, numberOut=>numberOut);

   clk_gen : process
   begin
     
     while now <= (n_cycles*sim_clk) loop       
         clk_in <= '1'; wait for T_clk/2;
         clk_in <= '0'; wait for T_clk/2;
       end loop;
	wait;
   end process;
   stimuli: process 
   begin
    
    enable<= '0';
    set <="000000001111";wait for 100ms;
    enable<= '1';
   wait;
   end process;
end Behavioral;
