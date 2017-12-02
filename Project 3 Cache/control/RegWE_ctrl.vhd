library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity RegWE_ctrl is
  port (
        miss : in std_logic;
        cpuReq : in std_logic;
        dirty : in std_logic;
        current_state : in std_logic_vector(1 downto 0);
        last_state : in std_logic(1 downto 0);
        valid : in std_logic;

        cpuWr_we : out std_logic;
        cpuAddr_we : out std_logic;
        cpuDin_we : out std_logic;
        cpuDout_we : out std_logic;
        cpuReady_we : out std_logic;
        L2Addr_we : out std_logic;
        L2Dout_we : out std_logic;
        LRU_we : out std_logic;
        prevState_we : out std_logic;
        repAddr_we : out std_logic;
        repData_we : out std_logic

        hit_we : out std_logic;
        miss_we : out std_logic;
        evict_we : out std_logic

  );
end entity;

architecture structural of RegWE_ctrl is
  signal idle_state, comptag_state, writeback_state, allocate_state, idle_state_last, comptag_state_last : std_logic;
  signal cpuWAD, cpuDR, Rep, not_miss, not_dirty, LRU_inter, h, m, miss0_i, miss1_i, hit_i, not_valid : std_logic;
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

    pla2_idle_last : pla2
      port map (
        din => last_state,
        inv => "11",
        z   => idle_state_last
      );
    pla2_comptag_last : pla2
      port map (
        din => last_state,
        inv => "10",
        z   => comptag_state_last
      );

    dirty_not_g: not_gate port map(x=>dirty, z=>not_dirty);
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
-------------------------------------------------------------------------------
    --LRU_and1: and_gate port map(x=>not_miss, y=>not_dirty, z=>LRU_inter);
    LRU_and2: and_gate port map(x=>idle_state, y=>comptag_state_last, z=>LRU_we);
-------------------------------------------------------------------------------
    not_valid_g: not_gate port map(x=>valid, z=>not_valid);
    miss_and0: and_gate port map(x=>comptag_state_last, y=>allocate_state, z=>miss0_i);
    miss_and1: and_gate port map(x=>comptag_state_last, y=>writeback_state, z=>miss1_i);
    miss_or: or_gate port map(x=>miss0_i, y=>miss1_i, z=>m);
    hit_and0: and_gate port map(x=>idle_state_last, y=>comptag_state, z=>hit_i);
    hit_and: and_gate port map(x=>hit_i, y=>not_miss, z=>h);
    evict_and: and_gate port map(x=>idle_state_last, comptag_state_last, evict_we_i);
    evict_and2: and_gate port map(x=>evict_we_i, y=>not_valid, z=>evict_we);
    hit_we <= h;
    miss_we <= m;
  end architecture;
