S = minetest.get_translator("bell")

-- bell_positions are saved through server restart
-- bells ring every hour
-- they ring as many times as a bell ought to

local RING_INTERVAL = 3600 --60*60 -- ring each hour

local BELL_SAVE_FILE = minetest.get_worldpath().."/bell_positions.data"

local bell_positions = {}

local ring_big_bell = function(pos)
	minetest.sound_play( "bell_bell",
		{ pos = pos, gain = 1.5, max_hear_distance = 300,})
end
-- actually ring the bell
local ring_bell_once = function()
   for i,v in ipairs( bell_positions ) do
      ring_big_bell(v)
   end
end

local ring_bell_multiple = function(rings)
	for i=1, rings do
		minetest.after( (i-1)*5,  ring_bell_once )
	end
end

---------------------------------------------------------
--- Persistence

local save_bell_positions = function()
  
   local str = minetest.serialize( ({ bell_data = bell_positions}) )

   local file, err = io.open( BELL_SAVE_FILE, "wb")
   if (err ~= nil) then
      minetest.log("error", "[bell] Could not save bell data")
      return
   end
   file:write( str )
   file:flush()
   file:close()
   --minetest.chat_send_all("Wrote data to savefile "..tostring( BELL_SAVE_FILE ))
end

local restore_bell_data = function()

   local bell_position_table

   local file, err = io.open(BELL_SAVE_FILE, "rb")
   if (err ~= nil) then
      minetest.log("warning", "[bell] Could not open bell data savefile (ignore this message on first start)")
      return
   end
   local str = file:read()
   file:close()
   
   local bell_positions_table = minetest.deserialize( str )
   if( bell_positions_table and bell_positions_table.bell_data ) then
     bell_positions = bell_positions_table.bell_data
     minetest.log("action", "[bell] Read positions of bells from savefile.")
   end
end

---------------------------------------------------------
--- Local time handling

local rings_at_dawn = tonumber(minetest.settings:get("bell_tolls_at_dawn")) or 0
local rings_at_noon = tonumber(minetest.settings:get("bell_tolls_at_noon")) or 0
local rings_at_dusk = tonumber(minetest.settings:get("bell_tolls_at_dusk")) or 0
local rings_at_midnight = tonumber(minetest.settings:get("bell_tolls_at_midnight")) or 0

local ring_at_dawn =     rings_at_dawn > 0
local ring_at_noon =     rings_at_noon > 0
local ring_at_dusk =     rings_at_dusk > 0
local ring_at_midnight = rings_at_midnight > 0
local local_time = ring_at_dawn or ring_at_noon or ring_at_dusk or ring_at_midnight

local last_timeofday = 0
local dawn = 0.2 -- day and night in Minetest isn't exactly even
local noon = 0.5
local dusk = 0.8

if local_time then
	minetest.register_globalstep(function(dtime)
		local timeofday = minetest.get_timeofday()
		if ring_at_dawn and timeofday >= dawn and last_timeofday < dawn then
			ring_bell_multiple(rings_at_dawn)
			last_timeofday = timeofday
			return
		end
		if ring_at_noon and timeofday >= noon and last_timeofday < noon then
			ring_bell_multiple(rings_at_noon)
			last_timeofday = timeofday
			return
		end
		if ring_at_dusk and timeofday >= dusk and last_timeofday < dusk then
			ring_bell_multiple(rings_at_dusk)
			last_timeofday = timeofday
			return
		end
		if ring_at_midnight and timeofday < last_timeofday then
			-- day rolled over, it's midnight
			ring_bell_multiple(rings_at_midnight)
			last_timeofday = timeofday
			return
		end
		last_timeofday = timeofday
	end)
end

---------------------------------------------------------
--- Global time handling

local global_time = minetest.settings:get_bool("bell_tolls_at_server_hours", true)

local ring_bell
ring_bell = function()
	if not global_time then
		return
	end

   -- figure out if this is the right time to ring
   local sekunde = tonumber( os.date( "%S"))
   local minute  = tonumber( os.date( "%M"))
   local stunde  = tonumber( os.date( "%I")) -- in 12h-format (a bell that rings 24x at once would not survive long...)
   local delay   = RING_INTERVAL
 
   --print("[bells]It is now H:"..tostring( stunde ).." M:"..tostring(minute).." S:"..tostring( sekunde ))

   --local datum = os.date( "Stunde:%l Minute:%M Sekunde:%S")
   --print('[bells] ringing bells at '..tostring( datum ))

   delay = RING_INTERVAL - sekunde - (minute*60)

   -- make sure the bell rings the next hour
   minetest.after( delay, ring_bell )

   -- if no bells are around then don't ring
   if( bell_positions == nil or #bell_positions < 1 ) then
      return
   end

   if( sekunde > 10 ) then
--      print("[bells] Too late. Waiting for "..tostring( delay ).." seconds.")
      return
   end

   -- ring the bell for each hour once
   ring_bell_multiple(stunde)
end

-- first call (after the server has been started)
minetest.after( 10, ring_bell )
-- read data about bell positions
restore_bell_data()

---------------------------------------------------------
--- Node definitions

local bell_base = {
	paramtype = "light",
    description = S("Bell"),
    stack_max = 1,

    on_punch = function (pos,node,puncher)
        ring_big_bell(pos)
	end,

	on_construct = function(pos)
       -- remember that there is a bell at that position
       table.insert( bell_positions, pos )
       save_bell_positions()
	end,

	on_destruct = function(pos)
       local found = 0
       -- actually remove the bell from the list
       for i,v in ipairs( bell_positions ) do
          if(v ~= nil and vector.equals(v, pos)) then
             table.remove( bell_positions, i)
			 save_bell_positions()
			 break
          end
       end
    end,

    groups = {cracky=2},
}

if minetest.get_modpath("mesecons") then
	bell_base.mesecons = {
		effector = {
			action_on = ring_big_bell,
		}
	}
end


local ring_small_bell = function(pos)
	minetest.sound_play( "bell_small",
		{ pos = pos, gain = 1.5, max_hear_distance = 60,})
end


local small_bell_base = {
    description = S("Small bell"),
	paramtype = "light",
    stack_max = 1,
    on_punch = function (pos,node,puncher)
        ring_small_bell(pos)
	end,
    groups = {cracky=2},
}

if minetest.get_modpath("mesecons") then
	small_bell_base.mesecons = {
		effector = {
			action_on = ring_small_bell,
		}
	}
end

----------------------------------------------------
bell_enable_model = false
if minetest.settings:get_bool("bell_enable_model", true) then
----------------
-- Model-type bell
	local bell_def = {
		drawtype = "mesh",
		mesh = "bell_bell.obj",
		tiles = {
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "default_wood.png", backface_culling = true }, --
			},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
			},
		},
		paramtype2 = "facedir",
	}
	
	for k, v in pairs(bell_base) do
		bell_def[k] = v
	end
	
	minetest.register_node("bell:bell", bell_def)
	
	local small_bell_def = 
	{	drawtype = "mesh",
		mesh = "bell_small_bell.obj",
		tiles = {
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "bell_hull.png", backface_culling = true }, -- 
			{ name = "default_wood.png", backface_culling = true }, --
			},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.25, -0.375, 0.375, 0.5, 0.375},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.375, -0.25, -0.375, 0.375, 0.5, 0.375},
			},
		},
		paramtype2 = "facedir",
	}
	
	for k, v in pairs(small_bell_base) do
		small_bell_def[k] = v
	end
	
	minetest.register_node("bell:bell_small", small_bell_def)

else
--------------------
-- Plantlike-type bell
	local bell_def = {
		tiles = {"bell_bell.png"},
		inventory_image = 'bell_bell.png',
		wield_image = 'bell_bell.png',
		drawtype = "plantlike",
	}
	for k, v in pairs(bell_base) do
		bell_def[k] = v
	end
	
	minetest.register_node("bell:bell", bell_def)
	
	local small_bell_def = {
		tiles = {"bell_bell.png"},
		inventory_image = 'bell_bell.png',
		wield_image = 'bell_bell.png',
		drawtype = "plantlike",
	}
	for k, v in pairs(small_bell_base) do
		small_bell_def[k] = v
	end
	
	minetest.register_node("bell:bell_small", small_bell_def)
end

---------------------------------------------------------
--- Recipes

if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "bell:bell_small",
		recipe = {
			{"",                  "default:goldblock", ""                 },
			{"default:goldblock", "default:goldblock", "default:goldblock"},
			{"default:goldblock", "",                  "default:goldblock"},
		},
	})
	minetest.register_craft({
		output = "bell:bell",
		recipe = {
			{"default:goldblock", "default:goldblock", "default:goldblock"},
			{"default:goldblock", "default:goldblock", "default:goldblock"},
			{"default:goldblock", "",                  "default:goldblock"},
		},
	})
end
