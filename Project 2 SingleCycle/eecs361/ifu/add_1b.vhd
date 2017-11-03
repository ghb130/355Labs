library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity add_1b is
  port (
        a_1 : in std_logic;
        b_1 : in std_logic;
        cin_1 : in std_logic;
        cout_1 : out std_logic;
        sum_1 : out std_logic
  );
end entity;

architecture structural of add_1b is
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
  signal and_out : std_logic_vector(2 downto 0);
  signal xor_out_0 : std_logic;
  signal or_out_0 : std_logic;

  begin
    X0 : xor_gate port map(x=>a_1, y=>b_1, z=>xor_out_0);
    X1 : xor_gate port map(x=>cin_1, y=>xor_out_0, z=>sum_1);
    A0 : and_gate port map(x=>a_1, y=>b_1, z=>and_out(0));
    A1 : and_gate port map(x=>a_1, y=>cin_1, z=>and_out(1));
    A2 : and_gate port map(x=>b_1, y=>cin_1, z=>and_out(2));
    O0 : or_gate port map(x=>and_out(0), y=>and_out(1), z=>or_out_0);
    O1 : or_gate port map(x=>or_out_0, y=>and_out(2), z=>cout_1);

end architecture;
