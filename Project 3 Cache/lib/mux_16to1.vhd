library ieee;
use ieee.std_logic_1164.all;
use WORK.eecs361.all;

entity mux_16to1 is
  port (
    a   : in  std_logic_vector(15 downto 0);
    sel : in std_logic_vector(3 downto 0);
    z   : out std_logic
  );
end mux_32to1;

architecture structural of mux_16to1 is
  signal layer2_sig : std_logic_vector(7 downto 0);
  signal layer3_sig : std_logic_vector(3 downto 0);
  signal layer4_sig : std_logic_vector(1 downto 0);
begin
  mux_gen_layer2 : for i in 0 to 7 generate
    layer2 : mux port map(sel(0), layer1_sig(2*i), layer1_sig(2*i+1), layer2_sig(i));
  end generate;
  mux_gen_layer3 : for i in 0 to 3 generate
    layer3 : mux port map(sel(1), layer2_sig(2*i), layer2_sig(2*i+1), layer3_sig(i));
  end generate;
  mux_gen_layer4 : for i in 0 to 1 generate
    layer4 : mux port map(sel(2), layer3_sig(2*i), layer3_sig(2*i+1), layer4_sig(i));
  end generate;
    layer5 : mux port map(sel(3), layer4_sig(0), layer4_sig(1), z);
end structural;
