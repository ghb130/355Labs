library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use ieee.numeric_std.all;

entity pla5 is
  port (
        din : in std_logic_vector(4 downto 0);
        inv : in std_logic_vector(4 downto 0);
        z : out std_logic
  );
end entity;

architecture structural of pla5 is
  component plaInverter_n
    generic (
      n : integer
    );
    port (
      din  : in  std_logic_vector(n-1 downto 0);
      inv  : in  std_logic_vector(n-1 downto 0);
      dout : out std_logic_vector(n-1 downto 0)
    );
  end component plaInverter_n;

  component and5to1
    port (
      din : in  std_logic_vector(4 downto 0);
      z   : out std_logic
    );
  end component and5to1;

  signal plaInvOut : std_logic_vector(4 downto 0);
begin
  plainv: plaInverter_n generic map(n => 5)
                        port map(din => din, inv=>inv, dout=>plaInvOut);
  and_g: and5to1 port map(din=>plaInvOut, z=>z);

end architecture;
