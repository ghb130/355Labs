library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity ifu is
  port (
        init : in std_logic;
        clk : in std_logic;
        imm16 : in std_logic_vector(15 downto 0);
        zero : in std_logic;
        branch : in std_logic;
        addr_out : out std_logic_vector(31 downto 0)
  );
end entity;

architecture structural of ifu is
  component add_n is
    generic (n : integer);
    port (
          a_n : in std_logic_vector(n-1 downto 0);
          b_n : in std_logic_vector(n-1 downto 0);
          cin_n : in std_logic;
          cout_n : out std_logic;
          sum_n : out std_logic_vector(n-1 downto 0)
    );
  end component;
  component extender_n is
    generic (n : integer := 30);
    port (
          a : in std_logic_vector(15 downto 0);
          sel : in std_logic;
          z : out std_logic_vector(n-1 downto 0)
    );
  end component;
  component pc_reg is
    port (
          clk : in std_logic;
          din : in std_logic_vector(29 downto 0);
          dout : out std_logic_vector(29 downto 0)
    );
  end component;
  component and_gate is
    port (
      x   : in  std_logic;
      y   : in  std_logic;
      z   : out std_logic
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

  constant pc_init_val : std_logic_vector(29 downto 0) := "000000000100000000000000001000";
  signal pc_in : std_logic_vector(29 downto 0);  --"000000000100000000000000001000"
  signal pc_in_loop : std_logic_vector(29 downto 0);
  signal pc_out : std_logic_vector(29 downto 0);  --"000000000100000000000000001000"
  signal zero_vec : std_logic_vector(29 downto 0) := (others => '0');
  signal imm_ext : std_logic_vector(29 downto 0);
  signal sum0 : std_logic_vector(29 downto 0);
  signal sum1 : std_logic_vector(29 downto 0);
  signal c0 : std_logic;
  signal c1 : std_logic;
  signal br_sel : std_logic;
  begin
    EXT: extender_n generic map(n=>30)
                    port map(a=>imm16, sel=>'1', z=>imm_ext);
    MXPC: mux_n generic map(n=>30)
              port map(sel=>init, src0=>pc_in_loop, src1=>pc_init_val, z=>pc_in);
    PC: pc_reg port map(clk=>clk, din=>pc_in, dout=>pc_out);
    ADD0: add_n generic map(n=>30)
              port map(a_n=>pc_out, b_n=>zero_vec, cin_n=>'1', cout_n=>c0, sum_n=>sum0);
    ADD1: add_n generic map(n=>30)
              port map(a_n=>sum0, b_n=>imm_ext, cin_n=>'0', cout_n=>c1, sum_n=>sum1);
    AND0: and_gate port map(x=>branch, y=>zero, z=>br_sel);
    MX: mux_n generic map(n=>30)
              port map(sel=>br_sel, src0=>sum0, src1=>sum1, z=>pc_in_loop);
    addr_out(31 downto 2) <= pc_out;
    addr_out(1 downto 0) <= "00";

  end architecture;
