library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.eecs361.all;
use work.eecs361_gates.all;

--Additional standard or custom libraries go here
entity ssp_tb is
end entity ssp_tb;

architecture behavioral of ssp_tb is
  signal pcInit_tb, clk_tb, hold    : std_logic;
begin

  single_cycle_processor_i : single_cycle_processor
  port map (
  clk    => clk_tb,
  pcInit => pcInit_tb
  );

  clock_generate : process is
    begin
      clk_tb<='0';
      wait for 5 ns;
      clk_tb <= not clk_tb;
      wait for 5 ns;
  	if hold = '1' then
  	  wait;
    end if;
  end process clock_generate;

  process is
    variable init : boolean := false;
    begin
      if not init then
        pcInit_tb <= '1';
        wait for 7 ns;
        pcInit_tb <= '0';
        init := true;
      else
        wait;
      end if;
    end process;

end architecture behavioral;
