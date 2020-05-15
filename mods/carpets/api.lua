local carpet_proto = {
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
	},
	groups = {
		snappy = 2,
		flammable = 3,
		oddly_breakable_by_hand = 3,
		choppy = 2,
		carpet = 1,
	}
}

-- Register the carpet and recipe using material
--    material - already registered material item the textures and sounds applied from
--    def - optional additional - or overriding data passed to minetest.register_node()
carpets = {}

function carpets.register(material, def)
	local node = table.copy(carpet_proto)
	if def then
		for k,v in pairs(def) do
			node[k] = v
		end
	end

	local material_def = minetest.registered_nodes[material]
	node.description = node.description or material_def.description.." Carpet"
	node.sounds = table.copy(node.sounds or material_def.sounds or default.node_sound_defaults())
	node.groups = table.copy(node.groups)

	if node.tiles then
		node.tiles = table.copy(node.tiles)
	elseif material_def.tiles[6] then
		node.tiles = {material_def.tiles[6]}
	else
		node.tiles = table.copy(material_def.tiles)
	end

	local name = "carpet:" .. (node.name or material:gsub(":", "_"))
	node.name = nil

	minetest.register_node(":" .. name, node)

	minetest.register_craft({
		output = name .. " 32",
		recipe = {
			{"group:wool", "group:wool", "group:wool"},
			{"group:wool", material, "group:wool"}
		}
	})
end
