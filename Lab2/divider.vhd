-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
--Additional standard or custom libraries go here
entity divider is
    port(
      --Inputs
      -- clk : in std_logic;
      --COMMENT OUT clk signal for Part A.
      start : in std_logic;
      dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
      divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
      --Outputs
      quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
      remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
      overflow : out std_logic
    );
end entity divider;
architecture structural_combinational of divider is
  type remMemory is array(0 to DIVIDEND_WIDTH - 1) of std_logic_vector(DIVISOR_WIDTH downto 0);
  variable remMem: remMemory;
  signal intDividend: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal intDivisor:  std_logic_vector (DIVISOR_WIDTH - 1 downto 0);

  COMPONENT comparator is
    port(
        DINL : in std_logic_vector (DATA_WIDTH downto 0); -- current portion of dividend
        DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0); -- divisor
        DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);  -- This should probably be DATA_WIDTH downto 0
        isGreaterEq : out std_logic;
        overflow: out std_logic
      );
  end COMPONENT;

  begin
    intDivisor <= divisor when start = '1';
    intDividend <= dividend when start = '1';
    map: process(start, dividend, divisor)
      loop: FOR i in 0 to DIVIDEND_WIDTH - 1 GENERATE begin
          FirstSlice: if i = 0 GENERATE begin
            remMem(i) := remMem(i) OR
            firstComp: comparator
              port map();
          end GENERATE;
      end GENERATE;
    end process map;
end architecture structural_combinational;
-----------------------------------------------------------------------------
