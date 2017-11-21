library ieee;

use ieee.std_logic_1164.all;

entity l2cache is
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
end l2cache;

architecture struct of l2cache is
begin
    -- ignore clk, rst, and en.

    memReq <= l1Req;
    memWr <= l1Wr;
    memAddr <= l1Addr;
    memDout <= l1Din;
    l1Dout <= memDin;
    l1Ready <= memReady;

    hit_cnt <= (others => '0');
    miss_cnt <= (others => '0');
    evict_cnt <= (others => '0');
end struct;
