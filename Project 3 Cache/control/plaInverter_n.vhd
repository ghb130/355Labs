library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use ieee.numeric_std.all;

entity plaInverter_n is
  generic(n : integer := 2);
  port (
        din : in std_logic_vector(n-1 downto 0);
        inv : in std_logic_vector(n-1 downto 0);
        dout : out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture structural of plaInverter_n is

component xor_gate
  port (
    x : in  std_logic;
    y : in  std_logic;
    z : out std_logic
  );
end component xor_gate;

begin
  xor_gen: for i in 0 to n-1 generate
    xor_n: xor_gate port map(x => din(i), y => inv(i), z=> dout(i));
  end generate;

end architecture;
