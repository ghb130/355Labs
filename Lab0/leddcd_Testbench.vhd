library IEEE;

use IEEE.std_logic_1164.all;
--Additional standard or custom libraries go here

entity leddcd_tb is
	port(
		F_tb	: out std_logic_vector(6 downto 0)
	    );
end entity leddcd_tb;

architecture behavioral of leddcd_tb is

component leddcd is
	port(
		data_in		: in std_logic_vector(3 downto 0);
		segments_out	: out std_logic_vector(6 downto 0)
	    );
end component leddcd;

signal testinput_tb : std_logic_vector(3 downto 0);

begin

dut : leddcd
	port map(
			data_in => testinput_tb,
       segments_out => F_tb
		   );


stimulus_testinput : process is
begin
	testinput_tb <= "0000";
	wait for 10 ns; testinput_tb <= "0001";
	wait for 10 ns; testinput_tb <= "0010";
	wait for 10 ns; testinput_tb <= "0100";
	wait for 10 ns; testinput_tb <= "1000";
	wait for 10 ns; testinput_tb <= "0110";
	wait for 10 ns; testinput_tb <= "0101";
	wait for 10 ns; testinput_tb <= "1011";
	wait;
end process stimulus_testinput;

end architecture behavioral;
-----------------------------------------------------------------------------
