library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity add_1b_tb is
end entity add_1b_tb;

architecture behavioral of add_1b_tb is

  component add_1b is
    port(
         a_1 : in std_logic;
         b_1 : in std_logic;
         cin_1 : in std_logic;
         cout_1 : out std_logic;
         sum_1 : out std_logic
    );
  end component;

  signal A_tb : std_logic;
  signal B_tb : std_logic;
  signal cin_tb : std_logic;
  signal cout_tb : std_logic;
  signal sum_tb : std_logic;

  begin
    dut : add_1b port map(
      a_1=>A_tb,
      b_1=>B_tb,
      cin_1=>cin_tb,
      cout_1=>cout_tb,
      sum_1=>sum_tb
    );

    stim_A: process is
      begin
        A_tb<='0'; wait for 20 ns;
        A_tb<='1';
        wait;
      end process stim_A;

      stim_B: process is
        begin
          B_tb<='0'; wait for 10 ns;
          B_tb<='1'; wait for 10 ns;
          B_tb<='0'; wait for 10 ns;
          B_tb<='1';
          wait;
        end process stim_B;

        stim_cin: process is
          begin
            cin_tb<='0'; wait for 5 ns;
            cin_tb<='1'; wait for 5 ns;
            cin_tb<='0'; wait for 5 ns;
            cin_tb<='1'; wait for 5 ns;
            cin_tb<='0'; wait for 5 ns;
            cin_tb<='1'; wait for 5 ns;
            cin_tb<='0'; wait for 5 ns;
            cin_tb<='1';
            wait;
          end process stim_cin;
  end architecture;
