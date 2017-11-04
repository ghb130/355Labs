library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use ieee.numeric_std.all;

entity ifu_tb is
end entity ifu_tb;

architecture behavioral of ifu_tb is
component ifu is
  port (
        init : in std_logic;
        pc_init_val : in std_logic_vector(29 downto 0);
        clk : in std_logic;
        imm16 : in std_logic_vector(15 downto 0);
        zero : in std_logic;
        branch : in std_logic;
        addr_out : out std_logic_vector(31 downto 0)
  );
end component;
signal hold : std_logic := '0';
signal init_tb : std_logic;
signal pc_init_val_tb : std_logic_vector(29 downto 0);
signal clk_tb : std_logic;
signal branch_tb : std_logic;
signal zero_tb : std_logic;
signal imm16_tb : std_logic_vector(15 downto 0);
signal addr_out_tb : std_logic_vector(31 downto 0);
begin
  dut: ifu
    port map (
      init=>init_tb,
      pc_init_val=>pc_init_val_tb,
      clk=>clk_tb,
      imm16=>imm16_tb,
      zero=>zero_tb,
      branch=>branch_tb,
      addr_out=>addr_out_tb
    );

  clock_generate: process is
    begin
      clk_tb<='0';
      wait for 1 ns;
      clk_tb <= not clk_tb;
      wait for 1 ns;
    	if hold = '1' then
    	  wait;
      	end if;
    end process clock_generate;

    initialize: process is
      begin
        init_tb <= '1'; pc_init_val_tb <= "000000000100000000000000001000"; wait for 2 ns;
        init_tb <= '0';
        wait;
    end process initialize;

    stim_bz: process is
      begin
        branch_tb <= '1'; zero_tb <= '1'; wait for 6 ns;
        branch_tb <= '0'; zero_tb <= '1';
        wait;
    end process stim_bz;

    stim_imm: process is
      begin
        wait for 2 ns;
        imm16_tb<=std_logic_vector(to_signed(16, 16)); wait for 2 ns;
        imm16_tb<=std_logic_vector(to_signed(256, 16)); wait for 2 ns;
        imm16_tb<=std_logic_vector(to_signed(4, 16)); wait for 2 ns;
    end process stim_imm;

    stop_clk : process is
    begin
      wait for 20 ns;
      hold <= '1';
    end process;
end architecture;
