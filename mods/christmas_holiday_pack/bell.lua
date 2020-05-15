-- Christmas Bell that rings every hour.
-- Most of this code is from the "bell" mod.

christmas_holiday_pack.bell_ring_interval = 3600; --60*60; -- ring each hour

christmas_holiday_pack.bell_save_file = minetest.get_worldpath().."/christmas_bell_positions.data";

local bell_positions = {};


christmas_holiday_pack.save_bell_positions = function( player )
  
   str = minetest.serialize( ({ bell_data = bell_positions}) );

   local file, err = io.open( christmas_holiday_pack.bell_save_file, "wb");
   if (err ~= nil) then
      if( player ) then
         minetest.chat_send_player(player:get_player_name(), "Error: Could not save bell data");
      end
      return
   end
   file:write( str );
   file:flush();
   file:close();
end


christmas_holiday_pack.restore_bell_data = function()

   local bell_position_table;

   local file, err = io.open(christmas_holiday_pack.bell_save_file, "rb");
   if (err ~= nil) then
      print("Error: Could not open bell data savefile (ignore this message on first start)");
      return
   end
   local str = file:read();
   file:close();
   
   local bell_positions_table = minetest.deserialize( str );
   if( bell_positions_table and bell_positions_table.bell_data ) then
     bell_positions = bell_positions_table.bell_data;
     print("[bell] Read positions of bells from savefile.");
   end
end
   

-- actually ring the bell
christmas_holiday_pack.ring_bell_once = function()

   for i,v in ipairs( bell_positions ) do
-- print("Ringing bell at "..tostring( minetest.pos_to_string( v )));
      minetest.sound_play( "bell_small",
        { pos = v, gain = 1.5, max_hear_distance = 300,});
   end
end



christmas_holiday_pack.ring_bell = function()

   -- figure out if this is the right time to ring
   local sekunde = tonumber( os.date( "%S"));
   local minute  = tonumber( os.date( "%M"));
   local stunde  = tonumber( os.date( "%I")); -- in 12h-format (a bell that rings 24x at once would not survive long...)
   local delay   = christmas_holiday_pack.bell_ring_interval;
 
   --print("[bells]It is now H:"..tostring( stunde ).." M:"..tostring(minute).." S:"..tostring( sekunde ));

   --local datum = os.date( "Stunde:%l Minute:%M Sekunde:%S");
   --print('[bells] ringing bells at '..tostring( datum ))

   delay = christmas_holiday_pack.bell_ring_interval - sekunde - (minute*60);

   -- make sure the bell rings the next hour
   minetest.after( delay, christmas_holiday_pack.ring_bell );

   -- if no bells are around then don't ring
   if( bell_positions == nil or #bell_positions < 1 ) then
      return;
   end

   if( sekunde > 10 ) then
--      print("[bells] Too late. Waiting for "..tostring( delay ).." seconds.");
      return;
   end

   -- ring the bell for each hour once
   for i=1,stunde do
     minetest.after( (i-1)*5,  christmas_holiday_pack.ring_bell_once );
   end

end

-- first call (after the server has been started)
minetest.after( 10, christmas_holiday_pack.ring_bell );
-- read data about bell positions
christmas_holiday_pack.restore_bell_data();


minetest.register_node("christmas_holiday_pack:christmas_bell", {
    description = "Bell",
    node_placement_prediction = "",
	tiles = {"christmas_holiday_pack_christmas_bell.png"},
	paramtype = "light",
	is_ground_content = true,
    inventory_image = 'christmas_holiday_pack_christmas_bell.png',
    wield_image = 'christmas_holiday_pack_christmas_bell.png',
    stack_max = 1,
	drawtype = "plantlike",
    on_punch = function (pos,node,puncher)
        minetest.sound_play( "bell_small",
           { pos = pos, gain = 1.5, max_hear_distance = 300,});
	end,

    after_place_node = function(pos, placer)
       if( placer ~= nil ) then
          minetest.chat_send_all(placer:get_player_name().." has placed a new bell at "..tostring( minetest.pos_to_string( pos )));
       end
       -- remember that there is a bell at that position
       table.insert( bell_positions, pos );
       christmas_holiday_pack.save_bell_positions( placer );
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       if( digger ~= nil ) then
          minetest.chat_send_all(digger:get_player_name().." has removed the bell at "..tostring( minetest.pos_to_string( pos )));
       end

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
          christmas_holiday_pack.save_bell_positions( digger );
       end
    end,
 
    groups = {cracky=2},
})


