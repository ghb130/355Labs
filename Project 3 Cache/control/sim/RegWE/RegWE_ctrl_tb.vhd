library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity RegWE_ctrl_tb is
end entity;

architecture behavioral of RegWE_ctrl_tb is
  component RegWE_ctrl
    port (
      miss          : in  std_logic;
      cpuReq        : in  std_logic;
      dirty         : in std_logic;
      current_state : in  std_logic_vector(1 downto 0);
      last_state    : in  std_logic_vector(1 downto 0);
      
      cpuWr_we      : out std_logic;
      cpuAddr_we    : out std_logic;
      cpuDin_we     : out std_logic;
      cpuDout_we    : out std_logic;
      cpuReady_we   : out std_logic;
      L2Addr_we     : out std_logic;
      L2Dout_we     : out std_logic;
      LRU_we        : out std_logic;
      prevState_we  : out std_logic;
      repAddr_we    : out std_logic;
      repData_we    : out std_logic
      hit_we        : out std_logic;
      miss_we       : out std_logic
    );
  end component RegWE_ctrl;

  signal miss_tb          : std_logic;
  signal cpuReq_tb        : std_logic;
  signal dirty_tb         : std_logic;
  signal current_state_tb : std_logic_vector(1 downto 0);
  signal last_state_tb    : std_logic_vector(1 downto 0);
  signal cpuWr_we_tb      : std_logic;
  signal cpuAddr_we_tb    : std_logic;
  signal cpuDin_we_tb     : std_logic;
  signal cpuDout_we_tb    : std_logic;
  signal cpuReady_we_tb   : std_logic;
  signal L2Addr_we_tb     : std_logic;
  signal L2Dout_we_tb     : std_logic;
  signal LRU_we_tb        : std_logic;
  signal prevState_we_tb  : std_logic;
  signal repAddr_we_tb    : std_logic;
  signal repData_we_tb    : std_logic;
  signal hit_we_tb        : std_logic;
  signal miss_we_tb       : std_logic;


begin
  dut : RegWE_ctrl
    port map (
      miss          => miss_tb,
      cpuReq        => cpuReq_tb,
      dirty         => dirty_tb,
      current_state => current_state_tb,
      last_state    => last_state_tb,
      cpuWr_we      => cpuWr_we_tb,
      cpuAddr_we    => cpuAddr_we_tb,
      cpuDin_we     => cpuDin_we_tb,
      cpuDout_we    => cpuDout_we_tb,
      cpuReady_we   => cpuReady_we_tb,
      L2Addr_we     => L2Addr_we_tb,
      L2Dout_we     => L2Dout_we_tb,
      LRU_we        => LRU_we_tb,
      prevState_we  => prevState_we_tb,
      repAddr_we    => repAddr_we_tb,
      repData_we    => repData_we_tb,
      hit_we        => hit_we_tb,
      miss_we       => miss_we_tb
    );

    stim_Req: process is
      begin
        cpuReq_tb <= '1'; wait for 5 ns;
        cpuReq_tb <= '0'; wait for 5 ns;
        wait;
      end process;

    stim_miss: process is
      begin
        miss_tb <= '0'; wait for 10 ns;
        miss_tb <= '1'; wait for 5 ns;
        miss_tb <= '0'; wait for 5 ns;
        wait;
      end process;
    stim_dirty: process is
      begin
        dirty_tb <= '0'; wait for 10 ns;
        dirty_tb <= '1'; wait for 5 ns;
        dirty_tb <= '0'; wait for 5 ns;
        wait;
      end process;
    stim_state: process is
      begin
        current_state_tb <= "00"; wait for 10 ns; --idle
        current_state_tb <= "01"; wait for 10 ns; --comp_tag
        current_state_tb <= "10"; wait for 10 ns; --write_back
        current_state_tb <= "11"; wait for 10 ns; --allocate
        wait;
      end process;

end architecture;
