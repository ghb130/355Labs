library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
--Additional standard or custom libraries go here
entity display_divider is
  port(
  --You will replace these with your actual inputs and outputs
      dividend : in std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
      divisor : in std_logic_vector(DIVISOR_WIDTH-1 downto 0);
      start : in std_logic;
      clk : in std_logic;
      overflow : out std_logic;
      dividend_segments_out : out std_logic_vector ((DIVIDEND_WIDTH/4)*7 - 1 downto 0);
      divisor_segments_out : out std_logic_vector ((DIVISOR_WIDTH/4)*7 - 1 downto 0);
      quotient_segments_out : out std_logic_vector ((DIVIDEND_WIDTH/4)*7 - 1 downto 0);
      remainder_segments_out : out std_logic_vector ((DIVISOR_WIDTH/4)*7 - 1 downto 0)
       );
end entity display_divider;

architecture structural of display_divider is
--Signals and components go here
  COMPONENT leddcd is
    PORT(data_in : in   std_logic_vector(3 downto 0);
         segments_out :  out std_logic_vector(6 downto 0)
         );
  end COMPONENT;

  COMPONENT divider is
    PORT(
        clk : in std_logic;
        start : in std_logic;
        dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
        divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
        quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
        remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
        overflow : out std_logic
      );
  end COMPONENT;

  signal quotient: std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
  signal remainder: std_logic_vector(DIVISOR_WIDTH-1 downto 0);

  begin
--Structural design goes here
  div: divider port map(clk, start, dividend, divisor, quotient, remainder, overflow);
  dividendLoop: for i in 0 to (DIVIDEND_WIDTH/4)-1 GENERATE begin
    dividendDecoder: leddcd port map (dividend(4*(i+1)-1 downto 4*i), dividend_segments_out(7*(i+1)-1 downto 7*i));
  end GENERATE;
  divisorLoop: for i in 0 to (DIVISOR_WIDTH/4)-1 GENERATE begin
    divisorDecoder: leddcd port map (divisor(4*(i+1)-1 downto 4*i), divisor_segments_out(7*(i+1)-1 downto 7*i));
  end GENERATE;
  quotientLoop: for i in 0 to (DIVIDEND_WIDTH/4)-1 GENERATE begin
    quotientDecoder: leddcd port map (quotient(4*(i+1)-1 downto 4*i), quotient_segments_out(7*(i+1)-1 downto 7*i));
  end GENERATE;
  remainderLoop: for i in 0 to (DIVISOR_WIDTH/4)-1 GENERATE begin
    remainderDecoder: leddcd port map (remainder(4*(i+1)-1 downto 4*i), remainder_segments_out(7*(i+1)-1 downto 7*i));
  end GENERATE;
end architecture structural;
