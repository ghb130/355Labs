library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity reg_n is
  generic( n: integer);
  port (
        din : in std_logic_vector(n - 1 downto 0);
        we : in std_logic;
        clk : in std_logic;
        dout : out std_logic_vector(n - 1 downto 0)
  );
end entity reg_n;

architecture behavioral of reg_n is
  signal mem : std_logic(n downto 0);
  begin
    dout <= mem;
    process(clk)
      begin
        if (rising_edge(clk)) then
          if (we = '1') then
            mem <= din;
          end if;
        end if;
      end process;
  end architecture behavioral;
