library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here
package divider_const is
  constant DIVIDEND_WIDTH : natural := 32;
  constant DIVISOR_WIDTH : natural := 16;
  function get_msb_pos (vec : std_logic_vector)
                        return integer;
end package divider_const;
package body divider_const is
 -- function get_msb_pos (vec : std_logic_vector)
 --                       return integer is
 -- begin
 --     for i in vec'LOW to vec'HIGH loop
 --       if (vec(vec'HIGH - i) = '1') then
 --         return (vec'HIGH - i);
 --       end if;
 --     end loop;
 --     return 0;
 -- end get_msb_pos;

  function get_msb_pos (vec : std_logic_vector)
                        return integer is
      variable left, right, returnVal: integer;
  begin
      report "Start";
      if (vec'length/2 > 1) then
        --Recurse over left half
        left := get_msb_pos(vec(vec'high downto (vec'length/2)+vec'low));
        --Recurse over right half
        right := get_msb_pos(vec(((vec'length/2)+vec'low)-1 downto vec'low));
        report "LR";
        report integer'image(left);
        report integer'image(right);

      else
        report "Bottom";
        --Down to two bits. Find top.
        if(vec = "11") then
          return 2;
        elsif (vec = "10") then
          return 2;
        elsif (vec = "01") then
          return 1;
        else
          return 0;
        end if;
      end if;
      --Non leaf node find greatest bit
      if(left > 0) then
        report "Left Node";
        returnVal := (left+(vec'length/2));
        return returnVal;
      elsif(right > 0) then
        report "Right Node";
        return right;
      else
        return 0;
      end if;
  end get_msb_pos;
end package body divider_const;
