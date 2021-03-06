library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361.all;
  use work.eecs361_gates.all;
entity cache is
  port (
  clk : in std_logic;
  addr : in std_logic_vector(25 downto 0);
  LRU : in std_logic;
  new_LRU : out std_logic;
  din : in std_logic_vector(511 downto 0);
  we : in std_logic;
  dout : out std_logic_vector(534 downto 0);
  miss : out std_logic;
  dirty : out std_logic
  );
end entity;
--Want cache
architecture arch of cache is
  constant zeroSrc : std_logic_vector(534 downto 0) := (others => '0');
  signal topLineDin : std_logic_vector(534 downto 0);
  signal bottomLineDin : std_logic_vector(534 downto 0);
  signal topLineDin_loop : std_logic_vector(534 downto 0);
  signal bottomLineDin_loop : std_logic_vector(534 downto 0);
  signal topLineDin_mux : std_logic_vector(534 downto 0);
  signal bottomLineDin_mux : std_logic_vector(534 downto 0);
  signal topLineDout : std_logic_vector(534 downto 0);
  signal bottomLineDout : std_logic_vector(534 downto 0);
  signal weTopLine : std_logic;
  signal weBottomLine : std_logic;
  signal weTopLine_i : std_logic;
  signal weBottomLine_i : std_logic;
  signal weTopLine_i2 : std_logic;
  signal weBottomLine_i2 : std_logic;
  signal tag_eq_toptag : std_logic;
  signal tag_eq_bottomtag : std_logic;
  signal not_clk : std_logic;
  signal not_miss : std_logic;
  signal not_LRU_top : std_logic;
  signal not_LRU_bottom : std_logic;
  signal not_dirty_top : std_logic;
  signal not_dirty_bottom : std_logic;
  signal notclk_we : std_logic;
  signal notclk_we_not_miss : std_logic;
  signal mux_inter : std_logic_vector(534 downto 0);
  signal dout_i : std_logic_vector(534 downto 0);
  signal dout_lru_i : std_logic_vector(534 downto 0);
  signal dout_data_i : std_logic_vector(534 downto 0);
  signal mux_lru_data_inter : std_logic_vector(534 downto 0);
begin
  --Chould we Write?
  notLRUtop : not_gate port map(LRU, not_LRU);
  notDirtyTop : not_gate port map(topLineDout(533),not_dirty_top);
  andWeTopLRUDirty : and_gate port map(not_dirty_top, not_LRU, weTopLine_i);
  andWeTopLine : and_gate port map(we, weTopLine_i, weTopLine_i2);

  notDirtybottom : not_gate port map(bottomLineDout(533),not_dirty_bottom);
  andWeBottomLRUDirty : and_gate port map(not_dirty_bottom, LRU, weBottomLine_i);
  andWeBottomLine : and_gate port map(we, weBottomLine_i, weBottomLine_i2);

  notclk : not_gate port map(clk, not_clk);
  andWeWeTopLine : and_gate port map(not_clk, weTopLine_i2, weTopLine);
  andWeWeBottomLine : and_gate port map(not_clk, weBottomLine_i2, weBottomLine);

  andNotClkWe : and_gate port map (not_clk, we, notclk_we);
  andNotMiss : and_gate port map (notclk_we, not_miss, notclk_we_not_miss);

  topLineDin(534 downto 533) <= "11";
  topLineDin(532 downto 512) <= addr(25 downto 5);
  topLineDin(511 downto 0) <= din;
  bottomLineDin(535 downto 533) <= "11";
  bottomLineDin(532 downto 512) <= addr(25 downto 5);
  bottomLineDin(511 downto 0) <= din;

  topLineDin_loop(534 downto 0) <= topLineDout(534 downto 0);
  bottomLineDin_loop(534 downto 0) <= bottomLineDout(534 downto 0);

  sel_topLoop : mux_n generic map(n =>535);
                      port map(sel => weTopLine_i2,
                               src0 => topLineDin_loop,
                               src1 => topLineDin,
                               z => topLineDin_mux);

  sel_bottomLoop : mux_n generic map(n =>535);
                         port map(sel => weBottomLine_i2,
                                  src0 => bottomLineDin_loop,
                                  src1 => botomLineDin,
                                  z => bottomLineDin_mux);

  topLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 536
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => notclk_we_not_miss,
    index => addr(4 downto 0),
    din   => topLineDin_mux,
    dout  => topLineDout
  );

  bottomLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 536
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => notclk_we_not_miss,
    index => addr(4 downto 0),
    din   => bottomLineDin_mux,
    dout  => bottomLineDout
  );

  topLineComp : cmp_n
  generic map (
    n => 21
  )
  port map (
    a             => addr(25 downto 5),
    b             => topLineDout(532 downto 512),
    a_eq_b        => tag_eq_toptag,
    a_gt_b        => ,
    a_lt_b        => ,
    signed_a_gt_b => ,
    signed_a_lt_b =>
  );

  bottomLineComp : cmp_n
  generic map (
    n => 21
  )
  port map (
    a             => addr(25 downto 5),
    b             => bottomLineDout(532 downto 512),
    a_eq_b        => tag_eq_bottomtag,
    a_gt_b        => ,
    a_lt_b        => ,
    signed_a_gt_b => ,
    signed_a_lt_b =>
  );

  notTagTop : not_gate port map(tag_eq_toptag, new_LRU);

  cmpTags : or_gate port map(tag_eq_toptag, tag_eq_bottomtag, not_miss);
  miss : not_gate port map(not_miss, miss);

  muxtop : mux_n generic map (n => 535);
               port map (sel => tag_eq_toptag,
                         src0 => zeroSrc,
                         src1 => topLineDout,
                         z => mux_inter);

  muxbottom : mux_n generic map (n => 535);
               port map (sel => tag_eq_bottomtag,
                         src0 => mux_inter,
                         src1 => bottomLineDout,
                         z => dout_data_i);

  mux_LRU_data : mux_n generic map (n => 535);
               port map (sel => LRU,
                         src0 => topLineDout,
                         src1 => bottomLineDout,
                         z => dout_lru_i);

  sel_lru_or_data : mux_n generic map (n => 535);
                        port map (sel => not_miss,
                                  src0 => dout_lru_i,
                                  src1 => dout_data_i,
                                  z => dout_i);

   dirty <= dout_i(533);
   dout <= dout_i(511 downto 0);

end architecture;
