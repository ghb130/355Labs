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

  signal Rd, Rt, Rs : std_logic_vector(4 downto 0);
  signal imm : std_logic_vector(15 downto 0);
  signal busa, busb, busw : std_logic_vector(31 downto 0);
  signal extend, ALUsrcMux, ALUout, dataMemOut : std_logic_vector(31 downto 0);
  signal zero : std_logic;
  signal test : std_logic;

begin

end architecture;
