library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity full_adder is
  port(
       A : in std_logic;
       B : in std_logic;
       cin : in std_logic;
       cout : out std_logic;
       sum : out std_logic
  );
end full_adder;

architecture structural of full_adder is

component and_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;

component xor_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;

component or_gate is
  port (
    x   : in  std_logic;
    y   : in  std_logic;
    z   : out std_logic
  );
end component;

signal and_out : std_logic_vector(2 downto 0);
signal xor_out_0 : std_logic;
signal or_out_0 : std_logic;

begin
  X0 : xor_gate port map(x=>A, y=>B, z=>xor_out_0);
  X1 : xor_gate port map(x=>cin, y=>xor_out_0, z=>sum);
  A0 : and_gate port map(x=>A, y=>B, z=>and_out(0));
  A1 : and_gate port map(x=>A, y=>cin, z=>and_out(1));
  A2 : and_gate port map(x=>B, y=>cin, z=>and_out(2));
  O0 : or_gate port map(x=>and_out(0), y=>and_out(1), z=>or_out_0);
  O1 : or_gate port map(x=>or_out_0, y=>and_out(2), z=>cout);
end architecture structural;
