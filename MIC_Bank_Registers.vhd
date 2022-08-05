LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;



ENTITY MIC_Banck_Registers IS
PORT (
	Reset		: IN std_logic;
	Clk		: IN std_logic;
	Enc		: IN std_logic;
	A_Address	: IN std_logic_vector(3 DOWNTO 0);
	B_Address	: IN std_logic_vector(3 DOWNTO 0);
	C_Address	: IN std_logic_vector(3 DOWNTO 0);
	C_Input		: IN std_logic_vector(15 DOWNTO 0);
	A_Output	: OUT std_logic_vector(15 DOWNTO 0);
	B_Output	: OUT std_logic_vector(15 DOWNTO 0));
END MIC_Banck_Registers;

ARCHITECTURE behavioral OF MIC_Banck_Registers IS

TYPE BANKREG is array(0 to 15) of STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL Bank_Register : BANKREG;

BEGIN

A_Output(15 DOWNTO 0) <= Bank_Register(conv_integer(A_Address(3 DOWNTO 0)))(15 DOWNTO 0);

B_Output(15 DOWNTO 0) <= Bank_Register(conv_integer(B_Address(3 DOWNTO 0)))(15 DOWNTO 0);


Write_Bank_Registe_Process : PROCESS (CLK, ENC, RESET)
	BEGIN
		IF RESET = '1' THEN
			Bank_Register(0) <= "0000000000000000"; -- PC Register
			Bank_Register(1) <= "0000000000000000"; -- AC Register
			Bank_Register(2) <= "0000000000000000"; -- SP Register
			Bank_Register(3) <= "0000000000000000"; -- IR Regisetr
			Bank_Register(4) <= "0000000000000000"; -- TIR Register
			Bank_Register(5) <= "0000000000000000"; -- Constant ZERO Register
			Bank_Register(6) <= "0000000000000001"; -- Constant +1 Register
			Bank_Register(7) <= "1111111111111111"; -- Constant -1 Register
			Bank_Register(8) <= "0000111111111111"; -- AMASK Register
			Bank_Register(9) <= "0000000011111111"; -- SMASK Register
			Bank_Register(10) <= "0000000000000000"; -- A Register
			Bank_Register(11) <= "0000000000000000"; -- B Register
			Bank_Register(12) <= "0000000000000000"; -- C Register
			Bank_Register(13) <= "0000000000000000"; -- D Register
			Bank_Register(14) <= "0000000000000000"; -- E Register
			Bank_Register(15) <= "0000000000000000"; -- F Register

			ELSIF ((CLK'event AND CLK = '1') AND (Enc = '1')) THEN
					IF C_Address = "0101" THEN
						Bank_Register(5) <= "0000000000000000";
						ELSIF C_Address = "0110" THEN
							Bank_Register(6) <= "0000000000000001";
								ELSIF C_Address = "0111" THEN
									Bank_Register(7) <= "1111111111111111";
										ELSIF C_Address = "1000" THEN
											Bank_Register(8) <= "0000111111111111";
												ELSIF C_Address = "1001" THEN
													Bank_Register(9) <= "0000000011111111";
														ELSE
															IF (ENC = '1') THEN
																Bank_Register(conv_integer(C_Address(3 DOWNTO 0))) <= C_Input(15 DOWNTO 0);
																	ELSE
																		Bank_Register(conv_integer(C_Address(3 DOWNTO 0))) <= Bank_Register(conv_integer(C_Address(3 DOWNTO 0)));
															END IF;
					END IF;
		END IF;
	END PROCESS Write_Bank_Registe_Process;

END behavioral;