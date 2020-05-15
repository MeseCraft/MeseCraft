slats = {}

function slats.register_slat(subname, recipeitem, groups, image, description, sounds)
	groups.slab = 1
	minetest.register_node(":slats:slat_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = {image},
		inventory_image = image,
		wield_image = image,
		paramtype = "light",
		paramtype2 = "wallmounted",
		is_ground_content = false,
		sunlight_propagates = true,
		groups = groups,
		sounds = sounds,
		node_box = {
			type = "wallmounted",
				wall_top    = {-0.5, 0.49, -0.5, 0.5, 0.49, 0.5},
				wall_bottom = {-0.5, -0.49, -0.5, 0.5, -0.49, 0.5},
				wall_side   = {-0.49, -0.5, -0.5, -0.49, 0.5, 0.5},
		},
	})

	if recipeitem then
		minetest.register_craft({
			type = "shapeless",
			output = 'slats:slat_' .. subname .. ' 12',
			recipe = {recipeitem, "default:paper"},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'slats:slat_' .. subname,
				burntime = math.floor(baseburntime * 0.5),
			})
		end
	end
end

slats.register_slat(
	"stone_block",
	"default:stone_block",
	{cracky = 2},
	"default_stone_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Stone Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"desert_stone_block",
	"default:desert_stone_block",
	{cracky = 2},
	"default_desert_stone_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Desert Stone Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"sandstone_block",
	"default:sandstone_block",
	{cracky = 2},
	"default_sandstone_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Sandstone Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"desert_sandstone_block",
	"default:desert_sandstone_block",
	{cracky = 2},
	"default_desert_sandstone_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Desert Sandstone Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"silver_sandstone_block",
	"default:silver_sandstone_block",
	{cracky = 2},
	"default_silver_sandstone_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Silver Sandstone Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"obsidian_block",
	"default:obsidian_block",
	{cracky = 1, level = 2},
	"default_obsidian_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Obsidian Block Slat",
	default.node_sound_stone_defaults()
)

slats.register_slat(
	"steelblock",
	"default:steelblock",
	{cracky = 1, level = 2},
	"default_steel_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Steel Block Slat",
	default.node_sound_metal_defaults()
)

slats.register_slat(
	"copperblock",
	"default:copperblock",
	{cracky = 1, level = 2},
	"default_copper_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Copper Block Slat",
	default.node_sound_metal_defaults()
)

slats.register_slat(
	"bronzeblock",
	"default:bronzeblock",
	{cracky = 1, level = 2},
	"default_bronze_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Bronze Block Slat",
	default.node_sound_metal_defaults()
)

slats.register_slat(
	"goldblock",
	"default:goldblock",
	{cracky = 1},
	"default_gold_block.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Gold Block Slat",
	default.node_sound_metal_defaults()
)

slats.register_slat(
	"wood",
	"default:wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	"default_wood.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Wooden Slat",
	default.node_sound_wood_defaults()
)

slats.register_slat(
	"junglewood",
	"default:junglewood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	"default_junglewood.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Jungle Wood Slat",
	default.node_sound_wood_defaults()
)

slats.register_slat(
	"pine_wood",
	"default:pine_wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	"default_pine_wood.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Pine Wood Slat",
	default.node_sound_wood_defaults()
)

slats.register_slat(
	"acacia_wood",
	"default:acacia_wood",
	{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	"default_acacia_wood.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Acacia Wood Slat",
	default.node_sound_wood_defaults()
)

slats.register_slat(
	"aspen_wood",
	"default:aspen_wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
	"default_aspen_wood.png^slats_slat_overlay.png^[makealpha:255,126,126",
	"Aspen Wood Slat",
	default.node_sound_wood_defaults()
)