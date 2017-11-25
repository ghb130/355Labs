library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity NextState_ctrl is
  port (
        current_state : in std_logic_vector(1 downto 0);
        miss : in std_logic;
        cpuReq : in std_logic;
        L2Ready : in std_logic;
        dirty : in std_logic;
        prev_state : in std_logic_vector(1 downto 0);

        next_state : out std_logic_vector(1 downto 0)
  );
end entity;

architecture structural of NextState_ctrl is
  signal ns00, ns01, ns02, ns03, ns04 : std_logic;
  signal ns10, ns11, ns12, ns13, ns14 : std_logic;
  signal ns00_in, ns01_in, ns02_in, ns03_in, ns04_in : std_logic_vector(4 downto 0);
  signal ns10_in, ns11_in : std_logic_vector(4 downto 0);

begin
--------------------------------------------------------
  ns00_in(4) <= current_state(1);
  ns00_in(3) <= current_state(0);
  ns00_in(2) <= cpuReq;
  ns00_in(1 downto 0) <= "11";
  PLA_ns00 : pla5
    port map (
      din => ns00_in,
      inv => "11000",
      z   => ns00
    );
----------------------------------------------------------
  ns01_in(4) <= current_state(1);
  ns01_in(3) <= current_state(0);
  ns01_in(2) <= L2Ready;
  ns01_in(1 downto 0) <= prev_state;
  PLA_ns01 : pla5
    port map (
      din => ns01_in,
      inv => "00000",
      z   => ns01
    );
----------------------------------------------------------
  ns02_in(4) <= current_state(1);
  ns02_in(3) <= current_state(0);
  ns02_in(2) <= L2Ready;
  ns02_in(1 downto 0) <= prev_state;
  PLA_ns02 : pla5
    port map (
      din => ns02_in,
      inv => "01001",
      z   => ns02
    );
    ns12 <= ns02;
----------------------------------------------------------
  ns03_in(4) <= current_state(1);
  ns03_in(3) <= current_state(0);
  ns03_in(2) <= miss;
  ns03_in(1) <= dirty;
  ns03_in(0) <= '1';
  PLA_ns03 : pla5
    port map (
      din => ns03_in,
      inv => "10010",
      z   => ns03
    );
    ns13 <= ns03;
----------------------------------------------------------
  ns04_in(4) <= current_state(1);
  ns04_in(3) <= current_state(0);
  ns04_in(2) <= L2Ready;
  ns04_in(1) <= '1';
  ns04_in(0) <= '1';
  PLA_ns04 : pla5
    port map (
      din => ns04_in,
      inv => "00100",
      z   => ns04
    );
    ns14 <= ns04;
--------------------------------------------------------
  ns10_in(4) <= current_state(1);
  ns10_in(3) <= current_state(0);
  ns10_in(2) <= miss;
  ns10_in(1) <= dirty;
  ns10_in(0) <= '1';
  PLA_ns10 : pla5
    port map (
      din => ns10_in,
      inv => "10000",
      z   => ns10
    );
--------------------------------------------------------
  ns11_in(4) <= current_state(1);
  ns11_in(3) <= current_state(0);
  ns11_in(2) <= L2Ready;
  ns11_in(1) <= '1';
  ns11_in(0) <= '1';
  PLA_ns11 : pla5
    port map (
      din => ns11_in,
      inv => "01100",
      z   => ns11
    );
---------------------------------------------------------

OR0: or5to1 port map(a=>ns00, b=>ns01, c=>ns02, d=>ns03, e=>ns04, z=>next_state(0));
OR1: or5to1 port map(a=>ns10, b=>ns11, c=>ns12, d=>ns13, e=>ns14, z=>next_state(1));

end architecture;
