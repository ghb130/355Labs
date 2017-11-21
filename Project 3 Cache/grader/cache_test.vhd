library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361.syncram_n;

entity cache_test is
end cache_test;

architecture mix of cache_test is
component l1cache is
    port (
        clk       : in std_logic;
        rst       : in std_logic;
        en        : in std_logic;
        
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
end component;
component l2cache is
    port (
        clk       : in std_logic;
        rst       : in std_logic;
        en        : in std_logic;
        
        l1Req    : in  std_logic;
        l1Wr     : in  std_logic;
        l1Addr   : in  std_logic_vector(31 downto 0);
        l1Din    : in  std_logic_vector((64*8-1) downto 0);
        l1Dout   : out std_logic_vector((64*8-1) downto 0);
        l1Ready  : out std_logic;

        memReq     : out std_logic;
        memWr      : out std_logic;
        memAddr    : out std_logic_vector(31 downto 0);
        memDout    : out std_logic_vector((64*8-1) downto 0);
        memDin     : in  std_logic_vector((64*8-1) downto 0);
        memReady   : in  std_logic;

        hit_cnt   : out std_logic_vector(31 downto 0);
        miss_cnt  : out std_logic_vector(31 downto 0);
        evict_cnt : out std_logic_vector(31 downto 0)
    );
end component;
component cache_tester is
  generic (
    addr_trace_file : string;
    data_trace_file : string
  );
  port (
    DataIn : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    rst : in std_logic;

    Req  : out std_logic;
    WR   : out std_logic;
    Addr : out std_logic_vector(31 downto 0);
    Data : out Std_logic_vector(31 downto 0);
    Ready : in std_logic;
    Err : out std_logic
  );
end component;
signal err : std_logic;
signal clk : std_logic := '1';
signal rst, en : std_logic;
signal req0, wr0, ready0, req1, wr1, ready1, req2, wr2, ready2 : std_logic;
signal datain0, dataout0, addr0, addr1, addr2 : std_logic_vector(31 downto 0);
signal datain1, dataout1, datain2, dataout2 : std_logic_vector(64*8-1 downto 0);
begin
    clk <= not clk after 5 ns;
    rst <= '1', '0' after 2 ns;
    en <= '0' , '1' after 7 ns;

    err_proc : process(err)
    begin
      if err = '1' then
        report "ERROR: Err = '1'";
      end if;
    end process;

    l1map : l1cache port map (
        clk => clk, rst => rst, en => en,
        cpuReq => req0, cpuWr => wr0,
        cpuAddr => addr0, cpuDin => datain0, cpuDout => dataout0,
        cpuReady => ready0,
        l2Req => req1, l2Wr => wr1,
        l2Addr => addr1, l2Dout => dataout1, l2Din => datain1,
        l2Ready => ready1);

    l2map : l2cache port map (
        clk => clk, rst => rst, en => en,
        l1Req => req1, l1Wr => wr1,
        l1Addr => addr1, l1Din => dataout1, l1Dout => datain1,
        l1Ready => ready1,
        memReq => req2, memWr => wr2,
        memAddr => addr2, memDout => dataout2, memDin => datain2,
        memReady => ready2
    );

    memmap : syncram_n
        generic map (
            blksize => 64,
            mem_file => "data/mem_init"
        )
        port map (
           clk => clk, cs => en, oe => '1', we => wr2,
           addr => addr2, din => dataout2, dout => datain2,
           req => req2, ready => ready2
        );
    testermap : cache_tester
        generic map (
            data_trace_file => "data/random_data_trace",
            addr_trace_file => "data/random_addr_trace"
        )
        port map (
            DataIn => dataout0, clk => clk, Ready => ready0,
            rst => rst, Addr => addr0, Data => datain0,
            WR => wr0, Req => req0
        );
end architecture;
