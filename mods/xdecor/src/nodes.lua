screwdriver = screwdriver or {}

local function register_storage(name, desc, def)
	xdecor.register(name, {
		description = desc,
		inventory = {size=def.inv_size or 24},
		infotext = desc,
		tiles = def.tiles,
		node_box = def.node_box,
		on_rotate = def.on_rotate,
		on_place = def.on_place,
		groups = def.groups or {choppy=2, oddly_breakable_by_hand=1, flammable=2},
		sounds = default.node_sound_wood_defaults()
	})
end

register_storage("cabinet", "Wooden Cabinet", {
	on_rotate = screwdriver.rotate_simple,
	tiles = {"xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_cabinet_sides.png", "xdecor_cabinet_front.png"}
})

register_storage("cabinet_half", "Half Wooden Cabinet", {
	inv_size = 8,
	node_box = xdecor.nodebox.slab_y(0.5, 0.5),
	on_rotate = screwdriver.rotate_simple,
	tiles = {"xdecor_cabinet_sides.png", "xdecor_cabinet_sides.png",
		 "xdecor_half_cabinet_sides.png", "xdecor_half_cabinet_sides.png",
		 "xdecor_half_cabinet_sides.png", "xdecor_half_cabinet_front.png"}
})

for _, f in pairs({"dandelion_white", "dandelion_yellow", "geranium",
		"rose", "tulip", "viola"}) do
	xdecor.register("potted_"..f, {
		description = "Potted "..f:gsub("%f[%w]%l", string.upper):gsub("_", " "),
		walkable = false,
		groups = {snappy=3, flammable=3, plant=1, flower=1},
		tiles = {"xdecor_"..f.."_pot.png"},
		inventory_image = "xdecor_"..f.."_pot.png",
		drawtype = "plantlike",
		sounds = default.node_sound_leaves_defaults(),
		selection_box = xdecor.nodebox.slab_y(0.3)
	})

	minetest.register_craft({
		output = "xdecor:potted_"..f,
		recipe = {{"default:clay_brick", "flowers:"..f,
			   "default:clay_brick"}, {"", "default:clay_brick", ""}}
	})
end

local function register_hard_node(name, desc, def)
	def = def or {}
	xdecor.register(name, {
		description = desc,
		tiles = {"xdecor_"..name..".png"},
		groups = def.groups or {cracky=1},
		sounds = def.sounds or default.node_sound_stone_defaults()
	})
end

xdecor.register("tv", {
	description = "Television",
	light_source = 11,
	groups = {cracky=3, oddly_breakable_by_hand=2},
	on_rotate = screwdriver.rotate_simple,
	tiles = {"xdecor_television_left.png^[transformR270",
		 "xdecor_television_left.png^[transformR90",
		 "xdecor_television_left.png^[transformFX",
		 "xdecor_television_left.png", "xdecor_television_back.png",
		{name="xdecor_television_front_animated.png",
		 animation = {type="vertical_frames", length=80.0}} }
})
