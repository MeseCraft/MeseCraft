df_caverns.node_id = {}

minetest.after(1, function() df_caverns.node_id = nil end) -- should only be used during initialization.

if minetest.get_modpath("ice_sprites") then
	df_caverns.node_id.sprite = minetest.get_content_id("ice_sprites:ice_sprite")
end

if minetest.get_modpath("fireflies") then
	df_caverns.node_id.fireflies = minetest.get_content_id("fireflies:firefly")
end

if minetest.get_modpath("df_farming") then
	df_caverns.node_id.dead_fungus = minetest.get_content_id("df_farming:dead_fungus")
end

df_caverns.node_id.air = minetest.get_content_id("air")

df_caverns.node_id.cobble = minetest.get_content_id("default:cobble")
df_caverns.node_id.desert_sand = minetest.get_content_id("default:desert_sand")
df_caverns.node_id.dirt = minetest.get_content_id("default:dirt")
df_caverns.node_id.gravel = minetest.get_content_id("default:gravel")
df_caverns.node_id.ice = minetest.get_content_id("default:ice")
df_caverns.node_id.lava = minetest.get_content_id("default:lava_source")
df_caverns.node_id.meseore = minetest.get_content_id("default:stone_with_mese")
df_caverns.node_id.mossycobble = minetest.get_content_id("default:mossycobble")
df_caverns.node_id.obsidian = minetest.get_content_id("default:obsidian")
df_caverns.node_id.sand = minetest.get_content_id("default:sand")
df_caverns.node_id.silver_sand = minetest.get_content_id("default:silver_sand")
df_caverns.node_id.snow = minetest.get_content_id("default:snow")
df_caverns.node_id.stone = minetest.get_content_id("default:stone")
df_caverns.node_id.stone_with_coal = minetest.get_content_id("default:stone_with_coal")
df_caverns.node_id.water = minetest.get_content_id("default:water_source")

df_caverns.node_id.cobble_fungus = minetest.get_content_id("df_mapitems:cobble_with_floor_fungus")
df_caverns.node_id.cobble_fungus_fine = minetest.get_content_id("df_mapitems:cobble_with_floor_fungus_fine")
df_caverns.node_id.dirt_moss = minetest.get_content_id("df_mapitems:dirt_with_cave_moss")
df_caverns.node_id.dry_flowstone = minetest.get_content_id("df_mapitems:dry_flowstone")
df_caverns.node_id.glow_ore = minetest.get_content_id("df_mapitems:glow_ruby_ore")
df_caverns.node_id.hoar_moss = minetest.get_content_id("df_mapitems:ice_with_hoar_moss")
df_caverns.node_id.mese_crystal = minetest.get_content_id("df_mapitems:mese_crystal")
df_caverns.node_id.mese_crystal_block = minetest.get_content_id("df_mapitems:glow_mese")
df_caverns.node_id.pearls = minetest.get_content_id("df_mapitems:cave_pearls")
df_caverns.node_id.pebble_fungus = minetest.get_content_id("df_mapitems:dirt_with_pebble_fungus")
df_caverns.node_id.rock_rot = minetest.get_content_id("df_mapitems:rock_rot")
df_caverns.node_id.spongestone = minetest.get_content_id("df_mapitems:spongestone")
df_caverns.node_id.salt_crystal = minetest.get_content_id("df_mapitems:salt_crystal")
df_caverns.node_id.salty_cobble = minetest.get_content_id("df_mapitems:salty_cobble")
df_caverns.node_id.sand_scum = minetest.get_content_id("df_mapitems:sand_scum")
df_caverns.node_id.stillworm = minetest.get_content_id("df_mapitems:dirt_with_stillworm")
df_caverns.node_id.veinstone = minetest.get_content_id("df_mapitems:veinstone")
df_caverns.node_id.wet_flowstone = minetest.get_content_id("df_mapitems:wet_flowstone")

df_caverns.node_id.spindlestem_red = minetest.get_content_id("df_trees:spindlestem_cap_red")
df_caverns.node_id.spindlestem_white = minetest.get_content_id("df_trees:spindlestem_cap_white")

df_caverns.node_id.amethyst = minetest.get_content_id("df_underworld_items:glow_amethyst")
df_caverns.node_id.glowstone = minetest.get_content_id("df_underworld_items:glowstone")
df_caverns.node_id.pit_plasma = minetest.get_content_id("df_underworld_items:pit_plasma")
df_caverns.node_id.slade = minetest.get_content_id("df_underworld_items:slade")
df_caverns.node_id.slade_block = minetest.get_content_id("df_underworld_items:slade_block")

df_caverns.node_id.oil = minetest.get_content_id("oil:oil_source")

df_caverns.node_id.gas = minetest.get_content_id("mine_gas:gas")
df_caverns.node_id.gas_wisp = minetest.get_content_id("mine_gas:gas_wisp")

df_caverns.node_id.giant_mycelium = minetest.get_content_id("df_primordial_items:giant_hypha_apical_mapgen")
df_caverns.node_id.ivy = minetest.get_content_id("df_primordial_items:jungle_ivy")
df_caverns.node_id.jungle_dirt = minetest.get_content_id("df_primordial_items:dirt_with_jungle_grass")
df_caverns.node_id.mycelial_dirt = minetest.get_content_id("df_primordial_items:dirt_with_mycelium")
df_caverns.node_id.orb = minetest.get_content_id("df_primordial_items:glow_orb_hanging")
df_caverns.node_id.packed_roots = minetest.get_content_id("df_primordial_items:packed_roots")
df_caverns.node_id.plant_matter = minetest.get_content_id("df_primordial_items:plant_matter")
df_caverns.node_id.root_1 = minetest.get_content_id("df_primordial_items:jungle_roots_1")
df_caverns.node_id.root_2 = minetest.get_content_id("df_primordial_items:jungle_roots_2")