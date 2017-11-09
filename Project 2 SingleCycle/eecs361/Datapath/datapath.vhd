library ieee;
use ieee.std_logic_1164.all;
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
    clk : in std_logic
  );
end entity;

architecture structural of datapath is
  signal Rd, Rt, Rs, Rw : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal busa, busb, busw : std_logic_vector(31 downto 0);
  signal extend, ALUsrcMux, ALUout, dataMemOut : std_logic_vector(31 downto 0);
  signal zero : std_logic;
begin
   alusrcmux : mux_n generic map(n=>32)
                     port map(src0 =>busb,
                              src1 =>extender,
                              sel  =>ALUSrc,
                              z    =>ALUsrcMux);
   RegDstMux : mux_n generic map (n => 5)
                     port map (sel  => RegDst,
                               src0 => Rt,
                               src1 => Rd,
                               z    => Rw);





















                               
  Extender : extender_n generic map (n => 32)
                        port map (a   => imm,
                                  sel => ExtOp,
                                  z   => extend);
  ALU : alu_32_bit port map(A_32      => busa,
                            B_32      => ALUsrcMux,
                            op_32     => ALUctrl,   -- left out cout and overflow
                            zero_32   => zero,
                            result_32 => ALUout);
end architecture;
