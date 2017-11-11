library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity and_6to1 is
  port (
        din : in std_logic_vector(5 downto 0);
        z : out std_logic
  );
end entity;

architecture structural of and_6to1 is

signal and_out : std_logic_vector(3 downto 0);

begin
  A0: and_gate port map(x=>din(0), y=>din(1), z=>and_out(0));
  A1: and_gate port map(x=>din(2), y=>din(3), z=>and_out(1));
  A2: and_gate port map(x=>din(4), y=>din(5), z=>and_out(2));

  A3: and_gate port map(x=>and_out(0), y=>and_out(1), z=>and_out(3));
  A4: and_gate port map(x=>and_out(2), y=>and_out(3), z=>z);
end architecture;
