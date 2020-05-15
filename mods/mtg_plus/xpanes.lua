xpanes.register_pane("papyrus", {
	description = "Papyrus Lattice",
	inventory_image = "mtg_plus_papyrus_lattice.png",
	wield_image = "mtg_plus_papyrus_lattice.png",
	textures = {"mtg_plus_papyrus_lattice.png","mtg_plus_papyrus_lattice.png","mtg_plus_papyrus_lattice.png"},
	groups = {snappy=2, choppy=1, flammable=2,pane=1},
	sounds = default.node_sound_leaves_defaults(),
	recipe = {
		{ "default:papyrus", "farming:string", "default:papyrus" },
		{ "default:papyrus", "farming:string", "default:papyrus" },
	}
})

if minetest.registered_items["xpanes:papyrus_flat"] then
	r = "xpanes:papyrus_flat"
else
	r = "xpanes:papyrus"
end
minetest.register_craft({
	type = "fuel",
	recipe = r,
	burntime = 1,
})
