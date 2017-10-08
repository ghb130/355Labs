library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use WORK.calc_const.all;

entity calculator_tb is
end calculator_tb;

architecture behave of calculator_tb is
  component calculator is
  	port(
  		DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
  		DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
  		operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
  		DOUT : out std_logic_vector (DOUT_WIDTH - 1 downto 0);
  		sign : out std_logic
  	);
  end component calculator;

  signal DIN1 : std_logic_vector (DIN1_WIDTH - 1 downto 0);
  signal DIN2 : std_logic_vector (DIN2_WIDTH - 1 downto 0);
  signal operation : std_logic_vector (OP_WIDTH - 1 downto 0);
  signal DOUT : std_logic_vector (DOUT_WIDTH - 1 downto 0);
  signal DOUT_int : integer;
  signal sign : std_logic;

begin
  calc: calculator port map(DIN1,DIN2,operation,DOUT,sign);
  process is
    file infile: text open read_mode is "cal8.in";
    file outfile: text open write_mode is "cal8.out";
    variable num : integer;
    variable op : character;
    variable inLine : line;
    variable outLine : line;

    begin
      while not (endfile(infile)) loop
        readline(infile, inLine);
        read(inLine,num);
        write(outLine, num);
        DIN1 <= std_logic_vector(to_signed(num, DIN1_WIDTH));
        readline(infile, inLine);
        read(inLine,num);
        DIN2 <= std_logic_vector(to_signed(num, DIN2_WIDTH));
        readline(infile, inLine);
        read(inLine,op);
        write(outLine, string'(" "));
        write(outLine, op);
        write(outLine, string'(" "));
        write(outline, num);
        write(outLine, string'(" = "));

        if op = '+' then
          operation <= "00";
        else
          if op = '-' then
            operation <= "01";
          else
            if op = '*' then
              operation <= "10";
            end if;
          end if;
        end if;
        wait for 10 ps;
        if sign = '1' then
          write(outLine, string'("-"));
        end if;
        DOUT_int <= to_integer(signed(DOUT));
        wait for 10 ps;
        write(outLine, DOUT_int);
        writeLine(outfile, outLine);
      end loop;
  end process;
end architecture behave;
