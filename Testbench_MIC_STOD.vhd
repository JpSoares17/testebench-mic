LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE std.textio.ALL;

----------- Entidade do Testbench -------
ENTITY Testbench_MIC_STOD IS

END Testbench_MIC_STOD;

----------- Arquitetura do Testbench -------
ARCHITECTURE Type_1 OF Testbench_MIC_STOD IS

    CONSTANT Clk_period : TIME := 40 ns;
    SIGNAL Clk_count : INTEGER := 0;

    -- Declaração dos sinais (entrada e saída) que conectarão o projeto ao teste

    SIGNAL Signal_Clk : STD_LOGIC := '0';
    SIGNAL Signal_Reset : STD_LOGIC := '0';
    SIGNAL Signal_Amux : STD_LOGIC := '0';
    SIGNAL Signal_Alu : STD_LOGIC_VECTOR(1 DOWNTO 0):= "00";
    SIGNAL Signal_Mbr : STD_LOGIC := '0';
    SIGNAL Signal_Mar : STD_LOGIC := '0';
    SIGNAL Signal_Enc : STD_LOGIC := '0';
    SIGNAL Signal_C_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    --SIGNAL Signal_C_Input : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    --SIGNAL Signal_B_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_B_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_A_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    --SIGNAL Signal_A_Output : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_Sh : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL Signal_Mem_to_mbr : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_Data_ok : STD_LOGIC := '0';
    SIGNAL Signal_Mbr_to_mem : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    SIGNAL Signal_Mar_to_mem : STD_LOGIC_VECTOR(11 DOWNTO 0) := "000000000000";
    SIGNAL Signal_z : STD_LOGIC := '0';
    SIGNAL Signal_n : STD_LOGIC := '0';
    SIGNAL Signal_Rd :  STD_LOGIC := '0';
    SIGNAL Signal_Wr : STD_LOGIC := '0';
    SIGNAL Signal_Rd_Output :  STD_LOGIC := '0';
    SIGNAL Signal_Wr_Output : STD_LOGIC := '0';

-- INSTANCIAÇÃO --

    COMPONENT PROJETO_MIC is
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            AMUX : IN STD_LOGIC;
            ALU : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            MBR : IN STD_LOGIC;
            MAR : IN STD_LOGIC;
            RD : IN STD_LOGIC;
            WR : IN STD_LOGIC;
            ENC : IN STD_LOGIC;
            C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            SH : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            MEM_TO_MBR : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DATA_OK : IN STD_LOGIC;
            MBR_TO_MEM : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            MAR_OUTPUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            RD_OUTPUT : OUT STD_LOGIC;
            WR_OUTPUT : OUT STD_LOGIC;
            Z : OUT STD_LOGIC;
            N : OUT STD_LOGIC
				);
    END COMPONENT;

BEGIN

-- Instancia  o do projeto a ser testado
Dut : PROJETO_MIC

PORT MAP(
       CLK => Signal_Clk,
       RESET => Signal_Reset,
       AMUX => Signal_Amux,
       ALU => Signal_Alu,
       MBR => Signal_Mbr,
       MAR => Signal_Mar,
       RD => Signal_Rd,
       WR => Signal_Wr,
       ENC => Signal_Enc,
       C => Signal_C_Address,
       B => Signal_B_Address,
       A => Signal_A_Address,
       SH => Signal_Sh,
       MEM_TO_MBR => Signal_Mem_to_mbr,
       DATA_OK => Signal_Data_ok,
       MBR_TO_MEM => Signal_Mbr_to_mem,
       MAR_OUTPUT => Signal_Mar_to_mem,
       RD_OUTPUT => Signal_Rd_Output,
       WR_OUTPUT => Signal_Wr_Output,
       Z => Signal_z,
       N => Signal_n
);

-- Processo que define o rel gio. Faremos um rel gio de 40 ns
Clock_Process : PROCESS 
  Begin
    Signal_Clk <= '0';
    wait for Clk_period/2;  --for 0.5 ns signal is '0'.
    Signal_Clk  <= '1';
    Clk_count <= Clk_count + 1;
    wait for Clk_period/2;  --for next 0.5 ns signal is '1'.


IF (Clk_count = 34) THEN     
REPORT "Stopping simulation after 34 cycles";
    	  Wait;       
END IF;

End Process Clock_Process;

-- Processo que define o Reset. Subiremos o sinal de Reset em 10 ns. Manteremos este sinal com valor alto por mais trinta nanos segundo e voltaremos o Reset para zero
Reset_Process : PROCESS 
  Begin
    Signal_Reset <= '0';
    Wait for 10 ns;
    Signal_Reset <= '1';
    Wait for 30 ns;
    Signal_Reset <= '0';
    wait;

End Process Reset_Process;

STOD_Process : PROCESS
begin

  wait for 40 ns; 

  -- mbr := mem;
  
  Signal_Mem_to_mbr <= "0000000000000001"; -- intrucao
  Signal_Data_ok <= '1'; -- Habilita leitura de MBR

  wait for 40 ns;

  -- ac := mbr;

  Signal_Amux <= '1'; -- Com o mbr
  Signal_Alu <= "10"; -- Transparencia
  Signal_Sh <= "00"; -- Nao desloca
  Signal_Mbr <= '0';
  Signal_Mar <= '0';
  Signal_Rd <= '0';
  Signal_Wr <= '0';
  Signal_Enc <= '1'; -- Habilita gravação no registrador
  Signal_C_Address <= "0010"; 	-- Seleciona AC
  Signal_B_Address <= "0000";
  Signal_A_Address <= "0000";
  Signal_Data_ok <= '0';

  wait for 40 ns; 

    -- mbr := ac;

    Signal_Amux <= '0';
    Signal_Alu <= "10";
    Signal_Sh <= "00";
    Signal_Mbr <= '1';
    Signal_A_Address <= "0010";

  wait;

    wait;

END Process STOD_Process;

END Type_1;