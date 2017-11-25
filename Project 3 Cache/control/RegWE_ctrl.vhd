library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity RegWE_ctrl is
  port (
        miss : in std_logic;
        cpuReq : in std_logic;
        current_state : in std_logic_vector(1 downto 0);

        cpuWr_we : out std_logic;
        cpuAddr_we : out std_logic;
        cpuDin_we : out std_logic;
        cpuDout_we : out std_logic;
        cpuReady_we : out std_logic;
        L2Addr_we : out std_logic;
        L2Dout_we : out std_logic;
        prevState_we : out std_logic;
        repAddr_we : out std_logic;
        repData_we : out std_logic
  );
end entity;

architecture structural of RegWE_ctrl is
  signal idle_state, comptag_state, writeback_state, allocate_state : std_logic;
  signal cpuWAD, cpuDR, Rep, not_miss : std_logic;
  begin
    pla2_idle : pla2
      port map (
        din => current_state,
        inv => "11",
        z   => idle_state
      );
    pla2_comptag : pla2
      port map (
        din => current_state,
        inv => "10",
        z   => comptag_state
      );
    pla2_writeback : pla2
      port map (
        din => current_state,
        inv => "01",
        z   => writeback_state
      );
    pla2_allocate : pla2
      port map (
        din => current_state,
        inv => "00",
        z   => allocate_state
      );
-------------------------------------------------------------------------------
    cpuWAD_and: and_gate port map(x=>cpuReq, y=>idle_state, z=>cpuWAD);
    cpuWr_we <= cpuWAD;
    cpuAddr_we <= cpuWAD;
    cpuDin_we <= cpuWAD;
-------------------------------------------------------------------------------
    miss_not_g: not_gate port map(x=>miss, z=>not_miss);
    cpuDR_and: and_gate port map(x=>not_miss, y=>comptag_state, z=>cpuDR);
    cpuDout_we <= cpuDR;
    cpuReady_we <= cpuDR;
-------------------------------------------------------------------------------
    L2addr_or_g: or_gate port map(x=>writeback_state, y=>allocate_state, z=>L2Addr_we);
-------------------------------------------------------------------------------
    L2Dout_we <= writeback_state;
-------------------------------------------------------------------------------
    prevState_we <= '1';
-------------------------------------------------------------------------------
    rep_and: and_gate port map(x=>miss, y=>comptag_state, z=>Rep);
    repAddr_we <= Rep;
    repData_we <= Rep;
  end architecture;
