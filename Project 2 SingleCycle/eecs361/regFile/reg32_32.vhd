library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity reg32_32 is
  port (
        clk : in std_logic;
        rw : in std_logic_vector(4 downto 0);
        ra : in std_logic_vector(4 downto 0);
        rb : in std_logic_vector(4 downto 0);
        we : in std_logic;
        busw : in std_logic_vector(31 downto 0);
        busa : out std_logic_vector(31 downto 0);
        busb : out std_logic_vector(31 downto 0)
  );
end entity;

architecture structural of reg32_32 is
  type array32_32 is array (31 downto 0) of std_logic_vector(31 downto 0);
  signal reg_out : array32_32;
  signal mux_in : array32_32;
  signal decoder_out : std_logic_vector(31 downto 0);
  signal we_vector : std_logic_vector(31 downto 1);
  constant zeroSrc : std_logic_vector(31 downto 0) := (others => '0');
  begin
    dec_write: dec_n generic map (n => 5)
                     port map (src => rw, z => decoder_out);

    we_vec : for i in 1 to 31 generate
      we_and : and_gate port map (decoder_out(i), we, we_vector(i));
    end generate;

    regfile : for i in 1 to 31 generate
      reg : reg32 port map (clk, busw, we_vector(i), reg_out(i));
    end generate;

    reg_out(0) <= zeroSrc;

    mix: for i in 0 to 31 generate
      inner_mix:for j in 0 to 31 generate
        mux_in(i)(j) <= reg_out(j)(i);
      end generate;
    end generate;

    busa_pick : for i in 0 to 31 generate
      muxera : mux_32to1 port map (mux_in(i), ra, busa(i));
    end generate;

    busb_pick : for i in 0 to 31 generate
      muxerb : mux_32to1 port map (mux_in(i), rb, busb(i));
    end generate;

end architecture;
