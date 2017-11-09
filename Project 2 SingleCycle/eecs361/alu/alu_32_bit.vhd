library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity alu_32_bit is
  port (
        A_32 : in std_logic_vector(31 downto 0);
        B_32 : in std_logic_vector(31 downto 0);
        op_32 : in std_logic_vector(3 downto 0);
        cout_32 : out std_logic;
        overflow_32 : out std_logic;
        zero_32 : out std_logic;
        result_32 : out std_logic_vector(31 downto 0)
  );
end entity alu_32_bit;

architecture structural of alu_32_bit is
  component alu_msb is
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
  end component;

  component alu_one_bit is
    port (
          A : in std_logic;
          B : in std_logic;
          B_negate : in std_logic;
          carryin : in std_logic;
          less : in std_logic;
          op : in std_logic_vector(3 downto 0);
          carryout : out std_logic;
          result : out std_logic
    );
  end component;

  component shift_rl32 is
    port (
          din : in std_logic_vector(31 downto 0);
          samt : in std_logic_vector(4 downto 0);
          dout : out std_logic_vector(31 downto 0)
    );
  end component;

  component shift_ll32 is
    port (
          din : in std_logic_vector(31 downto 0);
          samt : in std_logic_vector(4 downto 0);
          dout : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux_n is
    generic (
  	         n	: integer
            );
    port (
  	       sel	  : in	std_logic;
  	       src0  :	in	std_logic_vector(n-1 downto 0);
  	       src1  :	in	std_logic_vector(n-1 downto 0);
  	       z	  : out std_logic_vector(n-1 downto 0)
         );
  end component;

  signal cout_sig : std_logic_vector(30 downto 0);
  signal ALUout : std_logic_vector(31 downto 0);
  signal set0 : std_logic;
  signal srl_out : std_logic_vector(31 downto 0);
  signal sll_out : std_logic_vector(31 downto 0);
  signal M0_out : std_logic_vector(31 downto 0);
  signal inv_sel : std_logic;
  signal or_zf_out0 : std_logic;
  type s_arr is array(0 to 3) of std_logic_vector(15 downto 0);
  signal z_zero : s_arr;
  signal result_32_sig : std_logic_vector(31 downto 0);

  begin
    O_SUB : or_gate port map(x=>op_32(0), y=>op_32(2), z=>inv_sel);   -- want adder to do subtraction for sub and slt(u)
    ALUs : for i in 0 to 31 generate
      alu_first : if i = 0 generate
        ALU0 : alu_one_bit
        port map(A=>A_32(i), B=>B_32(i), B_negate=>inv_sel, carryin=>inv_sel, less=>set0, op=>op_32, carryout=>cout_sig(i), result=>ALUout(i));
      end generate;
      alu_middle : if i > 0 and i < 31 generate
        ALUi : alu_one_bit
        port map(A=>A_32(i), B=>B_32(i), B_negate=>inv_sel, carryin=>cout_sig(i-1), less=>'0', op=>op_32, carryout=>cout_sig(i), result=>ALUout(i));
      end generate;
      alu_last : if i = 31 generate
        ALU31 : alu_msb
        port map(A=>A_32(i), B=>B_32(i), B_negate=>inv_sel, carryin=>cout_sig(i-1), less=>'0', op=>op_32, carryout=>cout_32, set=>set0, overflow=>overflow_32, result=>ALUout(i));
      end generate;
    end generate;
    shiftl : shift_ll32 port map(din=>A_32, samt=>B_32(4 downto 0), dout=>sll_out);
    shiftr : shift_rl32 port map(din=>A_32, samt=>B_32(4 downto 0), dout=>srl_out);
    M0 : mux_n
      generic map(n=>32)
      port map(sel=>op_32(0), src0=>sll_out, src1=>srl_out, z=>M0_out);
    M1 : mux_n
      generic map(n=>32)
      port map(sel=>op_32(3), src0=>ALUout, src1=>M0_out, z=>result_32_sig);

    result_32 <= result_32_sig;

  ------zero flag ----------------------------- 4 levels of or gates then not the result of all ors
    ZFLAG_L1 : for i in 0 to 15 generate
      or_zf1 : or_gate port map(x=>result_32_sig(2*i), y=>result_32_sig(2*i+1), z=>z_zero(0)(i));
    end generate;
    ZFLAG_L2 : for i in 0 to 7 generate
      or_zf2 : or_gate port map(x=>z_zero(0)(2*i), y=>z_zero(0)(2*i+1), z=>z_zero(1)(i));
    end generate;
    ZFLAG_L3 : for i in 0 to 3 generate
      or_zf3 : or_gate port map(x=>z_zero(1)(2*i), y=>z_zero(1)(2*i+1), z=>z_zero(2)(i));
    end generate;
    ZFLAG_L4 : for i in 0 to 1 generate
      or_zf3 : or_gate port map(x=>z_zero(2)(2*i), y=>z_zero(2)(2*i+1), z=>z_zero(3)(i));
    end generate;
    or_zf4 : or_gate port map(x=>z_zero(3)(0), y=>z_zero(3)(1), z=>or_zf_out0);

    zf_out : not_gate port map(x=>or_zf_out0, z=>zero_32);
  end architecture structural;
