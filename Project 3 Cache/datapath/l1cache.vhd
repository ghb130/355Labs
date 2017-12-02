library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361_gates.all;
  use work.eecs361.all;

entity l1cache is
  port (
  clk       : in std_logic;
  rst       : in std_logic;
  en        : in std_logic;

  cpuReq    : in  std_logic;
  cpuWr     : in  std_logic;
  cpuAddr   : in  std_logic_vector(31 downto 0);
  cpuDin    : in  std_logic_vector(31 downto 0);
  cpuDout   : out std_logic_vector(31 downto 0);
  cpuReady  : out std_logic;

  l2Req     : out std_logic;
  l2Wr      : out std_logic;
  l2Addr    : out std_logic_vector(31 downto 0);
  l2Dout    : out std_logic_vector((64*8-1) downto 0);
  l2Din     : in  std_logic_vector((64*8-1) downto 0);
  l2Ready   : in  std_logic;

  hit_cnt   : out std_logic_vector(31 downto 0);
  miss_cnt  : out std_logic_vector(31 downto 0);
  evict_cnt : out std_logic_vector(31 downto 0)
  );
end entity;

architecture arch of l1cache is
------------------Output Signals for all Registers----------------------------
--------IN--------------
signal cpuWr_i : std_logic;
signal cpuAddr_i : std_logic_vector(31 downto 0);
signal cpuDin_i : std_logic_vector(31 downto 0);
signal next_state : stD_logic_vector(1 downto 0);
--------OUT-------------
signal cpuReady_i : std_logic;
signal cpuDout_i : std_logic_vector(31 downto 0);
signal l2Addr_i : std_logic_vector(31 downto 0);
signal l2Dout_i : std_logic_vector((64*8-1) downto 0);
signal prev_state : std_logic_vector(1 downto 0);
signal current_state : std_logic_vector(1 downto 0);
-------Internal---------
signal repAddr_i : std_logic_vector(31 downto 0);
signal repData_i : std_logic_vector((64*8-1) downto 0);
signal repAddr : std_logic_vector(31 downto 0);
signal repData : std_logic_vector((64*8-1) downto 0);
signal dirty : std_logic;
signal miss : std_logic;
signal LRUwe_i : std_logic_vector(31 downto 0);
signal LRUwe : std_logic_vector(31 downto 0);
signal LRUDataOut : std_logic_vector(31 downto 0);

signal ovrwr   : std_logic;
signal cache_addr    : std_logic_vector(25 downto 0);
signal cache_LRU     : std_logic;
signal cache_new_LRU : std_logic;
signal cache_din     : std_logic_vector(511 downto 0);
signal cache_we      : std_logic;
signal cache_dout    : std_logic_vector(534 downto 0);
signal miss    : std_logic;
signal dirty   : std_logic;
signal L2Addr_sel : std_logic;

--------Write Enables---
signal cpuWr_we      : std_logic;
signal cpuAddr_we    : std_logic;
signal cpuDin_we     : std_logic;
signal cpuDout_we    : std_logic;
signal cpuReady_we   : std_logic;
signal L2Addr_we     : std_logic;
signal L2Dout_we     : std_logic;
signal prevState_we  : std_logic;
signal repAddr_we    : std_logic;
signal repData_we    : std_logic;
signal LRUData_we    : std_logic;

------------------IMPLEMENTATION----------------------------------------------
--Registers have been set up. Logic needs to be implemented to drive:
--cpuDout_i
--cpuReady_i
--l2Addr_i
--l2Dout_i
--repAddr_i
--repData_i

--A cach data storage component needs to be implemented
begin
------------------Top level components----------------------------------------
NextState_ctrl_i : NextState_ctrl
port map (
  current_state => current_state,
  miss          => miss,
  cpuReq        => cpuReq,
  L2Ready       => L2Ready,
  dirty         => dirty,
  prev_state    => prev_state,
  next_state    => next_state
);

RegWE_ctrl_i : RegWE_ctrl
port map (
--Input
  miss          => miss,
  cpuReq        => cpuReq,
  dirty         => dirty,
  current_state => current_state,
  last_state    => last_state,
--Output
  cpuWr_we     => cpuWr_we,
  cpuAddr_we   => cpuAddr_we,
  cpuDin_we    => cpuDin_we,
  cpuDout_we   => cpuDout_we,
  cpuReady_we  => cpuReady_we,
  L2Addr_we    => L2Addr_we,
  L2Dout_we    => L2Dout_we,
  LRU_we       => LRU_we,
  prevState_we => prevState_we,
  repAddr_we   => repAddr_we,
  repData_we   => repData_we,
  hit_we       => hit_we,
  miss_we      => miss_we
);


cache_i : cache
port map (
  clk     => clk,
  ovrwr   => ovrwr,
  addr    => cache_addr,
  LRU     => cache_LRU,
  new_LRU => cache_new_LRU,
  din     => cache_din,
  we      => cache_we,
  dout    => cache_dout,
  miss    => miss,
  dirty   => dirty
);
------------------STATE REGISTERS---------------------------------------------
current_s : reg_n
generic map (
  n => 2
)
port map (
  clk  => clk,
  rst  => rst,
  din  => next_state,
  we   => '1',
  dout => current_state
);

last_s : reg_n
generic map (
  n => 2
)
port map (
  clk  => clk,
  rst  => rst,
  din  => current_state,
  we   => '1',
  dout => prev_state
);
------------------STATE: IDLE-------------------------------------------------
--------Registers--------
save_cpuWr : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
        d => cpuWr, enable => cpuWr_we, q => cpuWr_i);

save_cpuAddr : reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => cpuAddr,
  we   => cpuAddr_we,
  dout => cpuAddr_i
);

save_cpuDin : reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => cpuDin,
  we   => cpuDin_we,
  dout => cpuDin_i
);
------------------STATE: COMPTAG----------------------------------------------
--------Registers--------
reg_cpuReady : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
        d => cpuReady_we, enable => '1', q => cpuReady);


reg_cpuDout : reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => cpuDout_i,
  we   => cpuDout_we,
  dout => cpuDout
);

cpuDout_i <= cache_dout(511 downto 0);

reg_repAddr : reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => repAddr_i,
  we   => repAddr_we,
  dout => repAddr
);

repAddr_i(25 downto 5) <= cache_dout(532 downto 512);
repAddr_i(4 downto 0) <= cpuAddr_i(10 downto 6);

reg_repDin: reg_n
generic map (
  n => 512
)
port map (
  clk  => clk,
  rst  => rst,
  din  => repData_i,
  we   => repData_we,
  dout => repData
);

repData_i <= cache_dout(511 downto 0);

reg_LRU: reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => LRUData_i,
  we   => LRUData_we,
  dout => LRUData
);

wrLocDecoder : dec_n generic map(n => 5)
                    port map(cpuAddr_i(10 downto 6), LRUwe);

reg_LRU : for i in 0 to 31 generate
    reg_LRU_bit : dffr_a port map (clk => clk, arst => rst, aload => '0', adata => '0',
        d => cache_new_LRU, enable => LRUwe(i), q => LRUDataOut);
end generate;
lruSelect : mux_32to1 port map (LRUDataOut, cpuAddr_i(10 downto 6), cache_LRU);

------------------STATE: WRITEBACK--------------------------------------------
--------Registers--------
reg_l2Addr : reg_n
generic map (
  n => 32
)
port map (
  clk  => clk,
  rst  => rst,
  din  => l2Addr_i,
  we   => L2Addr_we,
  dout => l2Addr
);

sel_and: and_gate port map(x=>current_state(0), y=>current_state(1), z=> L2Addr_sel);
L2Addr_mux: mux port map(sel=>L2Addr_sel, src0=>repAddr, src1=>cpuAddr_i, z=>L2Addr_i);

reg_l2Dout : reg_n
generic map (
  n => 512
)
port map (
  clk  => clk,
  rst  => rst,
  din  => l2Dout_i,
  we   => L2Dout_we,
  dout => l2Dout
);
------------------STATE: ALLOC------------------------------------------------
--------Registers--------
--Uses reg_l2Addr
end architecture;
