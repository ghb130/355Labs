-- This package is used for EECS 361 from Northwestern University.
-- by Kaicheng Zhang (kaichengz@gmail.com)

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

package eecs361 is
--32 bit mux
  component mux_32to1
  port (
    a   : in  std_logic_vector(31 downto 0);
    sel : in  std_logic_vector(4 downto 0);
    z   : out std_logic
  );
  end component mux_32to1;
--16 bit mux
  component mux_16to1
  port (
    a   : in  std_logic_vector(15 downto 0);
    sel : in  std_logic_vector(3 downto 0);
    z   : out std_logic
  );
  end component mux_16to1;

--Control
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

component RegWE_ctrl
port (
  miss          : in  std_logic;
  cpuReq        : in  std_logic;
  dirty         : in  std_logic;
  current_state : in  std_logic_vector(1 downto 0);
  last_state    : in  std_logic_vector(1 downto 0);
  valid         : in std_logic;
  cpuWr_we      : out std_logic;
  cpuAddr_we    : out std_logic;
  cpuDin_we     : out std_logic;
  cpuDout_we    : out std_logic;
  cpuReady_we   : out std_logic;
  L2Addr_we     : out std_logic;
  L2Dout_we     : out std_logic;
  LRU_we        : out std_logic;
  prevState_we  : out std_logic;
  repAddr_we    : out std_logic;
  repData_we    : out std_logic;
  hit_we        : out std_logic;
  miss_we       : out std_logic;
  evict_we     : out std_logic
);
end component RegWE_ctrl;
--Cache Data component
  component cache
  port (
    clk : in std_logic;
    ovrwr : in std_logic;
    addr : in std_logic_vector(25 downto 0);
    LRU : in std_logic;
    new_LRU : out std_logic;
    din : in std_logic_vector(511 downto 0);
    we : in std_logic;
    dout : out std_logic_vector(534 downto 0);
    miss : out std_logic;
    dirty : out std_logic
  );
  end component cache;
-- reg_n
component reg_n
  generic (
    n : integer
  );
  port (
    clk  : in  std_logic;
    rst  : in  std_logic;
    din  : in  std_logic_vector((n-1) downto 0);
    we   : in  std_logic;
    dout : out std_logic_vector((n-1) downto 0)
  );
end component reg_n;


--- 5 to 1 or gate
  component or5to1
    port (
      a,b,c,d,e : in  std_logic;
      z : out std_logic
    );
  end component or5to1;

-- 5 to 1 PLA
  component pla5
    port (
      din : in  std_logic_vector(4 downto 0);
      inv : in  std_logic_vector(4 downto 0);
      z   : out std_logic
    );
  end component pla5;

-- 2 to 1 PLA with inverters
  component pla2
    port (
      din : in  std_logic_vector(1 downto 0);
      inv : in  std_logic_vector(1 downto 0);
      z   : out std_logic
    );
  end component pla2;

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

  -- n-bit full adder.
  component fulladder_n
    generic (
      n : integer
    );
    port (
      cin   : in std_logic;
      x     : in std_logic_vector(n-1 downto 0);
      y     : in std_logic_vector(n-1 downto 0);
      cout  : out std_logic;
      z     : out std_logic_vector(n-1 downto 0)
    );
  end component fulladder_n;

  -- 32-bit full adder.
  component fulladder_32
    port (
      cin   : in std_logic;
      x     : in std_logic_vector(31 downto 0);
      y     : in std_logic_vector(31 downto 0);
      z     : out std_logic_vector(31 downto 0);
      cout  : out std_logic
    );
  end component fulladder_32;

  -- Cache tester.
  component cache_test
    generic (
      addr_trace_file : string;
      data_trace_file : string
    );
    port (
      DataIn : in std_logic_vector(31 downto 0);
      clk : in std_logic;
      Ready : in std_logic;
      rst : in std_logic;
      Addr : out std_logic_vector(31 downto 0);
      Data : out Std_logic_vector(31 downto 0);
      WR : out std_logic;
      Err : out std_logic
    );
  end component cache_test;

  -- Custom RAM
  component csram
    generic (
      INDEX_WIDTH : integer;
      BIT_WIDTH : integer
    );
    port (
      cs	  : in	std_logic;
      oe	  :	in	std_logic;
      we	  :	in	std_logic;
      index   : in	std_logic_vector(INDEX_WIDTH-1 downto 0);
      din	  :	in	std_logic_vector(BIT_WIDTH-1 downto 0);
      dout    :	out std_logic_vector(BIT_WIDTH-1 downto 0)
    );
  end component csram;

  component cmp_n
    generic (
      n : integer
    );
    port (
      a      : in std_logic_vector(n-1 downto 0);
      b      : in std_logic_vector(n-1 downto 0);

      a_eq_b : out std_logic;
      a_gt_b : out std_logic;
      a_lt_b : out std_logic;

      signed_a_gt_b : out std_logic;
      signed_a_lt_b : out std_logic
    );
  end component cmp_n;

  -- Synchronous SRAM with asynchronous reset and blksize-byte data bus.
  component syncram_n
    generic (
      blksize   : integer;
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
	  din	: in  std_logic_vector((blksize*8-1) downto 0);
	  -- data output
	  dout	: out std_logic_vector((blksize*8-1) downto 0);

      req   : in  std_logic;
      ready : out std_logic
	);
  end component syncram_n;
end;
