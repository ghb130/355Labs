library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity or5to1 is
  port (
        a,b,c,d,e : in std_logic;
        z : out std_logic
  );
end entity;

architecture structural of or5to1 is

signal and_out : std_logic_vector(2 downto 0);

begin
  OR0: or_gate port map(x=>a, y=>b, z=>and_out(0));
  OR1: or_gate port map(x=>c, y=>d, z=>and_out(1));
  OR2: or_gate port map(x=>e, y=>and_out(0), z=>and_out(2));

  OR3: or_gate port map(x=>and_out(1), y=>and_out(2), z=>z);
end architecture;
