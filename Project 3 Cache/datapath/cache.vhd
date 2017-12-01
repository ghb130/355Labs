library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361.all;
  use work.eecs361_gates.all;
entity cache is
  port (
  index : in std_logic_vector(4 downto 0);

  pos : in std_logic;
  din : in std_logic_vector(534 downto 0);
  we : in std_logic;

  dout_top : out std_logic_vector(534 downto 0);
  dout_bottom : out std_logic_vector(534 downto 0)
  );
end entity;
--Want cache
architecture arch of cache is
  signal weTopLine : std_logic;
  signal weBottomLine : std_logic;
  signal not_pos : std_logic;

  notPOS : not_gate port map(pos, not_pos);
  andWeTopLine : and_gate port map(we, not_pos, weTopLine);
  andWeBottomLine : and_gate port map(we, pos, weBottomLine);

  topLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 535
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => weTopLine,
    index => index,
    din   => din,
    dout  => dout_top
  );

  bottomLine : csram
  generic map (
    INDEX_WIDTH => 5,
    BIT_WIDTH   => 535
  )
  port map (
    cs    => '1',
    oe    => '1',
    we    => weBottomLine,
    index => index,
    din   => din,
    dout  => dout_bottom
  );

end architecture;
