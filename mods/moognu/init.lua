minetest.register_node("moognu:moognu", {
	description = "MooGNU",
	tiles = {"moognu_side.png", "moognu_side.png", "moognu_side.png",
		"moognu_side.png", "moognu_back.png", "moognu_front.png"},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_node("moognu:moognu_rainbow", {
	description = "MooGNU Rainbow",
	tiles = {
		"moognu_rainbow.png^[transformR90",
		"moognu_rainbow.png^[transformR90",
		"moognu_rainbow.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "moognu:moognu",
	burntime = 1,
})

minetest.register_craft({
	type = "fuel",
	recipe = "moognu:moognu_rainbow",
	burntime = 1,
})

moognu = {}

function moognu.place(pos, facedir, length)
	if facedir > 3 then
		facedir = 0
	end
	local tailvec = minetest.facedir_to_dir(facedir)
	local p = {x = pos.x, y = pos.y, z = pos.z}
	minetest.set_node(p, {name = "moognu:moognu", param2 = facedir})
	for i = 1, length do
		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z
		minetest.set_node(p, {name = "moognu:moognu_rainbow", param2 = facedir})
	end
end

function moognu.generate(minp, maxp, seed)
	local height_min = -31000
	local height_max = -32
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x - minp.x + 1) * (y_max - y_min + 1) * (maxp.z - minp.z + 1)
	local pr = PseudoRandom(seed + 9324342)
	local max_num_moognus = math.floor(volume / (16 * 16 * 16))
	for i = 1, max_num_moognus do
		if pr:next(0, 1000) == 0 then
			local x0 = pr:next(minp.x, maxp.x)
			local y0 = pr:next(minp.y, maxp.y)
			local z0 = pr:next(minp.z, maxp.z)
			local p0 = {x = x0, y = y0, z = z0}
			moognu.place(p0, pr:next(0, 3), pr:next(3, 15))
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	moognu.generate(minp, maxp, seed)
end)

-- Legacy
minetest.register_alias("default:nyancat", "moognu:moognu")
minetest.register_alias("nyancat:nyancat", "moognu:moognu")
minetest.register_alias("default:nyancat_rainbow", "moognu:moognu_rainbow")
minetest.register_alias("nyancat:nyancat_rainbow", "moognu:moognu_rainbow")