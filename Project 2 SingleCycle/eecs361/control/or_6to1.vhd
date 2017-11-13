library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity or_6to1 is
  port (
        din : in std_logic_vector(5 downto 0);
        z : out std_logic
  );
end entity;

architecture structural of or_6to1 is

signal and_out : std_logic_vector(3 downto 0);

begin
  OR0: or_gate port map(x=>din(0), y=>din(1), z=>and_out(0));
  OR1: or_gate port map(x=>din(2), y=>din(3), z=>and_out(1));
  OR2: or_gate port map(x=>din(4), y=>din(5), z=>and_out(2));

  OR3: or_gate port map(x=>and_out(0), y=>and_out(1), z=>and_out(3));
  OR4: or_gate port map(x=>and_out(2), y=>and_out(3), z=>z);
end architecture;
