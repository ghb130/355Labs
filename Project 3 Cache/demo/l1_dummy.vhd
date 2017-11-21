library ieee;

use ieee.std_logic_1164.all;
use work.eecs361.all;

entity l1cache is
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
end l1cache;

architecture struct of l1cache is
signal sels : std_logic_vector(15 downto 0);

type mux_array is array (0 to 13) of std_logic_vector(31 downto 0);
signal muxes : mux_array;

-- control & state signals
signal state, state_next : std_logic;

-- save cpu side request.
signal cpuWrsaved : std_logic;
signal cpuAddrsaved, cpuDinsaved : std_logic_vector(31 downto 0);
signal wr_next : std_logic;

begin
    -- Save cpu side request
    save_wr : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
        d => wr_next, enable => en, q => cpuWrsaved);
    save_addr_din : for i in 0 to 31 generate
        save_din : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
            d => cpuDin(i), enable => cpuReq, q => cpuDinsaved(i));
        save_addr : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
            d => cpuAddr(i), enable => cpuReq, q => cpuAddrsaved(i));
    end generate;

    -- state machine
    state_dffr : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
        d => state_next, enable => en, q => state);
    state_next <= ((not state) and l2Ready and cpuWrsaved)  or (state and not l2Ready);

    -- setup outputs
    lvblk : for iblk in 0 to 15 generate
        lvbit : for ibit in 0 to 31 generate
            dmux : mux port map (sel => sels(iblk), src0 => l2Din(iblk * 32 + ibit), 
                src1 => cpuDinsaved(ibit), z => l2Dout(iblk * 32 + ibit));
        end generate;
    end generate;
    dec_map : dec_n generic map (n => 4) port map (
        src => cpuAddrsaved(5 downto 2), z => sels);
    lv1 : for i in 0 to 7 generate
        mux_map : mux_32 port map (sel => cpuAddrsaved(2),
            src0 => l2Din(i * 2 * 32 + 31 downto i * 2 * 32),
            src1 => l2Din((i * 2 + 1) * 32 + 31 downto 32 * (i * 2 + 1)), z => muxes(i));
    end generate;
    lv2 : for i in 0 to 3 generate
        mux_map : mux_32 port map (sel => cpuAddrsaved(3),
            src0 => muxes(i * 2), src1 => muxes(i * 2 + 1), z => muxes(i + 8));
    end generate;
    lv3 : for i in 0 to 1 generate
        mux_map : mux_32 port map (sel => cpuAddrsaved(4),
            src0 => muxes(i * 2 + 8), src1 => muxes(i * 2 + 9), z => muxes(i + 12));
    end generate;
    final_mux : mux_32 port map (sel => cpuAddrsaved(5), src0 => muxes(12), src1 => muxes(13), z => cpuDout);

    -- Take a shortcut of datapath statements, JUST for demo purpose.
    wr_next <= (cpuReq and cpuWr) or ((not cpuReq) and (not state_next) and cpuWrsaved);
    l2Wr <= (not state) and l2Ready and cpuWrsaved;
    l2Req <= cpuReq or (l2Ready and cpuWrsaved and not state);
    l2Addr <= cpuAddr(31 downto 6) & "000000" when cpuReq = '1' else cpuAddrsaved(31 downto 6) & "000000";
    cpuReady <= l2Ready and (not cpuWrsaved);
    
    -- dummy, no counters.
    hit_cnt <= x"00000000";
    miss_cnt <= x"00000000";
    evict_cnt <= x"00000000";
end struct;
