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

architecture fsm_behavior of divider is
  type state is (idle, init, b_eq_1, main_loop, epilogue);
  signal current_s, next_s : state;
  signal a : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal b : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal q : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal a_c : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal b_c : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal q_c : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);

begin

  StateReg: process (start, clk) is
    if (start = '0') then
      current_s <= init;
    elsif (rising_edge(clk)) then
      current_s <= next_s;
      a <= a_c;
      b <= b_c;
      q <= q_c;
    end if;
  end process StateReg;

  CombProc: process (a, b, q, current_s) is
    variable p : integer;
    variable a_int, b_int, q_int : integer;
    variable sign_internal : std_logic;
  variable one : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (0 => '1', others => '0');
    begin
      a_c <= a;
      b_c <= b;
      q_c <= q;
      next_s <= current_s;
      case(current_s) is
        ----------------------idle---------
        when idle =>
          if (start = '0') then
            next_s <= init;
          end if;
          ---------------------init-----------
        when init =>
          if (b = 1) then
            next_s <= b_eq_1;
          else
            a_c <= std_logic_vector(abs(signed(divisor)));
            b_c <= std_logic_vector(abs(signed(dividend)));
            q_c <= (others=>'0');
            next_s <= main_loop;
          end if;
          ------------------beq1------------
          when b_eq_1 =>
            q_c <= a_c;
            next_s <= epilogue;
          ------------------main_loop----------
          when main_loop =>
            if (unsigned(b) /= 0 and unsigned(b) < unsigned(a)) then
              p := get_msb_pos(a)-get_msb_pos(b);
              if ((unsigned(b) SLL p) > unsigned(a)) then
                p := p-1;
              end if;
              q_c <= unsigned(q) + (unsigned(one) SLL p);
              a_c <= unsigned(a) - (unsigned(b) SLL p);
              next_s <= main_loop;
            else
              next_s <= epilogue;
            end if;
          ---------------epilogue----------
          when epilogue =>
            sign_internal := dividend(dividend'HIGH) xor divisor(divisor'HIGH);
            if (sign_internal = '1') then
              q_c <= std_logic_vector(-signed(q));
            end if;
            if (dividend(dividend'HIGH) = '1') then
              a_c <= std_logic_vector(-signed(a));
            end if;
      end case;
  end process CombProc;

end architecture fsm_behavior;
-----------------------------------------------------------------------------
