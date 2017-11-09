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
    clk : in std_logic
  );
end entity;

architecture structural of datapath is
  signal Rd, Rt, Rs, Rw : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal busa, busb, busw : std_logic_vector(31 downto 0);
  signal extend, ALUsrcMux, ALUout, dataMemOut, IFUout : std_logic_vector(31 downto 0);
  signal zero : std_logic;
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

  ALUsrc : mux_n generic map (n => 32)
                 port map(src0  => busb,
                          src1  => extender,
                          sel   => ALUSrc,
                          z     => ALUsrcMux);

  DataMem : syncram generic map (mem_file => MEMORY_SOURCE)
                    port map (clk  => clk,
                              cs   => '1',
                              oe   => '1',
                              we   => MemWr,
                              addr => ALUout,
                              din  => busb,
                              dout => dataMemOut);
end architecture;
