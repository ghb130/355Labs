library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.calc_const.all;
use WORK.decoder.all;
--Additional standard or custom libraries go here
entity display_calc is
  port(
		DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
		DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
		operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
		sign : out std_logic;
		segments_out : out std_logic_vector (((DOUT_WIDTH/4)*7)-1 downto 0)
    );
end entity display_calc;

architecture structural of display_calc is
--signals and components
	signal temp_DOUT: std_logic_vector (DOUT_WIDTH - 1 downto 0);
	
	COMPONENT calculator is
		port(
			--Inputs
			DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
			DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
			operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
			--Outputs
			DOUT : out std_logic_vector (DOUT_WIDTH - 1 downto 0);
			sign : out std_logic
		);
	end COMPONENT;
	
	COMPONENT leddcd is
		PORT(data_in : in   std_logic_vector(3 downto 0);
  	     segments_out :  out std_logic_vector(6 downto 0)
         );
	end COMPONENT;
	
begin
--structural design
	calc: calculator port map(DIN1, DIN2, operation, temp_DOUT, sign);
	decoderLoop: for i in 0 to (DOUT_WIDTH/4)-1 generate begin
		decoder: leddcd port map(temp_DOUT(4*(i+1)-1 downto 4*i), segments_out(7*(i+1)-1 downto 7*i));
	end generate;
end architecture structural;
