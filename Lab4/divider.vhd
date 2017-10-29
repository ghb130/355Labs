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
------------------------------------------------------------------------------
architecture fsm_behavior of divider is
  type state is (idle, init, b_eq_1, main_loop, epilogue);
  signal current_s, next_s : state;
  signal a : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal b : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal q : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal r : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal a_c : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal b_c : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal q_c : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal r_c : std_logic_vector(DIVISOR_WIDTH-1 downto 0);

begin

  StateReg: process (start, clk) is
    begin
    if (start = '0') then
      current_s <= init;
    elsif (rising_edge(clk)) then
      current_s <= next_s;
      a <= a_c;
      b <= b_c;
      q <= q_c;
      r <= r_c;
    end if;
  end process StateReg;

  CombProc: process (a, b, q, current_s) is
    variable p : integer;
    variable a_int, b_int, q_int : integer;
    variable sign_internal : std_logic;
    variable one : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (0 => '1', others => '0');
    begin
      a_c <= a;
      r_c <= r;
      b_c <= b;
      q_c <= q;
      next_s <= current_s;
      quotient <= q;
      remainder <= a(DIVISOR_WIDTH-1 downto 0);

      case(current_s) is
        ----------------------idle---------
        when idle =>
          if (start = '0') then
            next_s <= init;
          end if;
          ---------------------init-----------
        when init =>
          overflow <='0';
          a_c <= std_logic_vector(abs(signed(dividend)));
          b_c <= std_logic_vector(abs(signed(divisor)));
          q_c <= (others=>'0');
          r_c <= std_logic_vector(abs(signed(dividend(DIVISOR_WIDTH-1 downto 0))));

          if (to_integer(unsigned(divisor)) = 1) then
            next_s <= b_eq_1;
            a_c <= (others => '0');
          elsif (to_integer(unsigned(divisor)) = 0) then
            next_s <= b_eq_1;
            overflow <= '1';
            a_c <= (others => '0');
          else
            next_s <= main_loop;
          end if;
          ------------------beq1------------
        when b_eq_1 =>
          q_c <= dividend;
          next_s <= epilogue;
        ------------------main_loop----------
        when main_loop =>
          if (unsigned(b) /= 0 and unsigned(b) < unsigned(a)) then
            p := get_msb_pos(a)-get_msb_pos(b);
            if ((resize(unsigned(b),DIVIDEND_WIDTH) SLL p) > unsigned(a)) then
              p := p-1;
            end if;
            q_c <= std_logic_vector(unsigned(q) + (unsigned(one) SLL p));
            a_c <= std_logic_vector(to_signed((to_integer(unsigned(a)) - to_integer((resize(unsigned(b),DIVIDEND_WIDTH) SLL p))),DIVIDEND_WIDTH));
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
          next_s <= idle;
      end case;
  end process CombProc;

end architecture fsm_behavior;
-----------------------------------------------------------------------------
