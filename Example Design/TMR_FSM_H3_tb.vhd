----------------------------------------------------------------------------------
-- Company:         KIT Campus Nord/IPE
-- Engineer:        Tobias Markus
-- 
-- Create Date: 03.06.2013 09:32:12
-- Design Name: 
-- Module Name: TMR - Behavioral
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
use WORK.TMR_FSM_pack.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TMR_FSM_tb is
end TMR_FSM_tb;

architecture Behavioral of TMR_FSM_tb is

signal CLK_tb 			: clk_type:=('0','0','0');
signal RST_tb 			: rst_type:=('0','0','0');
signal DATA_IN_TMR_tb	: data_in_type;
signal Trig_tb			: trig_type;
constant Period : time := 20 ns;

component TMR_FSM is
    port(
        CLK             : in clk_type;
        RST             : in rst_type;
        DATA_IN_TMR     : in data_in_type;
        Trig_IO         : out trig_type
    );
end component;

begin

DUT:TMR_FSM
port map(
		CLK             => CLK_tb,
        RST             => RST_tb,
        DATA_IN_TMR     => DATA_IN_TMR_tb,
        Trig_IO         => Trig_tb
);

CLKGEN:process
begin
	CLK_tb(0) <= not CLK_tb(0);
	CLK_tb(1) <= not CLK_tb(1);
	CLK_tb(2) <= not CLK_tb(2);
	wait for Period/2.0;
end process;

Test:process
begin
	RST_tb <= ('0','0','0');
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
end process;

end Behavioral;
----------------------------------------------------------------------------------
-- Company:         KIT Campus Nord/IPE
-- Engineer:        Tobias Markus
-- 
-- Create Date: 03.06.2013 09:32:12
-- Design Name: 
-- Module Name: TMR - Behavioral
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
use WORK.TMR_FSM_H3_pack.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TMR_FSM_H3_tb is
end TMR_FSM_H3_tb;

architecture Behavioral of TMR_FSM_H3_tb is

signal CLK_tb 			: clk_type:=('0','0','0');
signal RST_tb 			: rst_type:=('0','0','0');
signal DATA_IN_TMR_tb	: data_in_type;
signal Trig_tb			: trig_type;
constant Period : time := 20 ns;

component TMR_FSM_H3 is
    port(
        CLK             : in clk_type;
        RST             : in rst_type;
        DATA_IN_TMR     : in data_in_type;
        Trig_IO         : out trig_type
    );
end component;

begin

DUT:TMR_FSM_H3
port map(
		CLK             => CLK_tb,
        RST             => RST_tb,
        DATA_IN_TMR     => DATA_IN_TMR_tb,
        Trig_IO         => Trig_tb
);

CLKGEN:process
begin
	CLK_tb(0) <= not CLK_tb(0);
	CLK_tb(1) <= not CLK_tb(1);
	CLK_tb(2) <= not CLK_tb(2);
	wait for Period/2.0;
end process;

Test:process
begin
	RST_tb <= ('0','0','0');
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('0','0','0');
	wait for Period;
	DATA_IN_TMR_tb 	<= ('1','1','1');
	wait for Period;
end process;

end Behavioral;
