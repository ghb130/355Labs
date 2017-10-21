library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity reg_32 is
  port (
        din : in std_logic_vector(31 downto 0);
        we : in std_logic;
        clk : in std_logic;
        dout : out std_logic_vector(31 downto 0)
  );
end entity reg_32;

architecture behavioral of reg_32 is
  signal mem : std_logic(31 downto 0);
  begin
    dout <= mem;
    process(clk)
      variable x : std_logic;
      begin
        if (rising_edge(clk)) then
          if (we = '1') then
            mem <= din;
          end if;
        end if;
      end process;
  end architecture behavioral;
