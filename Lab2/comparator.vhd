library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.divider_const.all;
--Additional standard or custom libraries go here
entity comparator is
port(
--Inputs
    DINL : in std_logic_vector (DIVISOR_WIDTH downto 0); -- current portion of dividend
    DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- divisor
--Outputs
    DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);  -- This should probably be DATA_WIDTH downto 0
    isGreaterEq : out std_logic;
    overflow: out std_logic
  );
end entity comparator;

architecture behavioral of comparator is

  begin
  --signals
    compare : process(DINL, DINR)
    variable DINL_u : unsigned;
    variable DINR_u : unsigned;
      begin
        DINL_u := unsigned(DINL);
        DINR_u := unsigned(DINR);
        if DINL_u < DINR_u then
          DOUT <=  std_logic_vector(resize(DINL_u, DIVISOR_WIDTH));
          isGreaterEq <= '0';
        else
          -- MIGHT NEED TO CHECK FOR OVERFLOW
          if DINR_u = 0 then
            overflow <= '1';
            DINR_u := to_unsigned(1, DATA_WIDTH-1);
          end if;
          DOUT <= std_logic_vector(resize(DINL_u-('0' & DINR_u), DIVISOR_WIDTH));
          isGreaterEq <= '1';
        end if;
    end process compare;

--Behavioral design goes here
end architecture behavioral;
