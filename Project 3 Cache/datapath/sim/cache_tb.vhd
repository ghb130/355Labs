library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.eecs361.all;
use work.eecs361_gates.all;

--Additional standard or custom libraries go here
entity cache_tb is
end entity cache_tb;

architecture behavioral of cache_tb is
  component cache_test
  port (
    clk     : in  std_logic;
    ovrwr   : in  std_logic;
    addr    : in  std_logic_vector(25 downto 0);
    LRU     : in  std_logic;
    new_LRU : out std_logic;
    din     : in  std_logic_vector(15 downto 0);
    we      : in  std_logic;
    dout    : out std_logic_vector(38 downto 0);
    miss    : out std_logic;
    dirty   : out std_logic
  );
end component cache_test;

  signal clk_tb     : std_logic;
  signal ovrwr_tb   : std_logic;
  signal addr_tb    : std_logic_vector(25 downto 0);
  signal LRU_tb     : std_logic;
  signal new_LRU_tb : std_logic;
  signal din_tb     : std_logic_vector(15 downto 0);
  signal we_tb      : std_logic;
  signal dout_tb    : std_logic_vector(38 downto 0);
  signal miss_tb    : std_logic;
  signal dirty_tb   : std_logic;



begin
  cache_i : cache_test
  port map (
    clk     => clk_tb,
    ovrwr   => ovrwr_tb,
    addr    => addr_tb,
    LRU     => LRU_tb,
    new_LRU => new_LRU_tb,
    din     => din_tb,
    we      => we_tb,
    dout    => dout_tb,
    miss    => miss_tb,
    dirty   => dirty_tb
  );


    clock_generate : process is
      begin
        clk_tb<='1';
        wait for 5 ns;
        clk_tb <= not clk_tb;
        wait for 5 ns;
    end process clock_generate;

    process is
      begin
      ovrwr_tb <= '1';
      addr_tb(25 downto 5) <= (5 => '0', others => '0');
      addr_tb(4 downto 0) <= "00000";
      LRU_tb <= '0';
      din_tb <= (0 => '1', others => '0');
      we_tb <= '1';
      wait for 10 ns;
      ovrwr_tb <= '0';
      addr_tb(25 downto 5) <= (5 => '0', others => '0');
      addr_tb(4 downto 0) <= "00000";
      LRU_tb <= '0';
      din_tb <= (0 => '1', 1 => '1', others => '0');
      we_tb <= '1';
      wait for 10 ns;
      ovrwr_tb <= '0';
      addr_tb(25 downto 5) <= (5 => '0', others => '0');
      addr_tb(4 downto 0) <= "00000";
      LRU_tb <= '0';
      din_tb <= (0 => '0', others => '0');
      we_tb <= '0';
      wait for 10 ns;
      ovrwr_tb <= '0';
      addr_tb(25 downto 5) <= (5 => '0', others => '0');
      addr_tb(4 downto 0) <= "00001";
      LRU_tb <= '0';
      din_tb <= (0 => '0', others => '0');
      we_tb <= '0';
      wait for 10 ns;
      ovrwr_tb <= '0';
      addr_tb(25 downto 5) <= (5 => '1', others => '0');
      addr_tb(4 downto 0) <= "00000";
      LRU_tb <= '0';
      din_tb <= (0 => '0', others => '0');
      we_tb <= '0';
      wait;
     end process;

end architecture behavioral;
