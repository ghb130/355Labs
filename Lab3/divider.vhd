-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.divider_const.all;
--Additional standard or custom libraries go here
entity divider is
    port(
      --Inputs
      -- clk : in std_logic;
      --COMMENT OUT clk signal for Part A.
      clk: in std_logic;
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
  type remMemory is array(0 to DIVIDEND_WIDTH-1) of std_logic_vector(DIVISOR_WIDTH downto 0);
  signal remMem: remMemory;
  signal intDividend: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal intDivisor:  std_logic_vector (DIVISOR_WIDTH - 1 downto 0);

  COMPONENT comparator is
    port(
        DINL : in std_logic_vector (DIVISOR_WIDTH downto 0); -- current portion of dividend
        DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- divisor
        DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);  -- This should probably be DATA_WIDTH downto 0
        isGreaterEq : out std_logic
      );
  end COMPONENT;

  begin
    overflow <= '1' when unsigned(divisor) = 0 else '0';
    intDivisor <= divisor when start = '0'; --potential issues with no default values
    intDividend <= dividend when start = '0';
    Slice: FOR i in 0 to DIVIDEND_WIDTH - 1 GENERATE begin
        FirstSlice: if i = 0 GENERATE begin
          remMem(i) <= (0 => intDividend((DIVIDEND_WIDTH-1) - i), others => '0');
          firstComp: comparator
            port map(remMem(i), intDivisor, remMem(i+1)(DIVISOR_WIDTH downto 1), quotient((DIVIDEND_WIDTH-1)-i));
        end GENERATE;
        MiddleSlice: if i > 0 AND i < DIVIDEND_WIDTH - 1 GENERATE begin
          remMem(i)(0) <= intDividend((DIVIDEND_WIDTH-1) - i);
          middleComp: comparator
            port map(remMem(i), intDivisor, remMem(i+1)(DIVISOR_WIDTH downto 1), quotient((DIVIDEND_WIDTH-1)-i));
        end GENERATE;
        EndSlice: if i = DIVIDEND_WIDTH - 1 GENERATE begin
          remMem(i)(0) <= intDividend((DIVIDEND_WIDTH-1) - i);
          middleComp: comparator
            port map(remMem(i), intDivisor, remainder, quotient((DIVIDEND_WIDTH-1)-i));
        end GENERATE;
    end GENERATE;
end architecture structural_combinational;
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
architecture behavioral_sequential of divider is
  signal intDividend: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal intDivisor:  std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
  signal DINL : std_logic_vector (DIVISOR_WIDTH downto 0);
  signal DOUT : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
  signal isGreaterEq : std_logic;
  signal countout : integer;

  COMPONENT comparator is
    port(
        DINL : in std_logic_vector (DIVISOR_WIDTH downto 0); -- current portion of dividend
        DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- divisor
        DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);  -- This should probably be DATA_WIDTH downto 0
        isGreaterEq : out std_logic
      );
  end COMPONENT;

  begin
    comp: comparator port map(
                    DINL=>DINL,
                    DINR=>intDivisor,
                    DOUT=>DOUT,
                    isGreaterEq=>isGreaterEq
                    );

    clocked_process: process(clk) is
      variable count: integer:= -1;
      variable flag: boolean:=false;
      variable varQ: std_logic_vector (DIVIDEND_WIDTH downto 0);
      begin

        if(rising_edge(clk)) then
          if(unsigned(intDivisor)=0) then
            overflow <= '1';
          else
            overflow <= '0';
          end if;

          if(start = '0' and flag = false) then
            flag := true;
            intDivisor <= divisor;
            intDividend <= dividend;
            count := -1;
            quotient <= (others => '0');
          end if;

          if(count=-1) then
            DINL <= (others => '0');
            count:=count+1;
          elsif (count < DIVIDEND_WIDTH) then
            DINL(DIVISOR_WIDTH downto 1) <= DOUT;
            DINL(0) <= intDividend((DIVIDEND_WIDTH-1)-count);
            count:=count+1;
          else
            flag := false;
            quotient <= varQ(DIVIDEND_WIDTH-1 downto 0);
          end if;
        end if;

        if(falling_edge(clk) and count >= 0) then
          remainder <= DOUT;
          varQ((DIVIDEND_WIDTH)-count) := isGreaterEq;
        end if;
    end process clocked_process;


end architecture behavioral_sequential;
-----------------------------------------------------------------------------
