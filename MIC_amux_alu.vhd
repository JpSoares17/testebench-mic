LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;



ENTITY MIC_amux_alu IS
PORT (
	amux		: IN std_logic;
	alu		: IN std_logic_vector(1 DOWNTO 0);
	sh		: IN std_logic_vector(1 DOWNTO 0);
	A_Input		: IN std_logic_vector(15 DOWNTO 0);
	B_Input		: IN std_logic_vector(15 DOWNTO 0);
	MBR_Input	: IN std_logic_vector(15 DOWNTO 0);
	N		: OUT std_logic;
	Z		: OUT std_logic;
	SH_Output	: OUT std_logic_vector(15 DOWNTO 0));
END MIC_amux_alu;

Architecture behavioral OF MIC_amux_alu IS

SIGNAL Input_A		: std_logic_vector(15 DOWNTO 0);
SIGNAL ALU_Output	:  std_logic_vector(15 DOWNTO 0);

BEGIN

WITH AMUX SELECT
	Input_A <= A_Input(15 DOWNTO 0) WHEN '0',
		   MBR_Input(15 DOWNTO 0) WHEN OTHERS;

WITH ALU_Output SELECT
Z <= '1' WHEN "0000000000000000",
     '0' WHEN OTHERS;

N <= ALU_Output(15);

WITH ALU SELECT
	ALU_Output <= Input_A(15 DOWNTO 0) + B_Input(15 DOWNTO 0)   WHEN "00",
	              Input_A(15 DOWNTO 0) AND B_Input(15 DOWNTO 0) WHEN "01",
		      Input_A(15 DOWNTO 0)                     WHEN "10",
		      NOT Input_A(15 DOWNTO 0)                 WHEN OTHERS;
				
 
WITH SH SELECT
	SH_Output <= ALU_Output(15 DOWNTO 0) WHEN "00",
	             ALU_Output(14 DOWNTO 0) & '0' WHEN "01",
                     '0' & ALU_Output(15 DOWNTO 1) WHEN "10",
	             ALU_Output(15 DOWNTO 0) WHEN OTHERS;

END behavioral;