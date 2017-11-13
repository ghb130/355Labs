-- This package is used for EECS 361 from Northwestern University.
-- by Kaicheng Zhang (kaichengz@gmail.com)

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use std.textio.all;
use ieee.std_logic_textio.all;

package eecs361 is
--Constants
  constant MEMORY_SOURCE : string := "sort_corrected_branch.dat";
--Processor component
  component single_cycle_processor
    port (
      clk    : in  std_logic;
      pcInit : in  std_logic
    );
  end component single_cycle_processor;

-- Datapath component
  component datapath
    port (
      RegDst          : in  std_logic;
      Regwr           : in  std_logic;
      Branch          : in  std_logic;
      ExtOp           : in  std_logic;
      ALUSrc          : in  std_logic;
      ALUCtrl         : in  std_logic_vector (3 downto 0);
      MemWr           : in  std_logic;
      MemtoReg        : in  std_logic;
      BranchSel       : in  std_logic_vector (1 downto 0);
      pcInit          : in  std_logic;
      currInstruction : out std_logic_vector (31 downto 0);
      clk             : in  std_logic
    );
  end component datapath;


-- ALU control
  component alu_ctrl is
    port (
      opcode : in  std_logic_vector(5 downto 0);
      funct  : in  std_logic_vector(5 downto 0);
      ALUop  : out std_logic_vector(3 downto 0)
    );
  end component;

-- Main control
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


-- Instruction Fetch Unit
  component ifu is
    port (
          init : in std_logic;
          clk : in std_logic;
          imm16 : in std_logic_vector(15 downto 0);
          zero : in std_logic;
          branch : in std_logic;
          addr_out : out std_logic_vector(31 downto 0)
    );
  end component;

 -- n bit Extender
  component extender_n is
    generic (n : integer := 30);
    port (
          a : in std_logic_vector(15 downto 0);
          sel : in std_logic;
          z : out std_logic_vector(n-1 downto 0)
    );
  end component;

-- ALU
  component alu_32_bit is
    port (
          A_32 : in std_logic_vector(31 downto 0);
          B_32 : in std_logic_vector(31 downto 0);
          op_32 : in std_logic_vector(3 downto 0);
          cout_32 : out std_logic;
          overflow_32 : out std_logic;
          zero_32 : out std_logic;
          result_32 : out std_logic_vector(31 downto 0)
    );
  end component alu_32_bit;

  -- Registers
  component reg32_32
    port (
          clk : in std_logic;
          rw : in std_logic_vector(4 downto 0);
          ra : in std_logic_vector(4 downto 0);
          rb : in std_logic_vector(4 downto 0);
          we : in std_logic;
          busw : in std_logic_vector(31 downto 0);
          busa : out std_logic_vector(31 downto 0);
          busb : out std_logic_vector(31 downto 0)
    );
  end component reg32_32;

  component reg32
    port (
          clk : in std_logic;
          din : in std_logic_vector(31 downto 0);
          we : in std_logic;
          dout : out std_logic_vector(31 downto 0)
    );
  end component reg32;

  -- Decoders
  component dec_n
    generic (
      -- Widths of the inputs.
      n	  : integer
    );
    port (
      src   : in std_logic_vector(n-1 downto 0);
      z	    : out std_logic_vector((2**n)-1 downto 0)
    );
  end component dec_n;

  -- Multiplexors
  component mux_32to1
    port (
      a   : in  std_logic_vector(31 downto 0);
      sel : in std_logic_vector(4 downto 0);
      z   : out std_logic
    );
  end component mux_32to1;

  component mux
    port (
      sel   : in  std_logic;
      src0  : in  std_logic;
      src1  : in  std_logic;
      z     : out std_logic
    );
  end component mux;

  component mux_n
    generic (
      -- Widths of the inputs.
      n	  : integer
    );
    port (
      sel   : in  std_logic;
      src0  : in  std_logic_vector(n-1 downto 0);
      src1  : in  std_logic_vector(n-1 downto 0);
      z     : out std_logic_vector(n-1 downto 0)
    );
  end component mux_n;

  component mux_32
    port (
      sel   : in  std_logic;
      src0  : in  std_logic_vector(31 downto 0);
      src1  : in  std_logic_vector(31 downto 0);
      z	    : out std_logic_vector(31 downto 0)
    );
  end component mux_32;

  -- Flip-flops

  -- D Flip-flops from Figure C.8.4 with a falling edge trigger.
  component dff
    port (
      clk   : in  std_logic;
      d	    : in  std_logic;
      q	    : out std_logic
    );
  end component dff;

  -- D Flip-flops from Figure C.8.4 with a rising edge trigger.
  component dffr
    port (
      clk   : in  std_logic;
      d	    : in  std_logic;
      q	    : out std_logic
    );
  end component dffr;

  -- D Flip-flops from Example 13-40 in http://www.altera.com/literature/hb/qts/qts_qii51007.pdf
  component dffr_a
    port (
      clk	 : in  std_logic;
      arst   : in  std_logic;
      aload  : in  std_logic;
      adata  : in  std_logic;
      d	     : in  std_logic;
      enable : in  std_logic;
      q	     : out std_logic
    );

  end component dffr_a;

  -- A 32bit SRAM from Figure C.9.1. It can only be used for simulation.
  component sram
	generic (
	  mem_file	: string
	);
	port (
	  -- chip select
	  cs	: in  std_logic;
	  -- output enable
	  oe	: in  std_logic;
	  -- write enable
	  we	: in  std_logic;
	  -- address line
	  addr	: in  std_logic_vector(31 downto 0);
	  -- data input
	  din	: in  std_logic_vector(31 downto 0);
	  -- data output
	  dout	: out std_logic_vector(31 downto 0)
	);
  end component sram;

  -- Synchronous SRAM with asynchronous reset.
  component syncram
    generic (
	  mem_file	: string
	);
	port (
      -- clock
      clk   : in  std_logic;
	  -- chip select
	  cs	: in  std_logic;
      -- output enable
	  oe	: in  std_logic;
	  -- write enable
	  we	: in  std_logic;
	  -- address line
	  addr	: in  std_logic_vector(31 downto 0);
	  -- data input
	  din	: in  std_logic_vector(31 downto 0);
	  -- data output
	  dout	: out std_logic_vector(31 downto 0)
	);
  end component syncram;


end;
