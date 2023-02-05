ma_pops_furniture.window_operate = function( pos, old_node_state_name, new_node_state_name )
   
   local offsets   = {-1,1,-2,2,-3,3};
   local stop_up   = 0;
   local stop_down = 0;

   for i,v in ipairs(offsets) do

      local node = minetest.env:get_node_or_nil( {x=pos.x, y=(pos.y+v), z=pos.z } );
      if( node and node.name and node.name==old_node_state_name 
        and ( (v > 0 and stop_up   == 0 ) 
           or (v < 0 and stop_down == 0 ))) then

         minetest.env:add_node({x=pos.x, y=(pos.y+v), z=pos.z }, {name = new_node_state_name, param2 = node.param2})

      -- found a diffrent node - no need to search further up
      elseif( v > 0 and stop_up   == 0 ) then
         stop_up   = 1; 

      elseif( v < 0 and stop_down == 0 ) then
         stop_down = 1; 
      end
   end
end
