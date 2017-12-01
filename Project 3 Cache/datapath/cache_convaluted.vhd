library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361.all;
  use work.eecs361_gates.all;
entity cache is
  port (
  tag : in std_logic_vector(20 downto 0);
  index : in std_logic_vector(4 downto 0);
  LRU : in std_logic;
  dirty : in std_logic_vector(1 downto 0);
  valid : in std_logic_vector(1 downto 0);

  din : in std_logic_vector(511 downto 0);
  we : in std_logic;
  new_LRU : out std_logic;
  new_valid : out std_logic(1 downto 0);
  new_dirty : out std_logic(1 downto 0);
  dout : out std_logic_vector(511 downto 0);
  miss : out std_logic
  );
end entity;
--Want cache
architecture arch of cache is
  constant zeroSrc : std_logic_vector(533 downto 0) := (others => '0');
  signal topLineDin : std_logic_vector(533 downto 0);
  signal bottomLineDin : std_logic_vector(533 downto 0);
  signal topLineDin_loop : std_logic_vector(533 downto 0);
  signal bottomLineDin_loop : std_logic_vector(533 downto 0);
  signal topLineDin_mux : std_logic_vector(533 downto 0);
  signal bottomLineDin_mux : std_logic_vector(533 downto 0);
  signal topLineDout : std_logic_vector(533 downto 0);
  signal bottomLineDout : std_logic_vector(533 downto 0);
  signal index : std_logic_vector(4 downto 0);
  signal weTopLine : std_logic;
  signal weBottomLine : std_logic;
  signal weTopLine_i : std_logic;
  signal weBottomLine_i : std_logic;
  signal tag_eq_toptag : std_logic;
  signal tag_eq_bottomtag : std_logic;
  signal not_miss : std_logic;
  signal not_pos : std_logic;
  signal not_LRU : std_logic;
  signal not_dirty_top : std_logic;
  signal not_dirty_bottom : std_logic;
  signal mux_inter : std_logic_vector(533 downto 0);
  signal mux_lru_inter : std_logic_vector(533 downto 0);
  signal dout_i : std_logic_vector(533 downto 0);
  signal dout_lru_i : std_logic_vector(533 downto 0);
  signal dout_data_i : std_logic_vector(533 downto 0);
  signal mux_lru_data_inter : std_logic_vector(533 downto 0);
  signal topLineAddress : (25 downto 0);
  signal bottomLineAddress : (25 downto 0);
begin
  notLRU : not_gate port map(LRU, not_LRU);
  notDirtyTop : not_gate port map(dirty(0),not_dirty_top);
  notDirtybottom : not_gate port map(dirty(1),not_dirty_bottom);
  andWeTopLine : and_gate port map(we, not_LRU, weTopLine_i);
  andWeDirty : and_gate port map(weTopLine_i, not_dirty_top, weTopLine);
  andWeBottomLine : and_gate port map(we, LRU, weBottomLine_i);
  andWeDirty : and_gate port map(weBottomLine_i, not_dirty_bottom, weBottomLine);

  topLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 534
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => weTopLine,
    index => addr(5 downto 0),
    din   => din,
    dout  => topLineDout
  );

  bottomLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 534
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => weBottomLine,
    index => addr(5 downto 0),
    din   => din,
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

  validMuxTop : mux port map (sel => weTopLine,
                              src0 => valid(0),
                              src1 => '1',
                              z => new_valid(0));
  validMuxBottom : mux port map (sel => weBottomLine,
                              src0 => valid(1),
                              src1 => '1',
                              z => new_valid(1));
  dirtyMuxTop : mux port map (sel => weTopLine,
                            src0 => dirty(0),
                            src1 => '1',
                            z => new_valid(0));
  dirtyMuxBottom : mux port map (sel => weBottomLine,
                            src0 => valid(1),
                            src1 => '1',
                            z => new_valid(1));

  notTagTop : not_gate port map(tag_eq_toptag, new_LRU);

  cmpTags : or_gate port map(tag_eq_toptag, tag_eq_bottomtag, not_miss);
  miss : not_gate port map(x=>not_miss, z=>miss);

  muxtop : mux_n generic map (n => 534);
               port map (sel => tag_eq_toptag,
                         src0 => zeroSrc,
                         src1 => topLineDout,
                         z => mux_inter);

  muxbottom : mux_n generic map (n => 534);
               port map (sel => tag_eq_bottomtag,
                         src0 => mux_inter,
                         src1 => bottomLineDout,
                         z => dout_i);
   dout <= dout_i(511 downto 0);
end architecture;
