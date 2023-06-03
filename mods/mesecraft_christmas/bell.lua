-- Christmas Bell that rings every hour.
-- Most of this code is from the "bell" mod.

mesecraft_christmas.bell_ring_interval = 3600; --60*60; -- ring each hour

mesecraft_christmas.bell_save_file = minetest.get_worldpath().."/christmas_bell_positions.data";

local bell_positions = {};


mesecraft_christmas.save_bell_positions = function( player )
  
   str = minetest.serialize( ({ bell_data = bell_positions}) );

   local file, err = io.open( mesecraft_christmas.bell_save_file, "wb");
   if (err ~= nil) then
      return
   end
   file:write( str );
   file:flush();
   file:close();
end


mesecraft_christmas.restore_bell_data = function()

   local bell_position_table;

   local file, err = io.open(mesecraft_christmas.bell_save_file, "rb");
   if (err ~= nil) then
      print("Error: Could not open bell data savefile (ignore this message on first start)");
      return
   end
   local str = file:read();
   file:close();
   
   local bell_positions_table = minetest.deserialize( str );
   if( bell_positions_table and bell_positions_table.bell_data ) then
     bell_positions = bell_positions_table.bell_data;
   end
end
   

-- actually ring the bell
mesecraft_christmas.ring_bell_once = function()

   for i,v in ipairs( bell_positions ) do
      minetest.sound_play( "mesecraft_christmas_bell",
        { pos = v, gain = 1.5, max_hear_distance = 300,});
   end
end



mesecraft_christmas.ring_bell = function()

   -- figure out if this is the right time to ring
   local sekunde = tonumber( os.date( "%S"));
   local minute  = tonumber( os.date( "%M"));
   local stunde  = tonumber( os.date( "%I")); -- in 12h-format (a bell that rings 24x at once would not survive long...)
   local delay   = mesecraft_christmas.bell_ring_interval;

   delay = mesecraft_christmas.bell_ring_interval - sekunde - (minute*60);

   -- make sure the bell rings the next hour
   minetest.after( delay, mesecraft_christmas.ring_bell );

   -- if no bells are around then don't ring
   if( bell_positions == nil or #bell_positions < 1 ) then
      return;
   end

   -- ring the bell for each hour once
   for i=1,stunde do
     minetest.after( (i-1)*5,  mesecraft_christmas.ring_bell_once );
   end

end

-- first call (after the server has been started)
minetest.after( 10, mesecraft_christmas.ring_bell );
-- read data about bell positions
mesecraft_christmas.restore_bell_data();


minetest.register_node("mesecraft_christmas:christmas_bell", {
    description = "Bell",
    node_placement_prediction = "",
	tiles = {"mesecraft_christmas_nodes_bell.png"},
	paramtype = "light",
	is_ground_content = true,
    inventory_image = 'mesecraft_christmas_nodes_bell.png',
    wield_image = 'mesecraft_christmas_nodes_bell.png',
    stack_max = 1,
	drawtype = "plantlike",
    on_punch = function (pos,node,puncher)
        minetest.sound_play( "mesecraft_christmas_bell",
           { pos = pos, gain = 1.5, max_hear_distance = 300,});
	end,

    after_place_node = function(pos, placer)
       -- remember that there is a bell at that position
       table.insert( bell_positions, pos );
       mesecraft_christmas.save_bell_positions( placer );
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       local found = 0;
       -- actually remove the bell from the list
       for i,v in ipairs( bell_positions ) do
          if( v ~= nil and v.x == pos.x and v.y == pos.y and v.z == pos.z ) then
             found = i;
          end
       end
       -- actually remove the bell
       if( found > 0 ) then
          table.remove( bell_positions, found );
          mesecraft_christmas.save_bell_positions( digger );
       end
    end,
    groups = {cracky=2},
})