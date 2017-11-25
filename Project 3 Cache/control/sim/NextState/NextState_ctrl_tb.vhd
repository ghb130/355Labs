library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity NextState_ctrl_tb is
end entity;

architecture behavioral of NextState_ctrl_tb is
  component NextState_ctrl
    port (
      current_state : in  std_logic_vector(1 downto 0);
      miss          : in  std_logic;
      cpuReq        : in  std_logic;
      L2Ready       : in  std_logic;
      dirty         : in  std_logic;
      prev_state    : in  std_logic_vector(1 downto 0);
      next_state    : out std_logic_vector(1 downto 0)
    );
  end component NextState_ctrl;

  signal current_state_tb : std_logic_vector(1 downto 0);
  signal miss_tb          : std_logic;
  signal cpuReq_tb        : std_logic;
  signal L2Ready_tb       : std_logic;
  signal dirty_tb         : std_logic;
  signal prev_state_tb    : std_logic_vector(1 downto 0);
  signal next_state_tb    : std_logic_vector(1 downto 0);


begin

  dut : NextState_ctrl
    port map (
      current_state => current_state_tb,
      miss          => miss_tb,
      cpuReq        => cpuReq_tb,
      L2Ready       => L2Ready_tb,
      dirty         => dirty_tb,
      prev_state    => prev_state_tb,
      next_state    => next_state_tb
    );

  stim_input: process is
    begin
      current_state_tb<="01"; miss_tb<='0'; cpuReq_tb<='0'; L2Ready_tb<='0'; dirty_tb<='0'; prev_state_tb<= "00";
      wait for 5 ns;
      current_state_tb<="00"; miss_tb<='0'; cpuReq_tb<='1'; L2Ready_tb<='0'; dirty_tb<='0'; prev_state_tb<= "00";
      wait for 5 ns;
      current_state_tb<="11"; miss_tb<='0'; cpuReq_tb<='1'; L2Ready_tb<='1'; dirty_tb<='0'; prev_state_tb<= "11";
      wait for 5 ns;
      current_state_tb<="01"; miss_tb<='1'; cpuReq_tb<='1'; L2Ready_tb<='1'; dirty_tb<='1'; prev_state_tb<= "11";
      wait for 5 ns;
      current_state_tb<="10"; miss_tb<='0'; cpuReq_tb<='1'; L2Ready_tb<='0'; dirty_tb<='0'; prev_state_tb<= "11";
      wait for 5 ns;
      current_state_tb<="10"; miss_tb<='0'; cpuReq_tb<='1'; L2Ready_tb<='1'; dirty_tb<='0'; prev_state_tb<= "10";
      wait for 5 ns;
      current_state_tb<="01"; miss_tb<='1'; cpuReq_tb<='1'; L2Ready_tb<='1'; dirty_tb<='0'; prev_state_tb<= "11";
      wait for 5 ns;
      current_state_tb<="11"; miss_tb<='0'; cpuReq_tb<='1'; L2Ready_tb<='0'; dirty_tb<='0'; prev_state_tb<= "11";
      wait;
    end process;

end architecture;
