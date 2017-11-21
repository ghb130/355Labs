library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.eecs361.sram;

entity cache_tester is
  generic (
    addr_trace_file : string;
    data_trace_file : string
  );
  port (
    DataIn : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    rst : in std_logic;
    Req : out std_logic;
    WR : out std_logic;
    Addr : out std_logic_vector(31 downto 0);
    Data : out Std_logic_vector(31 downto 0);
    Ready : in std_logic;
    Err : out std_logic
  );
end cache_tester;

architecture mix of cache_tester is
signal addr_src : std_logic_vector(31 downto 0);
signal addr_trace, addr_trace_lag : std_logic_vector(31 downto 0);
signal data_trace, data_trace_lag : std_logic_vector(31 downto 0);
signal cmp : std_logic;
begin
  addr_proc : process(clk, rst)
  begin
    if rst = '1' then
      addr_src <= (others => '0');
    elsif rising_edge(clk) then
      if Ready = '1' then
        addr_src <= std_logic_vector(4 + unsigned(addr_src));
        data_trace_lag <= data_trace;
        addr_trace_lag <= addr_trace;
      end if;
    end if;
  end process;

  addr_trace_map : sram
    generic map ( mem_file => addr_trace_file )
    port map (
      cs    => '1',
      oe    => '1',
      we    => '0',
      addr  => addr_src,
      din   => (others => '0'),
      dout  => addr_trace
    );
    
  data_trace_map : sram
    generic map ( mem_file => data_trace_file )
    port map (
      cs    => '1',
      oe    => '1',
      we    => '0',
      addr  => addr_src,
      din   => (others => '0'),
      dout  => data_trace
    );

  Req <= Ready;
  Addr <= '0' & addr_trace(30 downto 0);
  Data <= data_trace when (addr_trace(31) = '1')
     else (others => '0');
  WR <= addr_trace(31);
  cmp <= '1' when DataIn = data_trace_lag else '0';
  process(clk)
  begin
    if rising_edge(clk) then
      Err <= Ready and (not addr_trace_lag(31)) and (not cmp) and (not rst);
    end if;
  end process;
end mix;
