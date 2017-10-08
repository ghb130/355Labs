library IEEE;
use IEEE.std_logic_1164.all;
--Additional standard or custom libraries go here if needed
package decoder is
	COMPONENT leddcd is
		PORT(data_in : in   std_logic_vector(3 downto 0);
  	     segments_out :  out std_logic_vector(6 downto 0)
         );
	end COMPONENT;
end package decoder;

package body decoder is
end package body decoder;
