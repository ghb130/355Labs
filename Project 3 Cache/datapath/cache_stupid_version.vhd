library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361.all;
  use work.eecs361_gates.all;
entity cache is
  port (
  addr : in std_logic_vector(28 downto 0);
  din : in std_logic_vector(511 downto 0);
  we : in std_logic;
  dout : out std_logic_vector(511 downto 0);
  lruAddr : out std_logic_vector(28 downto 0);
  miss : out std_logic;
  dirty : out std_logic
  );
end entity;
--Want cache
architecture arch of cache is
  constant zeroSrc : std_logic_vector(535 downto 0) := (others => '0');
  signal topLineDin : std_logic_vector(535 downto 0);
  signal bottomLineDin : std_logic_vector(535 downto 0);
  signal topLineDin_loop : std_logic_vector(535 downto 0);
  signal bottomLineDin_loop : std_logic_vector(535 downto 0);
  signal topLineDin_mux : std_logic_vector(535 downto 0);
  signal bottomLineDin_mux : std_logic_vector(535 downto 0);
  signal topLineDout : std_logic_vector(535 downto 0);
  signal bottomLineDout : std_logic_vector(535 downto 0);
  signal index : std_logic_vector(4 downto 0);
  signal weTopLine : std_logic;
  signal weBottomLine : std_logic;
  signal tag_eq_toptag : std_logic;
  signal tag_eq_bottomtag : std_logic;
  signal not_miss : std_logic;
  signal not_pos : std_logic;
  signal mux_inter : std_logic_vector(535 downto 0);
  signal mux_lru_inter : std_logic_vector(535 downto 0);
  signal dout_i : std_logic_vector(535 downto 0);
  signal dout_lru_i : std_logic_vector(535 downto 0);
  signal dout_data_i : std_logic_vector(535 downto 0);
  signal mux_lru_data_inter : std_logic_vector(535 downto 0);
  signal topLineAddress : (25 downto 0);
  signal bottomLineAddress : (25 downto 0);
begin
  andWeTopLine : and_gate port map(we, topLineDout(534), weTopLine);
  andWeBottomLine : and_gate port map(x=>we, y=>bottomLineDout(534), z=>weBottomLine);

  topLineDin(535 downto 533) <= "001";
  topLineDin(532 downto 512) <= addr(25 downto 5);
  topLineDin(511 downto 0) <= din;
  bottomLineDin(535 downto 533) <= "101";
  bottomLineDin(532 downto 512) <= addr(25 downto 5);
  bottomLineDin(511 downto 0) <= din;

  topLineDin_loop(535 downto 534) <= "01";
  topLineDin_loop(533 downto 0) <= topLineDout(533 downto 0);
  bottomLineDin_loop(535 downto 534) <= "11";
  bottomLineDin_loop(533 downto 0) <= bottomLineDout(533 downto 0);

  not_pos_gate : not_gate port map(addr(28),not_pos);

  sel_topLoop : mux_n generic map(n =>536);
                      port map(sel => not_pos,
                               src0 => topLineDin_loop,
                               src1 => topLineDin,
                               z => topLineDin_mux);

  sel_bottomLoop : mux_n generic map(n =>536);
                         port map(sel => pos,
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
    we    => we,
    index => addr(5 downto 0),
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
    we    => we,
    index => addr(5 downto 0),
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

  cmpTags : or_gate port map(tag_eq_toptag, tag_eq_bottomtag, not_miss);
  miss : not_gate port map(x=>not_miss, z=>miss);

  muxtop : mux_n generic map (n => 536);
               port map (sel => tag_eq_toptag,
                         src0 => zeroSrc,
                         src1 => topLineDout,
                         z => mux_inter);

  muxbottom : mux_n generic map (n => 536);
               port map (sel => tag_eq_bottomtag,
                         src0 => mux_inter,
                         src1 => bottomLineDout,
                         z => dout_data_i);

  muxtop_LRU_data : mux_n generic map (n => 536);
               port map (sel => topLineDout(534),
                         src0 => zeroSrc,
                         src1 => topLineDout,
                         z => mux_lru_data_inter);

  muxbottom_LRU_data : mux_n generic map (n => 536);
               port map (sel => bottomLineDout(534),
                         src0 => mux_lru_data_inter,
                         src1 => bottomLineDout,
                         z => dout_lru_i);

  sel_lru_or_data : mux_n generic map (n => 536);
                        port map (sel => not_miss,
                                  src0 => dout_lru_i,
                                  src1 => dout_data_i,
                                  z => dout_i);

  topLineAddress(4 downto 0) <= addr(4 downto 0);
  topLineAddress(27 downto 5) <= topLineDout(535 downto 512);
  topLineAddress(28) <= '0';
  bottomLineAddress(4 downto 0) <= addr(4 downto 0);
  bottomLineAddress(27 downto 5) <= bottomLineDout(535 downto 512);
  bottomLineAddress(28) <= '1';

  muxtop_LRU : mux_n generic map (n => 29);
              port map (sel => topLineDout(534),
                        src0 => zeroSrc,
                        src1 => topLineAddress,
                        z => mux_lru_inter);

  muxbottom_LRU : mux_n generic map (n => 29);
              port map (sel => bottomLineDout(534),
                        src0 => mux_lru_inter,
                        src1 => bottomLineAddress,
                        z => lruAddr);

   dirty <= dout_i(533);
   dout <= dout_i(511 downto 0);

end architecture;
