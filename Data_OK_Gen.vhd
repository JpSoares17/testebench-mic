LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;



ENTITY Data_OK_Gen IS
PORT (
	Clk		: IN std_logic;
--	Reset		: IN std_logic;
--	MBR		: IN std_logic;
	RD		: IN std_logic;
	Data_Ok		: BUFFER std_logic := '0') ;	-- sinalk interno que habilita escrita no MBR a partir da memória q
END Data_OK_Gen;

Architecture behavioral OF Data_OK_Gen IS

--SIGNAL Int_Data_OK : std_logic := '0';

BEGIN

GEN : PROCESS (Clk)
Begin
	IF rising_edge(Clk) THEN
		IF (RD'stable) THEN
			Data_OK <= RD; --INT_Data_OK;
			ELSE
				Data_OK <= '0';
		END IF;
		ELSE
			Data_OK <= Data_OK;
	END IF;

End Process GEN;

END behavioral;