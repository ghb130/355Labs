library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.eecs361.all;
  use work.eecs361_gates.all;

entity single_cycle_processor is
  port (
    clk : in std_logic;
    pcInit : in std_logic
  );
end entity;

architecture arch of single_cycle_processor is
  signal RegDst          : std_logic;
  signal Regwr           : std_logic;
  signal Branch          : std_logic;
  signal ExtOp           : std_logic;
  signal ALUSrc          : std_logic;
  signal ALUCtrl         : std_logic_vector (3 downto 0);
  signal MemWr           : std_logic;
  signal MemtoReg        : std_logic;
  signal BranchSel       : std_logic_vector (1 downto 0);
  signal currInstruction : std_logic_vector (31 downto 0);

begin
  alu_ctrl_i : alu_ctrl
  port map (
    opcode => currInstruction(31 downto 26),
    funct  => currInstruction(5 downto 0),
    ALUop  => ALUCtrl
  );

  main_ctrl_i : main_ctrl
  port map (
    opcode   => currInstruction(31 downto 26),
    RegDst   => RegDst,
    RegWr    => RegWr,
    Branch   => Branch,
    ExtOp    => ExtOp,
    ALUsrc   => ALUsrc,
    MemWr    => MemWr,
    MemtoReg => MemtoReg,
    BrSel    => BranchSel
  );

  datapath_i : datapath
  port map (
    RegDst          => RegDst,
    Regwr           => Regwr,
    Branch          => Branch,
    ExtOp           => ExtOp,
    ALUSrc          => ALUSrc,
    ALUCtrl         => ALUCtrl,
    MemWr           => MemWr,
    MemtoReg        => MemtoReg,
    BranchSel       => BranchSel,
    pcInit          => pcInit,
    currInstruction => currInstruction,
    clk             => clk
  );

end architecture;
