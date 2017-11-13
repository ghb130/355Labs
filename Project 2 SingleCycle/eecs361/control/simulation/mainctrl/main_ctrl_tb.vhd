library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity main_ctrl_tb is
end entity;

architecture behavioral of main_ctrl_tb is

  component main_ctrl
    port (
      opcode   : in  std_logic_vector(5 downto 0);
      RegDst   : out std_logic;
      RegWr    : out std_logic;
      Branch   : out std_logic;
      ExtOp    : out std_logic;
      ALUsrc   : out std_logic;
      MemWr    : out std_logic;
      MemtoReg : out std_logic;
      BrSel    : out std_logic_vector(1 downto 0)
    );
  end component main_ctrl;

  signal opcode_tb   : std_logic_vector(5 downto 0);
  signal RegDst_tb   : std_logic;
  signal RegWr_tb    : std_logic;
  signal Branch_tb   : std_logic;
  signal ExtOp_tb    : std_logic;
  signal ALUsrc_tb   : std_logic;
  signal MemWr_tb    : std_logic;
  signal MemtoReg_tb : std_logic;
  signal BrSel_tb    : std_logic_vector(1 downto 0);

begin
  dut: main_ctrl
          port map (
            opcode   => opcode_tb,
            RegDst   => RegDst_tb,
            RegWr    => RegWr_tb,
            Branch   => Branch_tb,
            ExtOp    => ExtOp_tb,
            ALUsrc   => ALUsrc_tb,
            MemWr    => MemWr_tb,
            MemtoReg => MemtoReg_tb,
            BrSel    => BrSel_tb
          );

  stimOpcode: process is
    begin
      opcode_tb <= "000000"; wait for 5 ns;
      opcode_tb <= "100011"; wait for 5 ns;
      opcode_tb <= "101011"; wait for 5 ns;
      opcode_tb <= "000100"; wait for 5 ns;
      opcode_tb <= "000101"; wait for 5 ns;
      opcode_tb <= "000111"; wait for 5 ns;
      opcode_tb <= "001000"; wait for 5 ns;
      wait;
    end process;

end architecture;
