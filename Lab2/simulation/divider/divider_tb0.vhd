library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.divider_const.all;
--Additional standard or custom libraries go here
entity divider_tb0 is
end entity divider_tb0;
architecture behavioral of divider_tb0 is
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
      begin
        start_tb <= '1';
        dividend_tb <= "0000000000000001";
        divisor_tb <= "00000001";
        wait for 10 ns;
     end process;

end architecture behavioral;
