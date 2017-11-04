library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender_n_tb is
  constant width : integer := 30;
end entity extender_n_tb;

architecture behavioral of extender_n_tb is
  component extender_n is
    generic (n : integer);
    port (
          a : in std_logic_vector(15 downto 0);
          sel : in std_logic;
          z : out std_logic_vector(n-1 downto 0)
    );
  end component;

  signal a_tb : std_logic_vector(15 downto 0);
  signal sel_tb : std_logic;
  signal z_tb : std_logic_vector(width-1 downto 0);

  begin
    dut : extender_n
    generic map (n=>width)
    port map (
      a => a_tb,
      sel => sel_tb,
      z => z_tb
      );

    stim_a: process is
      variable num : integer;
      begin
        num := 389;
        a_tb <= std_logic_vector(to_signed(num, 16)); wait for 10 ns;
        num := 4000; a_tb <= std_logic_vector(to_signed(num, 16)); wait for 10 ns;
        num := 6893; a_tb <= std_logic_vector(to_signed(num, 16)); wait for 10 ns;
        num := -6893; a_tb <= std_logic_vector(to_signed(num, 16)); wait for 10 ns;
        wait;
      end process;
      stim_sel: process is
        begin
          sel_tb <= '0'; wait for 20 ns;
          sel_tb <= '1';
          wait;
          wait;
        end process;

end architecture;
