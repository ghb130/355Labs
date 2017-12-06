library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.eecs361.all;
use work.eecs361_gates.all;

--Additional standard or custom libraries go here
entity l1cache_tb is
end entity l1cache_tb;

architecture behavioral of l1cache_tb is
  component l1cache
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    en        : in  std_logic;
    cpuReq    : in  std_logic;
    cpuWr     : in  std_logic;
    cpuAddr   : in  std_logic_vector(31 downto 0);
    cpuDin    : in  std_logic_vector(31 downto 0);
    cpuDout   : out std_logic_vector(31 downto 0);
    cpuReady  : out std_logic;
    l2Req     : out std_logic;
    l2Wr      : out std_logic;
    l2Addr    : out std_logic_vector(31 downto 0);
    l2Dout    : out std_logic_vector((64*8-1) downto 0);
    l2Din     : in  std_logic_vector((64*8-1) downto 0);
    l2Ready   : in  std_logic;
    hit_cnt   : out std_logic_vector(31 downto 0);
    miss_cnt  : out std_logic_vector(31 downto 0);
    evict_cnt : out std_logic_vector(31 downto 0)
  );
  end component l1cache;

signal clk_tb       : std_logic;
signal rst_tb       : std_logic;
signal en_tb        : std_logic;
signal cpuReq_tb    : std_logic;
signal cpuWr_tb     : std_logic;
signal cpuAddr_tb   : std_logic_vector(31 downto 0);
signal cpuDin_tb    : std_logic_vector(31 downto 0);
signal cpuDout_tb   : std_logic_vector(31 downto 0);
signal cpuReady_tb  : std_logic;
signal l2Req_tb     : std_logic;
signal l2Wr_tb      : std_logic;
signal l2Addr_tb    : std_logic_vector(31 downto 0);
signal l2Dout_tb    : std_logic_vector((64*8-1) downto 0);
signal l2Din_tb     : std_logic_vector((64*8-1) downto 0);
signal l2Ready_tb   : std_logic;
signal hit_cnt_tb   : std_logic_vector(31 downto 0);
signal miss_cnt_tb  : std_logic_vector(31 downto 0);
signal evict_cnt_tb : std_logic_vector(31 downto 0);

begin
    l1cache_i : l1cache
    port map (
      clk       => clk_tb,
      rst       => rst_tb,
      en        => en_tb,
      cpuReq    => cpuReq_tb,
      cpuWr     => cpuWr_tb,
      cpuAddr   => cpuAddr_tb,
      cpuDin    => cpuDin_tb,
      cpuDout   => cpuDout_tb,
      cpuReady  => cpuReady_tb,
      l2Req     => l2Req_tb,
      l2Wr      => l2Wr_tb,
      l2Addr    => l2Addr_tb,
      l2Dout    => l2Dout_tb,
      l2Din     => l2Din_tb,
      l2Ready   => l2Ready_tb,
      hit_cnt   => hit_cnt_tb,
      miss_cnt  => miss_cnt_tb,
      evict_cnt => evict_cnt_tb
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
        --START COMPULSORY WRITE MISS TEST (Start 0 ends at 50 ns)
        en_tb <= '1';
        cpuReq_tb <= '0';
        cpuWr_tb <= '1';
        cpuAddr_tb <= x"10000000";
        cpuDin_tb <= x"00000001";
        l2Din_tb <= (others => '0');
        l2Ready_tb <= '0';
        wait for 10 ns;
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '1';
        cpuAddr_tb <= x"10000000";
        cpuDin_tb <= x"00000001";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        l2Ready_tb <= '1';
        wait for 20 ns;
        en_tb <= '1';
        cpuReq_tb <= '0';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"10000000";
        cpuDin_tb <= x"00000001";
        l2Din_tb <= (others => '0');
        l2Ready_tb <= '0';
        wait for 30 ns;
        ---START READ MISS TEST (starts 80 ends 120 ns)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"11000000";
        cpuDin_tb <= x"00000000";
        l2Din_tb <= (others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"11000000";
        cpuDin_tb <= x"00000000";
        l2Din_tb <= (511 => '1', others => '0');
        l2Ready_tb <= '1';
        wait for 20 ns;
        l2Ready_tb <= '1';
        cpuReq_tb <= '0';
        wait for 30 ns;
        ---START WRITE HIT TEST (starts 150 ns ends  170 ns)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '1';
        cpuAddr_tb <= x"1000003F";
        cpuDin_tb <= x"FFFFFFFF";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        en_tb <= '1';
        cpuReq_tb <= '0';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"1000003F";
        cpuDin_tb <= x"FFFFFFFF";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 30 ns;
        ---START SECOND WRITE HIT TEST (200 to 220)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '1';
        cpuAddr_tb <= x"1100003F";
        cpuDin_tb <= x"11111111";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        en_tb <= '1';
        cpuReq_tb <= '0';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"1100003F";
        cpuDin_tb <= x"11111111";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 30 ns;
        ---START READ HIT TEST (250 to 270)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"1000003F";
        cpuDin_tb <= x"00000000";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        cpuReq_tb <= '0';
        wait for 30 ns;
        ---START WRITE EVICTION TEST (300 to 360)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '1';
        cpuAddr_tb <= x"FFF0003F";
        cpuDin_tb <= x"55555555";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        l2Ready_tb <= '1';
        cpuReq_tb <= '0';
        wait for 60 ns;
        ---START READ EVICTION TEST (380 to)
        en_tb <= '1';
        cpuReq_tb <= '1';
        cpuWr_tb <= '0';
        cpuAddr_tb <= x"F0F0003F";
        cpuDin_tb <= x"00000000";
        l2Din_tb <= (1 => '1', others => '0');
        l2Ready_tb <= '0';
        wait for 20 ns;
        l2Ready_tb <= '1';
        cpuReq_tb <= '0';
        wait for 30 ns;
      wait;
     end process;

     process is
       begin
         rst_tb <= '1';
         wait for 7 ns;
         rst_tb <= '0';
         wait;
       end process;
end architecture behavioral;
