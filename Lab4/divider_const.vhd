library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Additional standard or custom libraries go here
package divider_const is
  constant DIVIDEND_WIDTH : natural := 16;
  constant DIVISOR_WIDTH : natural := 8;
  function get_msb_pos (vec : std_logic_vector)
                        return integer;
end package divider_const;
package body divider_const is
 function get_msb_pos (vec : std_logic_vector)
                       return integer is
 begin
     for i in vec'LOW to vec'HIGH loop
       if (vec(vec'HIGH - i) = '1') then
         return (vec'HIGH - i);
       end if;
     end loop;
 end get_msb_pos;

  -- function get_msb_pos (vec : std_logic_vector)
  --                       return integer is
  --     variable mid, left, right : integer;
  -- begin
  --     mid := ((vec'HIGH+1)/2)
  --     if (mid > 1) then
  --       --Recurse over left half
  --       left := get_msb_pos(vec(vec'HIGH downto mid));
  --       --Recurse over right half
  --       right := get_msb_pos(vec((mid-1) downto 0));
  --     else
  --       --Down to two bits. Find top.
  --       case vec is
  --         when "11" =>  return 2;
  --         when "10" =>  return 2;
  --         when "01" =>  return 1;
  --         when "00" =>  return 0;
  --       end case;
  --     end if;
  --     --Non leaf node find greatest bit
  --     if(left > 0) then
  --       return (left+mid);
  --     elsif(right > 0) then
  --       return (right);
  --     else
  --       return 0;
  --     end if;
  -- end get_msb_pos;
end package body divider_const;
