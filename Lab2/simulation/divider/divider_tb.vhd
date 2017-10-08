library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.divider_const.all;
--Additional standard or custom libraries go here
entity divider_tb is
end entity divider_tb;
architecture behavioral of divider_tb is
  component divider is
      port(
        --Inputs
        -- clk : in std_logic;
        --COMMENT OUT clk signal for Part A.
        start : in std_logic;
        dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
        divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
        --Outputs
        quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
        remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
        overflow : out std_logic
      );
  end component divider;

  signal start_tb : std_logic;
  signal dividend_tb : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal divisor_tb : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
  signal quotient_tb : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal remainder_tb : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
  signal overflow_tb : std_logic;
--Entity (as component) and input ports (as signals) go here
begin
    dut : divider
        port map (
                    start=>start_tb,
                    dividend => dividend_tb,
                    divisor => divisor_tb,
                    quotient => quotient_tb,
                    remainder => remainder_tb,
                    overflow => overflow_tb
                 );
    process is
        variable my_line : line;
        file infile: text open read_mode is "divider16.in";
        file outfile: text open write_mode is "divider16.out";

        variable dividend_int : integer;
        variable divisor_int : integer;

       begin
         while not (endfile(infile)) loop
           readline(infile, my_line);
           read(my_line, dividend_int);
           readline(infile, my_line);
           read(my_line, divisor_int);
           dividend_tb <= std_logic_vector(to_unsigned(dividend_int, DIVIDEND_WIDTH));
           divisor_tb <= std_logic_vector(to_unsigned(divisor_int, DIVISOR_WIDTH));
           wait for 10 ns;
           write(my_line, dividend_int);
           write(my_line, ' ');
           write(my_line, '/');
           write(my_line, ' ');
           write(my_line, divisor_int);
           write(my_line, ' ');
           write(my_line, '=');
           write(my_line, ' ');
           write(my_line, to_integer(signed(quotient_tb)));
           write(my_line, ' ');
           write(my_line, string'("--"));
           write(my_line, ' ');
           write(my_line, remainder_tb);
           writeline(outfile, my_line);
         end loop;
     wait;
     end process;

end architecture behavioral;
