library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_n is
  generic (n : integer := 30);
  port (
        a_n : in std_logic_vector(n-1 downto 0);
        b_n : in std_logic_vector(n-1 downto 0);
        cin_n : in std_logic;
        cout_n : out std_logic;
        sum_n : out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture structural of add_n is
  component add_1b is
    port (
          a_1 : in std_logic;
          b_1 : in std_logic;
          cin_1 : in std_logic;
          cout_1 : out std_logic;
          sum_1 : out std_logic
    );
  end component;

  signal tmp_cout : std_logic_vector(n-1 downto 0);
begin
  add_gen: for i in 0 to n-1 generate
    right: if i = 0 generate
      first: add_1b port map(a_1=>a_n(i), b_1=>b_n(i), cin_1=>cin_n, cout_1=>tmp_cout(i), sum_1=>sum_n(i));
    end generate;
    middle: if i > 0 and i < n-1 generate
      mid: add_1b port map(a_1=>a_n(i), b_1=>b_n(i), cin_1=>tmp_cout(i-1), cout_1=>tmp_cout(i), sum_1=>sum_n(i));
    end generate;
    left: if i = n-1 generate
      last: add_1b port map(a_1=>a_n(i), b_1=>b_n(i), cin_1=>tmp_cout(i-1), cout_1=>cout_n, sum_1=>sum_n(i));
    end generate;
  end generate;
end architecture;
