library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity reg32 is
  port (
        clk : in std_logic;
        din : in std_logic_vector(31 downto 0);
        we : in std_logic;
        dout : out std_logic_vector(31 downto 0)
  );
end entity;

architecture structural of reg32 is
  begin
    dff_gen: for i in 0 to 31 generate
      dffRE : dffr_a port map(clk => clk,
                            arst => '0',
                            aload => '0',
                            adata => '0',
                            d => din(i),
                            enable => we,
                            q => dout(i));
    end generate;
end architecture;
