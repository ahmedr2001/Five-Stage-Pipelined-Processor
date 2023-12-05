library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
 generic (n : integer := 32);
  port (
        aluIn1, aluIn2  : IN signed     (n-1 Downto 0);
        func            : IN unsigned   (3 Downto 0);
        flagsIn         : IN unsigned   (2 Downto 0);
        flagsOut        : OUT unsigned  (2 Downto 0);
        aluOut          : OUT signed    (n-1 Downto 0)
    );
end entity;

architecture archALU of ALU is
    -- no operands operations
    constant ALU_NOP : unsigned(3 Downto 0) := x"0";
    -- one operands operations
    constant ALU_NOT : unsigned(3 Downto 0) := x"1";
    constant ALU_NEG : unsigned(3 Downto 0) := x"2";
    constant ALU_INC : unsigned(3 Downto 0) := x"3";
    constant ALU_DEC : unsigned(3 Downto 0) := x"4";
    -- play with one operand
    constant ALU_BITSET : unsigned(3 Downto 0) := x"5";
    constant ALU_RCL    : unsigned(3 Downto 0) := x"6";
    constant ALU_RCR    : unsigned(3 Downto 0) := x"7";
    -- two operands operations
    constant ALU_ADD : unsigned(3 Downto 0) := x"9";
    constant ALU_SUB : unsigned(3 Downto 0) := x"A"; -- aluIn1 - aluIn2
    constant ALU_AND : unsigned(3 Downto 0) := x"B";
    constant ALU_OR  : unsigned(3 Downto 0) := x"C";
    constant ALU_XOR : unsigned(3 Downto 0) := x"D";
    -- buffers
    constant ALU_BUFF1 : unsigned(3 Downto 0) := x"E"; -- same as SWAP => output = aluIn1
    constant ALU_BUFF2 : unsigned(3 Downto 0) := x"F";  -- output = aluIn2


    begin
        -- concurrent statements
        process (aluIn1, aluIn2, func, flagsIn) is
            variable CarryOnRight : signed(n downto 0) := (others => '0');
            variable CarryOnLeft : signed(n downto 0) := (others => '0');
            variable CarryO : signed(n downto 0) := (others => '0');
        begin
            -- main role
            -- main alu operation
            case func is
                when ALU_NOT =>
                    aluOut <= not aluIn1;
                when ALU_NEG =>
                    aluOut <= (0 - aluIn1);
                when ALU_INC =>
                    CarryOnLeft := aluIn1 + 1;
                    aluOut <= CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                when ALU_DEC =>
                    aluOut <= aluIn1 - 1; 
                    flagsOut(2) <= '1' when aluIn1 = "0" else '0'; -- C

                --- !! TODO: implement these operations
                when ALU_BITSET =>
                    flagsOut(2) <= aluIn1(to_integer(unsigned(aluIn2)));
                    aluOut <= (aluIn1 or (2 * aluIn2 )); 

                when ALU_RCL =>
                    CarryOnLeft(n-1 downto 0) := aluIn1(n-1 downto 0);
                    CarryOnLeft(n) := flagsIn(2);
                    CarryO := CarryOnLeft rol to_integer(unsigned(aluIn2));
                    
                    aluOut <= CarryO(n-1 downto 0);
                    flagsOut(2)    <= CarryO(n);
                    
                when ALU_RCR =>
                    CarryOnRight(n downto 1) := aluIn1(n-1 downto 0);
                    CarryOnRight(0) := flagsIn(2);
                    CarryO := CarryOnLeft ror to_integer(unsigned(aluIn2));

                    aluOut <= CarryO(n downto 1);
                    flagsOut(2)    <= CarryO(0);
                
                -- two operands
                -- TODO: check on flags
                when ALU_ADD =>
                    CarryOnLeft := signed(aluIn1) + signed(aluIn2);
                    aluOut   <= CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                    when ALU_SUB =>
                    CarryOnLeft := aluIn1 - aluIn2;
                    aluOut <= CarryOnLeft(n-1 downto 0);
                    flagsOut(2) <= CarryOnLeft(n); -- C
                when ALU_AND =>
                    aluOut <= aluIn1 and aluIn2;
                when ALU_OR =>
                    aluOut <= aluIn1 or aluIn2;
                when ALU_XOR =>
                    aluOut <= aluIn1 xor aluIn2;
                -- buffers
                when ALU_BUFF1 =>
                    aluOut <= aluIn1;
                when ALU_BUFF2 =>
                    aluOut <= aluIn2;
    
                -- unknown operation, NOP, or '-', 'z', 'x', etc => output = Z
                when others =>
                    aluOut <= (others => '0');

            end case;

            -- keep flags if NOP 
            -- !TODO: check if there's another operations that not affect flags
            if (func = ALU_NOP) then
                flagsOut <= flagsIn;
            else  
                flagsOut(0) <= '1' when aluOut = 0 else '0'; -- Z
                flagsOut(1) <= '1' when aluOut < 0 else '0'; -- N
            end if;

            

        end process;
end archALU ; -- archALU
