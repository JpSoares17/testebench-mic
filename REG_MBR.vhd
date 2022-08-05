LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;



ENTITY REG_MBR IS
PORT (
	Clk		: IN std_logic;
	Reset		: IN std_logic;
	MBR		: IN std_logic;			     -- habilitação de escrita de C_BUS no MBR (vem da unidade de controle)
	WR		: IN std_logic;			     -- Sinaliza a laitura da memória, resultando em escrita do dado vindo da memória em MBR
	C_BUS		: IN std_logic_vector(15 downto 0);  -- Entrada do barramento C no MBR
	MEM_TO_MBR	: IN std_logic_vector(15 downto 0);  -- Entrada da memória no MBR

	MBR_TO_MEM	: OUT std_logic_vector(15 downto 0);  -- Saída do MBR para a memória
	MBR_Input	: OUT std_logic_vector(15 downto 0));  -- Saída do MBR para o AMUX

END REG_MBR;

Architecture behavioral OF REG_MBR IS

SIGNAL REG_MBR_Out : std_logic_vector(15 downto 0); -- Ponto memorizante de saida para a memória

SIGNAL REG_MBR_In : std_logic_vector(15 downto 0);  -- Ponto memorizante de entrada da memória

SIGNAL  DATA_Ok	: std_logic := '0'; -- habilitação de escrita de MEM_TO_MBR no registrador MBR

BEGIN

MBR_Out_Process : PROCESS (Clk, Reset)
BEGIN
	IF Reset = '1' THEN
		REG_MBR_Out <= "0000000000000000";
		
		ELSIF (rising_edge(Clk) AND MBR = '1') THEN
				REG_MBR_Out <= C_BUS;
		ELSE
			REG_MBR_Out <= REG_MBR_Out;
	END IF;
End Process MBR_Out_Process;


MBR_In_Process : PROCESS (Clk, Reset)
BEGIN
	IF Reset = '1' THEN
		REG_MBR_IN <= "0000000000000000";
		
		ELSIF (rising_edge(Clk) AND (DATA_Ok = '1')) THEN
			REG_MBR_In <= MEM_TO_MBR;
			ELSE
				REG_MBR_In <= REG_MBR_In;
	END IF;
End Process MBR_In_Process;


-- Insirer descrição deste processo
GEN_DATA_OK : PROCESS (Clk)
Begin
	IF rising_edge(Clk) THEN
		IF (WR'stable) THEN
			Data_OK <= WR; -- Na segunda subida do relógio com MBR = 1, DATA_Ok será levado a '1' 
			ELSE
				Data_OK <= '0'; -- Evita setar DATA_Ok na primeira subida, pois MBR não está estável
		END IF;
		ELSE
			Data_OK <= Data_OK; -- Efeito memõria. Não escreve fora da subida domnrelógio
	END IF;

End Process GEN_DATA_OK;

END behavioral;