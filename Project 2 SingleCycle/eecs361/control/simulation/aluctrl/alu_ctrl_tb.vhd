library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity alu_ctrl_tb is
end entity;

architecture behavioral of alu_ctrl_tb is

component alu_ctrl
  port (
    opcode : in  std_logic_vector(5 downto 0);
    funct  : in  std_logic_vector(5 downto 0);
    ALUop  : out std_logic_vector(3 downto 0)
  );
end component alu_ctrl;

signal opcode_tb : std_logic_vector(5 downto 0);
signal funct_tb  : std_logic_vector(5 downto 0);
signal ALUop_tb  : std_logic_vector(3 downto 0);

begin
  dut: alu_ctrl
    port map(
      opcode=>opcode_tb,
      funct=>funct_tb,
      ALUop=>ALUop_tb
    );

    stimFunct: process is
      begin
        funct_tb <= "100000"; wait for 5 ns;
        funct_tb <= "100001"; wait for 5 ns;
        funct_tb <= "100010"; wait for 5 ns;
        funct_tb <= "100011"; wait for 5 ns;
        funct_tb <= "101010"; wait for 5 ns;
        funct_tb <= "101011"; wait for 5 ns;
        funct_tb <= "100100"; wait for 5 ns;
        funct_tb <= "100101"; wait for 5 ns;
        funct_tb <= "000000"; wait for 5 ns;
        wait;
      end process;

    stimOpcode: process is
      begin
        opcode_tb <= "000000"; wait for 45 ns;
        opcode_tb <= "100011"; wait for 5 ns;
        opcode_tb <= "101011"; wait for 5 ns;
        opcode_tb <= "000100"; wait for 5 ns;
        opcode_tb <= "000101"; wait for 5 ns;
        opcode_tb <= "000111"; wait for 5 ns;
        opcode_tb <= "001000"; wait for 5 ns;
        wait;
      end process;
end architecture;
