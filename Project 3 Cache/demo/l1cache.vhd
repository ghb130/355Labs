library ieee;

use ieee.std_logic_1164.all;
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
end l1cache;

architecture struct of l1cache is
begin

  if state = idle {
    if cpuReq = 1{
      register all cpu input signals;
      register cpu ready = 0;
      nextstate = compare tag;
    }
  }

  if state = compare tag {
   if set slot 0 = tag{
    register cpuDout = set slot 0 data;
    register cpu ready = 1;
    next state = idle
   }
   if set slot 1 = tag{
    register cpuDout = set slot 1 data;
    register cpu ready = 1;
    next state = idle;
   }
   register address of replacement
   register data of replacement
   if (block to be replaced is dirty){
    next state = write back
    register l2readylast = l2ready;
   }
  else{
    next state = allocate;
    register l2readylast = l2ready;
  }
  }

  if state = write back {
    register l2req high;
    register l2wr high;
    register l2addr = address of replacement;
    register l2dout = data of replacement;
    if(l2ready last = 0 and l2ready = 1){
      next state = allocate;
    }
    register l2readylast = l2ready;
  }

  if state = allocate {
    register l2req high;
    register l2wr low;
    register l2addr = cpuAddr;
    if(l2ready last = 0 and l2ready = 1){
      next state = comp tag;
      write l2din to addr of replacement;
    }
    register l2readylast = l2ready;
  }
end struct;
