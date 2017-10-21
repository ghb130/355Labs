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
  signal intDividend: std_logic_vector (DIVIDEND_WIDTH - 1 downto 0) := (others => '0');
  signal intDivisor:  std_logic_vector (DIVISOR_WIDTH - 1 downto 0) := (others => '0');
  signal intRegIn, intRegOut: std_logic_vector (DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto 0) := (others => '0');
  signal we: std_logic := '0';

  COMPONENT comparator is
    port(
        DINL : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- current portion of dividend
        DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- divisor
        DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);  -- This should probably be DATA_WIDTH downto 0
        isGreaterEq : out std_logic
      );
  end COMPONENT;

  COMPONENT reg_n is
    generic(n: integer);
    port(
      din : in std_logic_vector(n downto 0);
      we : in std_logic;
      clk : in std_logic;
      dout : out std_logic_vector(n downto 0)
    );
  end COMPONENT;

  begin
    comp: comparator port map(
                    DINL=>intRegOut(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVIDEND_WIDTH),
                    DINR=>intDivisor,
                    DOUT=>intRegIn(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVIDEND_WIDTH),
                    isGreaterEq=>intRegIn(0)
                    );
    reg: reg_n generic map (n=>DIVIDEND_WIDTH+DIVISOR_WIDTH)
                    port map (
                    din=> intRegIn,
                    we=> we,
                    clk=> clk,
                    dout=> intRegOut
                    );

    overflow <= '1' when unsigned(divisor) = 0 else '0';
    intDivisor <= divisor when start = '0'; --potential issues with no default values
    intDividend <= dividend when start = '0';
    quotient <= intRegOut(DIVIDEND_WIDTH-1 downto 0);
    remainder<= intRegOut(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVIDEND_WIDTH);

    clocked_process: process(clk,start) is
      variable count: integer:= 0;
      variable flag: boolean:=false;
      begin
        if(count <= DIVIDEND_WIDTH) then
          we <= '1';
        else
          we <= '0';
          flag := false;
        end if;

        if(start = '0' and flag = false) then
          count := 0;
          flag := true;
        end if;

        if(rising_edge(clk)) then
          if(count=0) then
            intRegIn(DIVIDEND_WIDTH-1 downto 0)<=intDividend;
            intRegIn(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVIDEND_WIDTH) <= (others => '0');
            count:=count+1;
          else
            intRegIn <= std_logic_vector(unsigned(intRegIn) SLL 1);
            count:=count+1;
          end if;
        end if;
    end process clocked_process;


end architecture behavioral_sequential;
-----------------------------------------------------------------------------
