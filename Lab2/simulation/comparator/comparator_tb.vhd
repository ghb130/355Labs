library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.divider_const.all;

entity comparator_tb is
end comparator_tb;

architecture behave of comparator_tb is
  component comparator is                                      -- Should make smallerwidth + 1
  port(
  --Inputs
      DINL : in std_logic_vector (DIVISOR_WIDTH downto 0); -- current portion of dividend
      DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0); -- divisor
  --Outputs
      DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);  -- This should probably be DIVISOR_WIDTH downto 0
      isGreaterEq : out std_logic;
      overflow : out std_logic
      );
  end component comparator;

  signal DINL_tb : std_logic_vector(DIVISOR_WIDTH downto 0);
  signal DINR_tb : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal DOUT_tb : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
  signal isGreaterEq_tb : std_logic;
  signal overflow_tb : std_logic;

  begin dut : comparator port
    map(
        DINL=>DINL_tb,
        DINR=>DINR_tb,
        DOUT=>DOUT_tb,
        isGreaterEq=>isGreaterEq_tb,
        overflow=>overflow_tb
      );

      DINL_stimulus : process is
        begin
          DINL_tb <= "00000";
          wait for 10 ns; DINL_tb <= "00110";
          wait for 10 ns; DINL_tb <= "01010";
          wait for 10 ns; DINL_tb <= "11110";
          wait for 10 ns; DINL_tb <= "01000";
          wait;
        end process;

        DINR_stimulus : process is
          begin
            DINR_tb <= "0001";
            wait for 10 ns; DINR_tb <= "0000";
            wait for 10 ns; DINR_tb <= "0010";
            wait for 10 ns; DINR_tb <= "0111";
            wait for 10 ns; DINR_tb <= "1000";
            wait;
          end process;
      end architecture behave;
