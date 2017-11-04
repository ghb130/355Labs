library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
entity extender_n is
  generic (n : integer := 30);
  port (
        a : in std_logic_vector(15 downto 0);
        sel : in std_logic;
        z : out std_logic_vector(n-1 downto 0)
  );
end entity;

architecture structural of extender_n is
  component mux is
    port (
  	sel	  : in	std_logic;
  	src0  :	in	std_logic;
  	src1  :	in	std_logic;
  	z	  : out std_logic
    );
  end component;
  signal ext_bit : std_logic;
  begin
    M0 : mux port map(sel=>sel, src0=>'0', src1=>a(15), z=>ext_bit);
    z(15 downto 0) <= a;
    extend: for i in 16 to n-1 generate
      z(i) <= ext_bit;
    end generate;
end architecture;
