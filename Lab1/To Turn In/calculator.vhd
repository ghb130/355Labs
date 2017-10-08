library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.calc_const.all;

entity calculator is
	port(
		DIN1 : in std_logic_vector (DIN1_WIDTH - 1 downto 0);
		DIN2 : in std_logic_vector (DIN2_WIDTH - 1 downto 0);
		operation : in std_logic_vector (OP_WIDTH - 1 downto 0);
		DOUT : out std_logic_vector (DOUT_WIDTH - 1 downto 0);
		sign : out std_logic
	);
end entity calculator;
architecture behavioral of calculator is
--Signals and components go here
begin
--Behavioral design goes here
	process(DIN1,DIN2,operation)
	variable DIN1_int, DIN2_int, DOUT_int: integer;
	begin
		DIN1_int := to_integer(signed(DIN1));
		DIN2_int := to_integer(signed(DIN2));
		if operation = "00" then
			DOUT_int := DIN1_int + DIN2_int;
		else
			if operation = "01" then
				DOUT_int := DIN1_int - DIN2_int;
			else
				if operation = "10" then
					DOUT_int := DIN1_int * DIN2_int;
				else
					DOUT_int := DIN1_int + DIN2_int;
				end if;
			end if;
		end if;
		if DOUT_int < 0 then
			sign <= '1';
			DOUT_int := abs(DOUT_int);
		else
			sign <= '0';
		end if;
		DOUT <= std_logic_vector(to_signed(DOUT_int, DOUT_WIDTH));
	end process;
end architecture behavioral;
