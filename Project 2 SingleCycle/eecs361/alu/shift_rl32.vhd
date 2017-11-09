library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eecs361_gates.all;

entity shift_rl32 is
  port (
        din : in std_logic_vector(31 downto 0);
        samt : in std_logic_vector(4 downto 0);
        dout : out std_logic_vector(31 downto 0)
  );
end entity shift_rl32;

architecture structural of shift_rl32 is

  component mux is
    port (
          sel : in	std_logic;
          src0 : in	std_logic;
          src1 : in	std_logic;
          z	: out std_logic
    );
  end component;

  type level_mem is array(0 to 4) of std_logic_vector(31 downto 0);
  signal level_sigs : level_mem;
  begin
    LVL_GEN : for i in 0 to 4 generate
      L0 : if i = 0 generate
        MUX_GEN0 : for j in 0 to 31 generate
          lower0 : if j <= 31-2**i generate
            lower_muxes : mux port map(sel=>samt(i), src0=>din(j), src1=>din(j+2**i), z=>level_sigs(i)(j));
          end generate;
           upper0 : if j > 31-2**i generate
             upper_muxes : mux port map(sel=>samt(i), src0=>din(j), src1=>'0', z=>level_sigs(i)(j));
           end generate;
        end generate;
      end generate;
      L1to3 : if i > 0 and i < 4 generate
        MUX_GEN1 : for j in 0 to 31 generate
          lower1 : if j <= 31-2**i generate
            lower_muxes : mux port map(sel=>samt(i), src0=>level_sigs(i-1)(j), src1=>level_sigs(i-1)(j+2**i), z=>level_sigs(i)(j));
          end generate;
           upper1 : if j > 31-2**i generate
             upper_muxes : mux port map(sel=>samt(i), src0=>level_sigs(i-1)(j), src1=>'0', z=>level_sigs(i)(j));
           end generate;
        end generate;
      end generate;
      L5 : if i = 4 generate
        MUX_GEN2 : for j in 0 to 31 generate
          lower2 : if j <= 31-2**i generate
            lower_muxes : mux port map(sel=>samt(i), src0=>level_sigs(i-1)(j), src1=>level_sigs(i-1)(j+2**i), z=>dout(j));
          end generate;
           upper2 : if j > 31-2**i generate
             upper_muxes : mux port map(sel=>samt(i), src0=>level_sigs(i-1)(j), src1=>'0', z=>dout(j));
           end generate;
        end generate;
      end generate;
    end generate;
  end architecture structural;
