library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity pc_reg is
  port (
        clk : in std_logic;
        din : in std_logic_vector(29 downto 0);
        dout : out std_logic_vector(29 downto 0)
  );
end entity;

  architecture structural of pc_reg is
    component dffr is
      port (
    	clk	: in  std_logic;
    	d	: in  std_logic;
    	q	: out std_logic
      );
    end component;
    begin
      dff_gen: for i in 0 to 29 generate
        dffRE: dffr port map(clk=>clk, d=>din(i), q=>dout(i));
      end generate;

  end architecture;
