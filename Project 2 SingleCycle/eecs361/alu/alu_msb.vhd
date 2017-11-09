library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity alu_msb is
  port (
        A : in std_logic;
        B : in std_logic;
        B_negate : in std_logic;
        carryin : in std_logic;
        less : in std_logic;
        op : in std_logic_vector(3 downto 0);
        carryout : out std_logic;
        set : out std_logic;
        overflow : out std_logic;
        result : out std_logic
  );
end entity alu_msb;

architecture structural of alu_msb is

  component full_adder is
    port(
         A : in std_logic;
         B : in std_logic;
         cin : in std_logic;
         cout : out std_logic;
         sum : out std_logic
    );
  end component;

  component not_gate is
    port (
          x : in  std_logic;
          z : out std_logic
    );
  end component;

  component mux is
    port (
          sel : in	std_logic;
          src0 : in	std_logic;
          src1 : in	std_logic;
          z	: out std_logic
    );
  end component;

  component and_gate is
    port (
      x   : in  std_logic;
      y   : in  std_logic;
      z   : out std_logic
    );
  end component;

  component xor_gate is
    port (
      x   : in  std_logic;
      y   : in  std_logic;
      z   : out std_logic
    );
  end component;

  component or_gate is
    port (
      x   : in  std_logic;
      y   : in  std_logic;
      z   : out std_logic
    );
  end component;

  signal sum_sig : std_logic;
  signal sum_inv : std_logic;
  signal and_sig : std_logic;
  signal or_sig : std_logic;
  signal xor_sig : std_logic;
  signal slt_sig : std_logic;
  signal sltu_sig : std_logic;
  signal B_inv : std_logic;
  signal B_sel : std_logic;
  signal M1_sig : std_logic;
  signal M2_sig : std_logic;
  signal M3_sig : std_logic;
  signal M4_sig : std_logic;
  signal M5_sig : std_logic;
  signal M6_sig : std_logic;
  signal inv_sel : std_logic;
  signal carryout_sig : std_logic;
  signal overflow_sig : std_logic;
  begin
    N0 : not_gate port map(x=>B, z=>B_inv);
    M0 : mux port map(sel=>B_negate, src0=>B, src1=>B_inv, z=>B_sel);
    FA : full_adder port map(cin=>carryin, A=>A, B=>B_sel, cout=>carryout_sig, sum=>sum_sig);
    A0 : and_gate port map(x=>A, y=>B, z=>and_sig);
    O0 : or_gate port map(x=>A, y=>B, z=>or_sig);
    X0 : xor_gate port map(x=>A, y=>B, z=>xor_sig);

    M1 : mux port map(sel=>op(0), src0=>sum_sig, src1=>sum_sig, z=>M1_sig);
    M2 : mux port map(sel=>op(0), src0=>and_sig, src1=>xor_sig, z=>M2_sig);
    M3 : mux port map(sel=>op(0), src0=>or_sig, src1=>less, z=>M3_sig);
    M4 : mux port map(sel=>op(0), src0=>less, src1=>less, z=>M4_sig);
    M5 : mux port map(sel=>op(1), src0=>M1_sig, src1=>M2_sig, z=>M5_sig);
    M6 : mux port map(sel=>op(1), src0=>M3_sig, src1=>M4_sig, z=>M6_sig);
    M7 : mux port map(sel=>op(2), src0=>M5_sig, src1=>M6_sig, z=>result);    -- 5 way mux

    X_OFL : xor_gate port map(x=>carryin, y=>carryout_sig, z=>overflow_sig);
----slt/sltu----
    SLT_not : not_gate port map(x=>sum_sig, z=>sum_inv);
    SLT : mux port map(sel=>overflow_sig, src0=>sum_sig, src1=>sum_inv, z=>slt_sig);   -- find set of slt op
    SLTU_not : not_gate port map(x=>carryout_sig, z=>sltu_sig);                        -- set for sltu = not(cout)
    SLT_SEL : mux port map(sel=>op(0), src0=>sltu_sig, src1=>slt_sig, z=>set);         -- choose appropriate set
    
    carryout<=carryout_sig;
    overflow<=overflow_sig;

  end architecture structural;
