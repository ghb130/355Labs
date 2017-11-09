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
    BranchSel : in std_logic_vector (2 downto 0);
    pcInit : in std_logic;
    pcInitVal : in std_logic_vector (29 downto 0);
    clk : in std_logic
  );
end entity;

architecture structural of datapath is
  signal Rd, Rt, Rs, Rw : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal busa, busb, busw : std_logic_vector(31 downto 0);
  signal extend, ALUsrcMux, ALUout, dataMemOut, IFUout, Instruction : std_logic_vector(31 downto 0);
  signal zero, brCond : std_logic;
begin
  RegDstMux : mux_n generic map (n => 5)
                    port map (sel  => RegDst,
                              src0 => Rt,
                              src1 => Rd,
                              z    => Rw);
  Registers : reg32_32 port map (clk  => clk,
                                 rw   => Rw,
                                 ra   => Rs,
                                 rb   => Rt,
                                 we   => RegWr,
                                 busw => busw,
                                 busa => busa,
                                 busb => busb);
----------------------------------------------------------
  Extender : extender_n generic map (n => 32)
                         port map (a   => imm,
                                   sel => ExtOp,
                                   z   => extend);
  ALUsrc : mux_n generic map (n => 32)
                         port map(src0  => busb,
                                  src1  => extender,
                                  sel   => ALUSrc,
                                  z     => ALUsrcMux);
  ALU : alu_32_bit port map(A_32      => busa,
                            B_32      => ALUsrcMux,
                            op_32     => ALUctrl,-- left out cout and overflow
                            zero_32   => zero,
                            result_32 => ALUout);
  ---------------------------------------------------------
  InstrFU :  ifu port map (init => pcInit,
                           pc_init_val => pcInitVal,
                           clk         => clk,
                           imm16       => imm,
                           zero        => zero,
                           branch      => Branch,
                           addr_out    => IFUout);
------------------------------------------------------------
  DataMem  : syncram generic map (mem_file => MEMORY_SOURCE)
                     port map (clk  => clk,
                              oe   => '1',
                              cs   => '1',
                              we   => MemWr,
                              addr => ALUout,
                              din  => busb,
                              dout => dataMemOut);
  MtRMux : mux_n generic map (n => 5)
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
