if minetest.registered_nodes["tnt:tnt"] then
	tnt.register_tnt({
		name = "tnt:tnt",
		description = "TNT",
		radius = tonumber(minetest.settings:get("tnt_radius")) or 3,
		strength = 1000,
		time = 4,
		jump = 3,
		ignite_sound = {name = "tnt_ignite"},
		boom_sound = {name = "tnt_explode", def = {gain = 2.5, max_hear_distance = 128}}
	})

	-- Remove tnt:tnt_burning because if placed it will keep exploding.
	minetest.unregister_item("tnt:tnt_burning")
end

local tnt_damage_nodes = minetest.settings:get_bool("tnt_revamped.damage_nodes") or false

if minetest.settings:get("tnt_revamped.explosion") == "explosions" then
	local old_boom = tnt.boom
	tnt.boom = function(pos, def, owner, in_water)
		if not in_water or tnt_damage_nodes then
			explosions.explode(pos, def)
		else
			old_boom(pos, def, owner, in_water)
		end
	end
end
