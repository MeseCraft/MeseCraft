-- Disc shelf for storing music discs
-- Inventory overlay and blast code taken from vessels mod in MTG
-- All other code by Zorman2000

local function get_disc_shelf_formspec(inv)
	local formspec = gramophone.disc_shelf_formspec
	local invlist = inv and inv:get_list("main")
	-- Inventory slots overlay
	local vx, vy = 1.5, 0.25
	for i = 1, 10 do
		if i == 6 then
			vx = 1.5
			vy = vy + 1
		end
		if not invlist or invlist[i]:is_empty() then
			formspec = formspec ..
				"image[" .. vx .. "," .. vy .. ";1,1;vinyl_disc_overlay.png]"
		end
		vx = vx + 1
	end
	return formspec
end

local function update_disc_shelf(pos)
	-- Remove all objects
	local objs = minetest.get_objects_inside_radius(pos, 0.5)
	for _,obj in pairs(objs) do
		obj:remove()
	end

	local node = minetest.get_node(pos)
	local node_dir = minetest.facedir_to_dir(node.param2)
	local disc_dir = minetest.facedir_to_dir(node.param2 + 1 % 3)
	-- Place entities
	local start_pos = {
		x=pos.x - (0.585 * disc_dir.x) - (node_dir.x * 0.185), 
		y=pos.y - 0.15, 
		z=pos.z - (0.585 * disc_dir.z) - (node_dir.z * 0.185)}
	-- Calculate max disc count out of the 10 discs placeable in the shelf
	local inv = minetest.get_meta(pos):get_inventory()
	local list = inv:get_list("main")
	local max_disc_count = 0
	for _,itemstack in pairs(list) do
		if not itemstack:is_empty() then
			max_disc_count = max_disc_count + 1
		end
	end
	-- Update inventory images
	minetest.get_meta(pos):set_string("formspec", get_disc_shelf_formspec(inv))
	minetest.log("Found "..dump(max_disc_count).." disc stacks on inventory")
	if max_disc_count > 0 then
		if max_disc_count == 1 then
			max_disc_count = 2
		end
		minetest.log("Adding "..dump(math.floor(max_disc_count / 2)).." disc entities")
		-- Correct z
		if disc_dir.z == 0 and disc_dir.x == 0 then
			disc_dir.z = 1
		end
		for i = 1, math.floor(max_disc_count / 2) do
			minetest.log("I: "..dump(i))
			minetest.log("Start pos.x: "..dump(start_pos.x)..", disc_dir.x: "..dump(disc_dir.x)..", i: "..dump(i))
			minetest.log("Start pos.z: "..dump(start_pos.z)..", disc_dir.z: "..dump(disc_dir.z)..", i: "..dump(i))
		
			local disc_pos = {
					x=start_pos.x + (0.195 * i * disc_dir.x), 
					y=start_pos.y, 
					z=start_pos.z + (0.195 * i * disc_dir.z)
				}
			minetest.log("Adding disc entity at "..minetest.pos_to_string(disc_pos))
			local ent = minetest.add_entity(disc_pos,"gramophone:vinyl_disc_vertical")
			ent:set_yaw(minetest.dir_to_yaw(minetest.facedir_to_dir(node.param2 + 1 % 3)))
		end
	end

end


-- Disc shelf
minetest.register_node("gramophone:disc_shelf", {
	description = "Vinyl Record Shelf",
	tiles = {
		"speaker_side.png", "speaker_side.png",
		"speaker_side.png", "speaker_side.png",
		"speaker_side.png", "vinyl_disc_shelf_front.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5}, -- NodeBox1
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5}, -- NodeBox2
			{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5}, -- NodeBox3
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5}, -- NodeBox4
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox5
			{-0.3125, -0.5, -0.4375, -0.25, 0.1875, 0.5}, -- NodeBox6
			{-0.125, -0.5, -0.4375, -0.0625, 0.1875, 0.5}, -- NodeBox7
			{0.0625, -0.5, -0.4375, 0.125, 0.1875, 0.5}, -- NodeBox8
			{0.25, -0.5, -0.4375, 0.3125, 0.1875, 0.5}, -- NodeBox9
		}
	},
	groups = {cracky = 2},
	on_construct = function(pos)
		-- Initialize inventory
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
    	inv:set_size("main", 10)
    	-- Initialize formspec
    	meta:set_string("formspec", get_disc_shelf_formspec(inv))
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if minetest.get_item_group(stack:get_name(), "music_disc") ~= 0 then
			return stack:get_count()
		end
		return 0
	end,
	on_metadata_inventory_put = update_disc_shelf,
	on_metadata_inventory_take = update_disc_shelf,
	on_dig = function(pos, node, digger)
		-- Clear any object disc
		local objs = minetest.get_objects_inside_radius(pos, 0.5)
		for _,obj in pairs(objs) do
			obj:remove()
		end
		-- Pop-up disc if existing
		local meta = minetest.get_meta(pos)
		local list = meta:get_inventory():get_list("main")
		for _,item in pairs(list) do
			local drop_pos = {
				x=math.random(pos.x - 0.5, pos.x + 0.5), 
				y=pos.y, 
				z=math.random(pos.z - 0.5, pos.z + 0.5)}
			minetest.add_item(pos, item:get_name())
		end
		-- Remove node
		minetest.remove_node(pos)
	end,
	on_blast = function(pos)
		local drops = {}
		default.get_inventory_drops(pos, "vessels", drops)
		drops[#drops + 1] = "gramophone:disc_shelf"
		minetest.remove_node(pos)
		return drops
	end
})
--gramophone:disc_shelf
minetest.register_craft({
	output = "gramophone:disc_shelf",
	recipe = {
		{"default:wood", "default:wood", "default:wood"},
		{"default:wood", "gramophone:gramophone", "default:wood"},
		{"default:wood", "default:wood", "default:wood"}
	}
})
