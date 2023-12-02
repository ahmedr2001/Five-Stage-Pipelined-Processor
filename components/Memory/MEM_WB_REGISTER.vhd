LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MEM_WB_REGISTER IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;

        ALU_OUT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_OUT : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_SRC_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        REG_ADDR1, REG_ADDR2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
        REG_WRITE_1, REG_WRITE_2 : IN STD_LOGIC;
        WB_SRC : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OUT_PORT_EN : IN STD_LOGIC;
        
        REG_ALU_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        REG_MEM_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        REG_ALU_SRC_2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        REG_ADDR1_REG, REG_ADDR2_REG : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        REG_WRITE_1_REG, REG_WRITE_2_REG : OUT STD_LOGIC;
        REG_WB_SRC : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        OUT_PORT_EN_REG : OUT STD_LOGIC
    );
END ENTITY MEM_WB_REGISTER;

ARCHITECTURE Behavioral OF MEM_WB_REGISTER IS

BEGIN
    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN
            -- Synchronous reset
            REG_ALU_OUT <= (OTHERS => '0');
            REG_MEM_OUT <= (OTHERS => '0');
            REG_ALU_SRC_2 <= (OTHERS => '0');
            REG_WB_SRC <= (OTHERS => '0');
            REG_ADDR1_REG <= (OTHERS => '0');
            REG_ADDR2_REG <= (OTHERS => '0');
            REG_WRITE_1_REG <= '0';
            REG_WRITE_2_REG <= '0';
        ELSIF RISING_EDGE(CLK) THEN
            -- Synchronous behavior
            REG_ALU_OUT <= ALU_OUT;
            REG_MEM_OUT <= MEM_OUT;
            REG_ALU_SRC_2 <= ALU_SRC_2;
            REG_WB_SRC <= WB_SRC;
            OUT_PORT_EN_REG <= OUT_PORT_EN;
            REG_ADDR1_REG <= REG_ADDR1;
            REG_ADDR2_REG <= REG_ADDR2;
            REG_WRITE_1_REG <= REG_WRITE_1;
            REG_WRITE_2_REG <= REG_WRITE_2;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;