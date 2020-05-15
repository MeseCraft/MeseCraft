
-- check for available hunger mods
local hmod = minetest.global_exists("hunger")
local hbmod = minetest.global_exists("hbhunger")
local stmod = minetest.global_exists("stamina")

-- eat pie slice function
local replace_pie = function(node, puncher, pos)

	-- is this my pie?
	if minetest.is_protected(pos, puncher:get_player_name()) then
		return
	end

	-- which size of pie did we hit?
	local pie = node.name:split("_")[1]
	local num = tonumber(node.name:split("_")[2])

	-- are we using crystal shovel to pick up full pie using soft touch?
	local tool = puncher:get_wielded_item():get_name()
	if num == 0 and tool == "ethereal:shovel_crystal" then

		local inv = puncher:get_inventory()

		minetest.remove_node(pos)

		if inv:room_for_item("main", {name = pie .. "_0"}) then
			inv:add_item("main", pie .. "_0")
		else
			pos.y = pos.y + 0.5
			minetest.add_item(pos, {name = pie .. "_0"})
		end

		return
	end

	-- eat slice or remove whole pie
	if num == 3 then
		node.name = "air"
	elseif num < 3 then
		node.name = pie .. "_" .. (num + 1)
	end

	minetest.swap_node(pos, {name = node.name})

	-- Blockmen's hud_hunger mod
	if hmod then

		local h = hunger.read(puncher)
--		print ("hunger is "..h)

		h = math.min(h + 4, 30)

		local ok = hunger.update_hunger(puncher, h)

		minetest.sound_play("hunger_eat", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- Wuzzy's hbhunger mod
	elseif hbmod then

		local h = tonumber(hbhunger.hunger[puncher:get_player_name()])
--		print ("hbhunger is "..h)

		h = math.min(h + 4, 30)

		hbhunger.hunger[puncher:get_player_name()] = h

		minetest.sound_play("hbhunger_eat_generic", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- Sofar's stamina mod
	elseif stmod then

		stamina.change(puncher, 4)

		minetest.sound_play("stamina_eat", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- none of the above found? add to health instead
	else

		local h = puncher:get_hp()
--		print ("health is "..h)

		h = math.min(h + 4, 20)

		puncher:set_hp(h)
	end
end


-- register pie bits
local register_pie = function(pie, desc)

	-- full pie
	minetest.register_node("pie:" .. pie .. "_0", {
		description = desc,
		paramtype = "light",
		sunlight_propagates = false,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_side.png"
		},
		inventory_image = pie .. "_inv.png",
		wield_image = pie .. "_inv.png",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, -0.45, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 3/4 pie
	minetest.register_node("pie:" .. pie .. "_1", {
		description = "3/4" .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, -0.25, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 1/2 pie
	minetest.register_node("pie:" .. pie .. "_2", {
		description = "Half " .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, 0.0, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 1/4 pie
	minetest.register_node("pie:" .. pie .. "_3", {
		description = "Piece of " .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, 0.25, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

end


-- normal cake
register_pie("pie", "Cake")

minetest.register_craft({
	output = "pie:pie_0",
	recipe = {
		{"group:food_sugar", "group:food_milk", "group:food_sugar"},
		{"group:food_sugar", "group:food_egg", "group:food_sugar"},
		{"group:food_wheat", "group:food_flour", "group:food_wheat"},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})


-- add lucky blocks
if minetest.get_modpath("lucky_block") then
lucky_block:add_blocks({
	{"nod", "pie:pie_0", 0},
	{"nod", "pie:choc_0", 0},
	{"nod", "pie:coff_0", 0},
	{"tro", "pie:pie_0"},
	{"nod", "pie:rvel_0", 0},
	{"nod", "pie:scsk_0", 0},
	{"nod", "pie:bana_0", 0},
	{"nod", "pie:orange_0", 0},
	{"tro", "pie:orange_0", "default_place_node_hard", true},
	{"nod", "pie:brpd_0", 0},
	{"nod", "pie:meat_0", 0},
	{"lig"},
})
end

print ("[MOD] Pie loaded")
