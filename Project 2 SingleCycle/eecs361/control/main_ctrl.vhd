library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity main_ctrl is
  port (
        opcode : in std_logic_vector(5 downto 0);
        RegDst : out std_logic;
        RegWr : out std_logic;
        Branch : out std_logic;
        ExtOp : out std_logic;
        ALUsrc : out std_logic;
        MemWr : out std_logic;
        MemtoReg : out std_logic;
        BrSel : out std_logic_vector(1 downto 0)
  );
end entity;

architecture structural of main_ctrl is

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

type invArr is array(0 to 8) of std_logic_vector(5 downto 0);
type andInterArr is array(0 to 8) of std_logic_vector(2 downto 0);
signal invBranch0in : std_logic_vector(5 downto 0);
signal RegWrInter : std_logic;
signal ALUsrcInter : std_logic;
signal ExtOpInter : std_logic;
signal invOut0 : invArr;
signal invOut1 : invArr;
signal invOut2 : invArr;
signal andIntermediate: andInterArr;
begin
  ---------------------RegDst------------------
  invRegDst0: pla_inverter
    port map (
      din  => opcode,
      inv  => "111111",
      dout => invOut0(0)
    );

  andRegDst0 : and_6to1
    port map (
      din => invOut0(0),
      z   => RegDst
    );

  ---------------------RegWr------------------------
  invRegWr0: pla_inverter
    port map (
      din  => opcode,
      inv  => "111111",
      dout => invOut0(1)
    );

  andRegWr0 : and_6to1
    port map (
      din => invOut0(1),
      z   => andIntermediate(1)(0)
    );

  invRegWr1 : pla_inverter
    port map (
      din  => opcode,
      inv  => "110111",
      dout => invOut1(1)
    );

  andRegWr1 : and_6to1
    port map (
      din => invOut1(1),
      z   => andIntermediate(1)(1)
    );
  invRegWr2 : pla_inverter
    port map (
      din  => opcode,
      inv  => "011100",
      dout => invOut2(1)
    );

  andRegWr2 : and_6to1
    port map (
      din => invOut2(1),
      z   => andIntermediate(1)(2)
    );

  orRegWr0: or_gate port map(x=>andIntermediate(1)(0), y=>andIntermediate(1)(1), z=>RegWrInter);
  orRegWr1: or_gate port map(x=>andIntermediate(1)(2), y=>RegWrInter, z=>RegWr);

  ------------------Branch-------------------------------
  invBranch0in(5 downto 1) <= opcode(5 downto 1);
  invBranch0in(0) <= '1';
  invBranch0: pla_inverter
    port map (
      din  => invBranch0in,
      inv  => "111010",
      dout => invOut0(2)
    );

  andBranch0 : and_6to1
    port map (
      din => invOut0(2),
      z   => andIntermediate(2)(0)
    );

  invBranch1 : pla_inverter
    port map (
      din  => opcode,
      inv  => "111100",
      dout => invOut1(2)
    );

  andBranch1 : and_6to1
    port map (
      din => invOut1(2),
      z   => andIntermediate(2)(1)
    );

  orBranch: or_gate port map(x=>andIntermediate(2)(0), y=>andIntermediate(2)(1), z=>Branch);

  -----------------ExtOp---------------------------
  invExtOp0: pla_inverter
    port map (
      din  => opcode,
      inv  => "010100",
      dout => invOut0(3)
    );

  andExtOp0 : and_6to1
    port map (
      din => invOut0(3),
      z   => andIntermediate(3)(0)
    );

  invExtOp1 : pla_inverter
    port map (
      din  => opcode,
      inv  => "110111",
      dout => invOut1(3)
    );

  andExtOp1 : and_6to1
    port map (
      din => invOut1(3),
      z   => andIntermediate(3)(1)
    );

  invExtOp2 : pla_inverter
    port map (
      din  => opcode,
      inv  => "011100",
      dout => invOut2(3)
    );

  andExtOp2 : and_6to1
    port map (
      din => invOut2(3),
      z   => andIntermediate(3)(2)
    );

  orExtOp0: or_gate port map(x=>andIntermediate(3)(0), y=>andIntermediate(3)(1), z=>ExtOpInter);
  orExtOp1: or_gate port map(x=>andIntermediate(3)(2), y=>ExtOpInter, z=>ExtOp);

  -------------------ALUsrc---------------------------
  invALUsrc0: pla_inverter
    port map (
      din  => opcode,
      inv  => "010100",
      dout => invOut0(4)
    );

  andALUsrc0 : and_6to1
    port map (
      din => invOut0(4),
      z   => andIntermediate(4)(0)
    );
  invALUsrc1 : pla_inverter
    port map (
      din  => opcode,
      inv  => "110111",
      dout => invOut1(4)
    );

  andALUsrc1 : and_6to1
    port map (
      din => invOut1(4),
      z   => andIntermediate(4)(1)
    );

  invALUsrc2 : pla_inverter
    port map (
      din  => opcode,
      inv  => "011100",
      dout => invOut2(4)
    );

  andALUsrc2 : and_6to1
    port map (
      din => invOut2(4),
      z   => andIntermediate(4)(2)
    );

  orALUsrc0: or_gate port map(x=>andIntermediate(4)(0), y=>andIntermediate(4)(1), z=>ALUsrcInter);
  orALUsrc1: or_gate port map(x=>andIntermediate(4)(2), y=>ALUsrcInter, z=>ALUsrc);

  ----------------MemWr----------------------------
  invMemWr: pla_inverter
    port map (
      din  => opcode,
      inv  => "010100",
      dout => invOut0(5)
    );

  andMemWr : and_6to1
    port map (
      din => invOut0(5),
      z   => MemWr
    );

  --------------MemtoReg--------------------
  invMemtoReg: pla_inverter
    port map (
      din  => opcode,
      inv  => "011100",
      dout => invOut0(6)
    );

  andMemtoReg : and_6to1
    port map (
      din => invOut0(6),
      z   => MemtoReg
    );

  ------------BrSel-----------------------
  invBrSel1: pla_inverter
    port map (
      din  => opcode,
      inv  => "111000",
      dout => invOut0(7)
    );

  andBrSel1 : and_6to1
    port map (
      din => invOut0(7),
      z   => BrSel(1)
    );

  invBrSel0: pla_inverter
    port map (
      din  => opcode,
      inv  => "111010",
      dout => invOut0(8)
    );

  andBrSel0 : and_6to1
    port map (
      din => invOut0(8),
      z   => BrSel(0)
    );

end architecture;
