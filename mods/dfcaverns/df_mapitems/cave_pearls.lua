local S = df_mapitems.S

minetest.register_node("df_mapitems:cave_pearls", {
	description = S("Cave Pearls"),
	tiles = {"dfcaverns_cave_pearl.png"},
	_doc_items_longdesc = df_mapitems.doc.cave_pearls_desc,
	_doc_items_usagehelp = df_mapitems.doc.cave_pearls_usage,
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 2},
	walkable = false,
	is_ground_content = false,
	climbable = true,
	light_source = 4,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, -0.375, -0.125, -0.3125, -0.125}, -- NodeBox1
			{0.125, -0.5, -0.1875, 0.3125, -0.375, 0}, -- NodeBox2
			{-0.125, -0.5, 0.25, 0.0625, -0.375, 0.4375}, -- NodeBox3
		}
	},
	on_place = df_mapitems.place_against_surface,
})
