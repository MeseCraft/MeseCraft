local well_capacity = 20.0 --Units are amount of buckets fillable
local barrel_capacity = 5.0
local well_interval = 2400 --In seconds
local barrel_interval = ((snowdrift and snowdrift.get_precip) and 300 or 1200)
-- If you use snowdrift (and a version which provides get_precip),
-- Then rain barrels fill MUCH more quickly than wells, but only in the rain.
-- Otherwise, they're only twice as fast.


minetest.override_item("default:water_source", {
	liquid_renewable = false,
})

minetest.override_item("default:water_flowing", {
	liquid_renewable = false,
})


local function barrel_drain(pos,_,player)
	local name = player:get_player_name()
	if minetest.is_protected(pos, name) 
		and not minetest.check_player_privs(name, {protection_bypass=true}) 
	then return end
	
	local meta = minetest.get_meta(pos)
	local water = meta:get_float("water") or 0.0
	if not (player:get_wielded_item():get_name() == "bucket:bucket_empty") then return end
	if water >= 1.0 then --Code copied from buckets
		water = water - 1.0
		local item_count = player:get_wielded_item():get_count()
		local giving_back = "bucket:bucket_water"
		if item_count > 1 then

			-- if space in inventory add filled bucked, otherwise drop as item
			local inv = player:get_inventory()
			if inv:room_for_item("main", {name="bucket:bucket_water"}) then
				inv:add_item("main", "bucket:bucket_water")
			else
				local pos = player:getpos()
				pos.y = math.floor(pos.y + 0.5)
				minetest.add_item(pos, "bucket:bucket_water")
			end

			-- set to return empty buckets minus 1
			giving_back = "bucket:bucket_empty "..tostring(item_count-1)
		end
		player:set_wielded_item(giving_back)
		meta:set_float("water", water)
	else
		minetest.chat_send_player(name, "There's not enough water in this container to fill a bucket.")
	end
end

local function barrel_fill(pos,capacity)
	local meta = minetest.get_meta(pos)
	local water = meta:get_float("water") or 0.0
	local raise = (math.random(1,3)/2) --0.5, 1, or 1.5
	if (water + raise) < capacity then 
		water = water + raise
	else
		water = capacity
	end
	meta:set_float("water", water)	
end

minetest.register_node("rainbarrel:well", {
	description = "Well",
	drawtype = "mesh",
	mesh = "rainbarrel_well.obj",
	paramtype = "light",
	groups = {cracky=3},
	tiles = {minetest.registered_nodes["default:water_source"].tiles[1],"default_wood.png","default_stone.png","default_cobble.png"},
	collision_box = {type="fixed", fixed={-0.6,-0.5,-0.6,0.6,1.0,0.6}},
	selection_box = {type="fixed", fixed={-0.6,-0.5,-0.6,0.6,1.0,0.6}},
	on_timer = function(pos)
		barrel_fill(pos, well_capacity)
		minetest.get_node_timer(pos):start(well_interval)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(well_interval)
	end,
	on_punch = barrel_drain,
})

minetest.register_node("rainbarrel:barrel", {
	description = "Rain Barrel",
	drawtype = "nodebox",
	node_box = {type="fixed",
		fixed = {
			{-0.375,-0.5,-0.375,0.375,0.5,0.375},
			{-0.0625,-0.4375,-0.375,0.0625,-0.3125,-0.5}
		}	
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=1},
	tiles = {"rainbarrel_top.png","rainbarrel_top.png^[transformR180","rainbarrel_side.png","rainbarrel_side.png","rainbarrel_side.png","rainbarrel_front.png"},
	on_punch = barrel_drain,
	on_place = minetest.rotate_node,
	on_timer = function(pos)
		local canfill = (minetest.get_node_light({x=pos.x,y=pos.y+1,z=pos.z}, 0.5) == 15)
		if canfill and snowdrift and snowdrift.get_precip then
			if snowdrift.get_precip(pos) ~= "rain" then
				canfill = false
			end
		end
		if canfill then
			barrel_fill(pos, barrel_capacity)
		end
		minetest.get_node_timer(pos):start(barrel_interval)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(barrel_interval)
	end,
})

local w = "group:wood"
local c = "default:cobble"
local b = "bucket:bucket_empty"
minetest.register_craft({
	output="rainbarrel:barrel",
	recipe={
	{w,"",w},
	{w,b,w},
	{w,w,w},
	}
	
})

minetest.register_craft({
	output="rainbarrel:well",
	recipe={
	{w,w,w},
	{c,b,c},
	{c,"",c},
	}
	
})
