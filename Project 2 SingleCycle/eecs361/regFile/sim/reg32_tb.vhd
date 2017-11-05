library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.eecs361.all;
use work.eecs361_gates.all;

--Additional standard or custom libraries go here
entity reg32_tb is
end entity reg32_tb;

architecture behavioral of reg32_tb is
  signal busw_tb : std_logic_vector(31 downto 0);
  signal busa_tb : std_logic_vector(31 downto 0);
  signal busb_tb : std_logic_vector(31 downto 0);
  signal rw_tb : std_logic_vector(4 downto 0);
  signal ra_tb : std_logic_vector(4 downto 0);
  signal rb_tb : std_logic_vector(4 downto 0);
  signal clk_tb : std_logic;
  signal we_tb  : std_logic;
  signal hold : std_logic :='0';

begin
    reg: reg32_32 port map(
                  clk => clk_tb,
                  rw => rw_tb,
                  ra => ra_tb,
                  rb => rb_tb,
                  we => we_tb,
                  busw => busw_tb,
                  busa => busa_tb,
                  busb => busb_tb
                );

    clock_generate : process is
      begin
        clk_tb<='0';
        wait for 1 ns;
        clk_tb <= not clk_tb;
        wait for 1 ns;
    	if hold = '1' then
    	  wait;
      end if;
    end process clock_generate;

    process is
        variable my_line : line;
        file infile: text open read_mode is "reg32_32_input.in";
        variable inputrw : std_logic_vector(4 downto 0);
        variable inputra : std_logic_vector(4 downto 0);
        variable inputrb : std_logic_vector(4 downto 0);
        variable inputbusw : std_logic_vector(31 downto 0);
        variable inputwe : std_logic;

       begin
         while not (endfile(infile)) loop
           readline(infile, my_line);
           read(my_line, inputra);
           readline(infile, my_line);
           read(my_line, inputrb);
           readline(infile, my_line);
           read(my_line, inputrw);
           readline(infile, my_line);
           read(my_line, inputbusw);
           readline(infile, my_line);
           read(my_line, inputwe);
           ra_tb <= inputra;
           rb_tb <= inputrb;
           rw_tb <= inputrw;
           busw_tb <= inputbusw;
           we_tb <= inputwe;
           wait for 10 ns;
         end loop;
     wait;
     end process;

end architecture behavioral;
