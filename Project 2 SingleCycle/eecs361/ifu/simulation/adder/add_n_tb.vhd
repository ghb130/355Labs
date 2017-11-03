library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;

entity add_n_tb is
  constant width : integer := 30;
end entity add_n_tb;

architecture behavioral of add_n_tb is
  component add_n is
    generic (n : integer);
    port (
          a_n : in std_logic_vector(n-1 downto 0);
          b_n : in std_logic_vector(n-1 downto 0);
          cin_n : in std_logic;
          cout_n : out std_logic;
          sum_n : out std_logic_vector(n-1 downto 0)
    );
  end component;
  signal a_tb, b_tb,sum_tb : std_logic_vector(width-1 downto 0);
  signal cin_tb, cout_tb : std_logic;
begin
    dut : add_n
        generic map(n=>width)
        port map (
                  a_n => a_tb,
                  b_n => b_tb,
                  cin_n => cin_tb,
                  cout_n => cout_tb,
                  sum_n => sum_tb
                 );
    process is
        variable my_line : line;
        file infile: text open read_mode is "addn.in";
        file outfile: text open write_mode is "addn.out";

        variable num1 : integer;
        variable num2 : integer;
        variable c : character;
        variable sign_char : character;

       begin
         while not (endfile(infile)) loop
           readline(infile, my_line);
           read(my_line, num1);
           readline(infile, my_line);
           read(my_line, num2);
           a_tb <= std_logic_vector(to_signed(num1, width));
           b_tb <= std_logic_vector(to_signed(num2, width));
           readline(infile, my_line);
	         read(my_line, c);
           if c = '1' then
             cin_tb <= '1';
           else
             cin_tb <= '0';
           end if;
           wait for 10 ns;
           write(my_line, num1);
           write(my_line, ' ');
           write(my_line, '+');
           write(my_line, ' ');
           write(my_line, num2);
           write(my_line, ' ');
           write(my_line, '=');
           write(my_line, ' ');
           write(my_line, to_integer(signed(sum_tb)));
           writeline(outfile, my_line);
         end loop;
     wait;
     end process;

end architecture behavioral;
