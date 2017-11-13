library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity alu_ctrl is
  port (
        opcode : in std_logic_vector(5 downto 0);
        funct : in std_logic_vector(5 downto 0);
        ALUop : out std_logic_vector(3 downto 0)
  );
end entity;

architecture structural of alu_ctrl is

component and_6to1
  port (
    din : in  std_logic_vector(5 downto 0);
    z   : out std_logic
  );
end component and_6to1;

component or_6to1
  port (
    din : in  std_logic_vector(5 downto 0);
    z   : out std_logic
  );
end component or_6to1;

component pla_inverter
  port (
    din  : in  std_logic_vector(5 downto 0);
    inv  : in  std_logic_vector(5 downto 0);
    dout : out std_logic_vector(5 downto 0)
  );
end component pla_inverter;

type plaInvArr is array(0 to 3) of std_logic_vector(5 downto 0);
type andOutIntermediateArr is array(0 to 3) of std_logic_vector(2 downto 0);
signal andOutInt : andOutIntermediateArr;
signal plaInvOut : plaInvArr;
signal plaInvOut2 : plaInvArr;
signal invItypeOut0 : std_logic_vector(5 downto 0);
signal invItypeOut1 : std_logic_vector(5 downto 0);
signal ALUopRT : std_logic_vector(3 downto 0);
signal ALUopIT : std_logic_vector(3 downto 0);
signal ALUit00 : std_logic;
signal ALUopRT2inter : std_logic;
signal ALUit01 : std_logic;
signal or6out : std_logic;
signal opSel : std_logic;
signal plaInvOut23 : std_logic_vector(5 downto 0);
signal dinPLAinvR0 : std_logic_vector(5 downto 0);
signal dinPLAinvI0 : std_logic_vector(5 downto 0);
signal dinPLAinvI1 : std_logic_vector(5 downto 0);
begin
---------- ALUop(0) for R-type --------------
  dinPLAinvR0 <= (5=>funct(5), 4=>funct(4), 3=>funct(3), 2=>funct(2), 1=>funct(1), 0=>'1');
  pla_inverter_R00 : pla_inverter
    port map (
      din  => dinPLAinvR0,
      inv  => "011100",
      dout => plaInvOut(0)
    );
  and_6to1_R00 : and_6to1
    port map (
      din => plaInvOut(0),
      z   => andOutInt(0)(0)
    );

  pla_inverter_R01 : pla_inverter
    port map (
      din  => funct,
      inv  => "010101",
      dout => plaInvOut2(0)
    );
  and_6to1_R01 : and_6to1
    port map (
      din => plaInvOut2(0),
      z   => andOutInt(0)(1)
    );

  or_R0: or_gate port map(x=>andOutInt(0)(0), y=>andOutInt(0)(1), z=>ALUopRT(0));

-------ALUop(1) for R-type-----------------------

  pla_inverter_R10 : pla_inverter
    port map (
      din  => funct,
      inv  => "010100",
      dout => plaInvOut(1)
    );
  and_6to1_R10 : and_6to1
    port map (
      din => plaInvOut(1),
      z   => andOutInt(1)(0)
    );

  pla_inverter_R11 : pla_inverter
    port map (
      din  => funct,
      inv  => "011011",
      dout => plaInvOut2(1)
    );
  and_6to1_R11 : and_6to1
    port map (
      din => plaInvOut2(1),
      z   => andOutInt(1)(1)
    );

  or_R1: or_gate port map(x=>andOutInt(1)(0), y=>andOutInt(1)(1), z=>ALUopRT(1));


-------ALUop(2) for R-type-----------------------
  pla_inverter_R20 : pla_inverter
    port map (
      din  => funct,
      inv  => "010100",
      dout => plaInvOut(2)
    );
  and_6to1_R20 : and_6to1
    port map (
      din => plaInvOut(2),
      z   => andOutInt(2)(0)
    );

  pla_inverter_R21 : pla_inverter
    port map (
      din  => funct,
      inv  => "011010",
      dout => plaInvOut2(2)
    );
  and_6to1_R21 : and_6to1
    port map (
      din => plaInvOut2(2),
      z   => andOutInt(2)(1)
    );

  pla_inverter_R22 : pla_inverter
    port map (
      din  => funct,
      inv  => "010101",
      dout => plaInvOut23
    );
  and_6to1_R22 : and_6to1
    port map (
      din => plaInvOut23,
      z   => andOutInt(2)(2)
    );

  or_R20: or_gate port map(x=>andOutInt(2)(0), y=>andOutInt(2)(1), z=>ALUopRT2inter);
  or_R21: or_gate port map(x=>ALUopRT2inter, y=>andOutInt(2)(2), z=>ALUopRT(2));

-------ALUop(3) for R-type-----------------------
  pla_inverter_R3 : pla_inverter
    port map (
      din  => funct,
      inv  => "111111",
      dout => plaInvOut(3)
    );
  and_6to1_R3 : and_6to1
    port map (
      din => plaInvOut(3),
      z   => ALUopRT(3)
    );

--------ALUop(0) for non R-type------------------------
  dinPLAinvI0(5 downto 1) <= opcode(5 downto 1); -- <= (5 downto 1=>opcode(5 downto 1), 0=>'1');
  dinPLAinvI0(0) <= '1';
  pla_inverter_I0 : pla_inverter
    port map (
      din  => dinPLAinvI0,
      inv  => "111010",
      dout => invItypeOut0
    );
  and_6to1_I0 : and_6to1
    port map (
      din => invItypeOut0,
      z   => ALUit00
    );

  dinPLAinvI1(5 downto 2) <= opcode(5 downto 2);
  dinPLAinvI1(1) <= '1';
  dinPLAinvI1(0) <= opcode(0);
  pla_inverter_I1 : pla_inverter
    port map (
      din  => dinPLAinvI1,
      inv  => "111000",
      dout => invItypeOut1
    );
  and_6to1_I1 : and_6to1
    port map (
      din => invItypeOut1,
      z   => AlUit01
    );

  or_gate_0 : or_gate port map(x=> ALUit00, y=>ALUit01, z=>ALUopIT(0));
  ALUopIT(3 downto 1) <= "000";

---------MUX select------------------------
  or6to1_0: or_6to1 port map(din=>opcode, z=>or6out);
  not_gate0: not_gate port map(x=>or6out, z=>opSel);

  mux_gen: for i in 0 to 3 generate
    mux_i: mux port map(sel=>opSel, src0=>ALUopIT(i), src1=>ALUopRT(i), z=>ALUop(i));
  end generate;
end architecture;
