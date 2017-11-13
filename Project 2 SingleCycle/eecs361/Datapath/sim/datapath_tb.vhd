library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.eecs361.all;
use work.eecs361_gates.all;

--Additional standard or custom libraries go here
entity datapath_tb is
end entity datapath_tb;

architecture behavioral of datapath_tb is
  signal RegDst_tb    : std_logic;
  signal Regwr_tb     : std_logic;
  signal Branch_tb    : std_logic;
  signal ExtOp_tb     : std_logic;
  signal ALUSrc_tb    : std_logic;
  signal ALUCtrl_tb   : std_logic_vector (3 downto 0);
  signal MemWr_tb     : std_logic;
  signal MemtoReg_tb  : std_logic;
  signal BranchSel_tb : std_logic_vector (1 downto 0);
  signal pcInit_tb    : std_logic;
  signal currInstruction_tb : std_logic_vector (31 downto 0);
  signal clk_tb       : std_logic;
  signal hold : std_logic;

begin
  datapath_i : datapath
              port map (
              RegDst    => RegDst_tb,
              Regwr     => Regwr_tb,
              Branch    => Branch_tb,
              ExtOp     => ExtOp_tb,
              ALUSrc    => ALUSrc_tb,
              ALUCtrl   => ALUCtrl_tb,
              MemWr     => MemWr_tb,
              MemtoReg  => MemtoReg_tb,
              BranchSel => BranchSel_tb,
              pcInit    => pcInit_tb,
              currInstruction => currInstruction_tb,
              clk       => clk_tb
              );

    clock_generate : process is
      begin
        clk_tb<='0';
        wait for 5 ns;
        clk_tb <= not clk_tb;
        wait for 5 ns;
    	if hold = '1' then
    	  wait;
      end if;
    end process clock_generate;

    process is
      variable init : boolean := false;
      begin
        if not init then
          pcInit_tb <= '1';
          wait for 7 ns;
          pcInit_tb <= '0';
          init := true;
        else
          wait;
        end if;
      end process;

    process(clk_tb) is
        variable my_line : line;
        file infile: text open read_mode is "control.in";
        variable LineVector : std_logic_vector(12 downto 0);
        -- add  : 0000
        -- sub  : 0001
        -- and  : 0010
        -- xor  : 0011
        -- or   : 0100
        -- slt  : 0101
        -- sltu : 0110
        -- sll  : 1000
        -- srl  : 1001

       begin
        if(rising_edge(clk_tb)) then
         if not (endfile(infile)) then
           readline(infile, my_line);
           read(my_line, LineVector);
           RegDst_tb <= LineVector(12);
           Regwr_tb <= LineVector(11);
           Branch_tb <= LineVector(10);
           ExtOp_tb <= LineVector(9);
           ALUSrc_tb <= LineVector(8);
           ALUCtrl_tb <= LineVector(7 downto 4);
           MemWr_tb <= LineVector(3);
           MemtoReg_tb <= LineVector(2);
           BranchSel_tb <= LineVector(1 downto 0);
          else
            hold <= '1';
          end if;
        end if;
     end process;

end architecture behavioral;
