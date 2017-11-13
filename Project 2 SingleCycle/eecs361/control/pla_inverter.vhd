library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity pla_inverter is
  port (
        din : in std_logic_vector(5 downto 0);
        inv : in std_logic_vector(5 downto 0);
        dout : out std_logic_vector(5 downto 0)
  );
end entity;

architecture structural of pla_inverter is

component xor_gate
  port (
    x : in  std_logic;
    y : in  std_logic;
    z : out std_logic
  );
end component xor_gate;

begin
  xor_gate_0 : xor_gate
    port map (
      x => din(0),
      y => inv(0),
      z => dout(0)
    );
  xor_gate_1 : xor_gate
    port map (
      x => din(1),
      y => inv(1),
      z => dout(1)
    );
  xor_gate_2 : xor_gate
    port map (
      x => din(2),
      y => inv(2),
      z => dout(2)
    );
  xor_gate_3 : xor_gate
    port map (
      x => din(3),
      y => inv(3),
      z => dout(3)
    );
  xor_gate_4 : xor_gate
    port map (
      x => din(4),
      y => inv(4),
      z => dout(4)
    );
  xor_gate_5 : xor_gate
    port map (
      x => din(5),
      y => inv(5),
      z => dout(5)
    );

end architecture;
