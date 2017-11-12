library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity datapath is
  port (
    RegDst : in std_logic;
    Regwr : in std_logic;
    Branch : in std_logic;
    ExtOp : in std_logic;
    ALUSrc : in std_logic;
    ALUCtrl : in std_logic_vector (3 downto 0);
    MemWr : in std_logic;
    MemtoReg : in std_logic;
    BranchSel : in std_logic_vector (1 downto 0);
    pcInit : in std_logic;
    clk : in std_logic
  );
end entity;

architecture structural of datapath is
  signal Rd, Rt, Rs, Rw : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal busa, busb, busw : std_logic_vector(31 downto 0);
  signal extend, ALUsrcMux, BGTZmuxOut, ALUout, dataMemOut, IFUout, Instruction : std_logic_vector(31 downto 0);
  signal zero, notZero, notmsb, bgtzsig, interBranchSel, BranchSelOut, brToIFU, brCond : std_logic;
  constant zeroSrc : std_logic_vector(31 downto 0) := (others => '0');

begin
  ----------------------------------------------------------
  --Select RD or RT as RW
  RegDstMux : mux_n generic map (n => 5)
                    port map (sel  => RegDst,
                              src0 => Rt,
                              src1 => Rd,
                              z    => Rw);
  --Access register file
  Registers : reg32_32 port map (clk  => clk,
                                 rw   => Rw,
                                 ra   => Rs,
                                 rb   => Rt,
                                 we   => RegWr,
                                 busw => busw,
                                 busa => busa,
                                 busb => busb);
----------------------------------------------------------
--Extend immediate bits
  Extender : extender_n generic map (n => 32)
                         port map (a   => imm,
                                   sel => ExtOp,
                                   z   => extend);
--Select ALU src based on R or I type
  ALUsrcMuxGate : mux_n generic map (n => 32)
                         port map(sel   => ALUSrc,
                                  src0  => busb,
                                  src1  => extend,
                                  z     => ALUsrcMux);
  --Input to ALU should be zero if instruction is BGTZ
  BGTZmux : mux_n generic map (n  => 32)
                  port map(sel => BranchSel(1),
                           src0 => ALUsrcMux,
                           src1 => zeroSrc,
                           z => BGTZmuxOut);
  --Process Inputs
  ALU : alu_32_bit port map(A_32      => busa,
                            B_32      => BGTZmuxOut,
                            op_32     => ALUctrl,-- left out cout and overflow
                            zero_32   => zero,
                            result_32 => ALUout);
  --Branch Select Bit Logic
  notZeroGate : not_gate port map (x => zero,
                                   z => notZero);
  --Beq = 0, Bne = 1
  BranchSelmux1 : mux port map (sel => BranchSel(0),
                                src0 => zero,
                                src1 => notZero,
                                z => interBranchSel);
  --not zero and not msb logic (for bgtz)
  notMSBgat : not_gate port map (x => ALUout(31),
                                 z => notmsb);
  andbgtzgate : and_gate port map (x => notZero,
                                   y => notmsb,
                                   z => bgtzsig);
  --BGTZ = 2 else previous out
  BranchSelmux2 : mux port map (sel => BranchSel(1),
                                src0 => interBranchSel,
                                src1 => bgtzsig,
                                z => BranchSelOut);
  ---------------------------------------------------------
  --Feed Branch logic bit, instruciton immediate, branch bit into IFU
  InstrFU :  ifu port map (init => pcInit,
                           clk         => clk,
                           imm16       => imm,
                           zero        => BranchSelOut,
                           branch      => Branch,
                           addr_out    => IFUout);
------------------------------------------------------------
--Data mem access
  DataMem  : syncram generic map (mem_file => MEMORY_SOURCE)
                     port map (clk  => clk,
                              oe   => '1',
                              cs   => '1',
                              we   => MemWr,
                              addr => ALUout,
                              din  => busb,
                              dout => dataMemOut);
  MtRMux : mux_n generic map (n => 32)
                 port map (sel  => MemtoReg,
                           src0 => ALUout,
                           src1 => dataMemOut,
                           z    => busw);
-------------------------------------------------------------
  InstructionMem : syncram generic map (mem_file => MEMORY_SOURCE)
                           port map (clk  => clk,
                                     cs   => '1',
                                     oe   => '1',
                                     we   => '0',
                                     addr => IFUout,
                                     din  => busb,
                                     dout => Instruction);
   Rd <= Instruction(15 downto 11);
   Rs <= Instruction(20 downto 16);
   Rt <= Instruction(25 downto 21);
   imm <= Instruction(15 downto 0);
-------------------------------------------------------------
end architecture;
