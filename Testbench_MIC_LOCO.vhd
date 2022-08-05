LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE std.textio.ALL;

----------- Entidade do Testbench -------
ENTITY Testbench_MIC_LOCO IS

END Testbench_MIC_LOCO;

----------- Arquitetura do Testbench -------
ARCHITECTURE Type_1 OF Testbench_MIC_LOCO IS

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
    SIGNAL Signal_B_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL Signal_A_Address : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
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

IF (Clk_count = 10) THEN     
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

--    LOCO PROCESS
--O:  mar := pc; rd;
--1:  pc := pc + 1; rd;
--2:  ir := mbr; ir n then goto 28;
--3:  tir := lshift (ir + ir); if n then goto 19;
--19: tir := lshift (tir); if n then goto 25;
--25: alu := tir; if n then goto 27;
--27: ac := band (ir, amask); goto 0;

LOCO_Process : PROCESS
    Begin   

    wait for 40 ns; -- mbr := x;

    Signal_Mem_to_mbr <= "0111000000000111"; -- Instrução
    Signal_Data_ok <= '1'; -- Habilita a leitura do MBR 

    wait for 40 ns; -- ir := mbr;

    Signal_C_Address <= "0011"; -- Seleciona o registrador IR
    Signal_Amux <= '1'; -- Amux seleciona o valor de MBR 
    Signal_Alu <= "10"; -- Operação de transparência
    Signal_Sh <= "00"; -- Não desloca o resultado da ALU
    Signal_Enc <= '1'; -- Habilita gravação 

    wait for 40 ns; -- ac := band (ir, amask);

    Signal_C_Address <= "0001"; -- Seleciona AC
    Signal_B_Address <= "0011"; -- Seleciona IR
    Signal_A_Address <= "1000"; -- Seleciona AMASK
    Signal_Amux <= '0'; -- Seleciona o barramento A
    Signal_Alu <= "01"; -- Operação AND
    Signal_Sh <= "00"; -- Não deslocará o resultado
    Signal_Enc <= '1'; -- Habilita gravação


    wait for 40 ns; -- mbr := ac;
    
    Signal_Amux <= '0'; -- Seleciona o barramento A
    Signal_Alu <= "10"; -- Transparência
    Signal_Sh <= "00"; -- Não deslocará o resultado 
    Signal_Mbr <= '1'; -- Carrega o MBR
    Signal_Enc <= '0'; -- Desabilita a gravação
    Signal_A_Address <= "0001"; -- Seleciona AC

    wait;

End Process LOCO_Process;



END Type_1;
