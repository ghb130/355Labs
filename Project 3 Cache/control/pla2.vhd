library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity pla2 is
  port (
        din : in std_logic_vector(1 downto 0);
        inv : in std_logic_vector(1 downto 0);
        z : out std_logic
  );
end entity;

component plaInverter_n
generic (
  n : integer := 2
);
port (
  din  : in  std_logic_vector(n-1 downto 0);
  inv  : in  std_logic_vector(n-1 downto 0);
  dout : out std_logic_vector(n-1 downto 0)
);
end component plaInverter_n;

architecture structural of pla2 is
  signal plaInvOut : std_logic_vector(1 downto 0);
begin
  plainv: plaInverter_n generic map(n => 2)
                        port map(din => din, inv=>inv, dout=>plaInvOut);
  and_g: and_gate port map(x => plaInvOut(0), y => plaInvOut(1), z => z);

end architecture;
