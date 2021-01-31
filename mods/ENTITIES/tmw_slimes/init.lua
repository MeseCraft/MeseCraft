tmw_slimes = {}
tmw_slimes.path = minetest.get_modpath("tmw_slimes").."/slimes/"
tmw_slimes.colors = {}


minetest.register_craftitem("tmw_slimes:live_nucleus", {
	description = "Living Nucleus",
	inventory_image = "tmw_slime_nucleus.png"
})

tmw_slimes.add_slime = function(string, aquatic) 
	local proper_name = string.upper(string.sub(string,1,1))..string.sub(string,2,-1)
	minetest.register_craftitem("tmw_slimes:"..string.."_goo", {
		inventory_image = "tmw_slime_goo.png^[colorize:"..tmw_slimes.colors[string],
		description = proper_name.." Goo",
		groups = {slime = 1},
	})

	minetest.register_node("tmw_slimes:"..string.."_goo_block", {
		tiles = {"tmw_slime_goo_block.png^[colorize:"..tmw_slimes.colors[string].."^[colorize:#0000:25"},
		description = proper_name.." Goo Block",
		drawtype = "allfaces_optional",
		use_texture_alpha = true,
		groups = {slippery = 2, crumbly=3, oddly_breakable_by_hand = 1, fall_damage_add_percent=-80, bouncy=90},
		sounds = default.node_sound_snow_defaults(),
	})
	local goo = "tmw_slimes:"..string.."_goo"
	minetest.register_craft({
		output = "tmw_slimes:"..string.."_goo_block",
		recipe = {
			{goo,goo,goo},
			{goo,goo,goo},
			{goo,goo,goo}
		}
	})
	
	dofile(tmw_slimes.path..string..".lua")
	mobs:register_egg("tmw_slimes:"..string.."_slime", proper_name.." Slime", "tmw_slime_".."inventory.png^[colorize:"..tmw_slimes.colors[string]..
		(aquatic and "^(tmw_slime_aquatic_inventory.png^[colorize:"..tmw_slimes.colors[string].."^[colorize:#FFF:96)" or ""), 
	0)
	minetest.register_craft({
		output = "tmw_slimes:"..string.."_slime",
		recipe = {
			{goo,goo,goo},
			{goo,"tmw_slimes:live_nucleus",goo},
			{goo,goo,goo}
		}
	})
	
end
tmw_slimes.weak_dmg   = 1
tmw_slimes.medium_dmg = 5
tmw_slimes.strong_dmg = 10
tmw_slimes.deadly_dmg = 50

tmw_slimes.pervasive = 5000
tmw_slimes.common    = 10000
tmw_slimes.uncommon  = 15000
tmw_slimes.rare      = 25000

tmw_slimes.pervasive_max = 8
tmw_slimes.common_max    = 6
tmw_slimes.uncommon_max  = 4
tmw_slimes.rare_max      = 2

tmw_slimes.absorb_nearby_items = function(ent)
	local pos = ent.object:get_pos()
	for _,obj in pairs(minetest.get_objects_inside_radius(pos, 1.25)) do
		local oent = obj:get_luaentity()
		if oent and oent.name == "__builtin:item" then
			if not ent.stomach then ent.stomach = {} end
			if #ent.stomach >= 24 then break end
			table.insert(ent.stomach, oent.itemstring)
			obj:remove()
			minetest.sound_play("mobs_monster_slime_slurp", {pos = pos, max_hear_distance = 10, gain = 0.7})
			ent.lifetimer = (ent.lifetimer and ent.lifetimer > 20000) and ent.lifetimer + 7200 or 27200
			 -- Keep this slime around even after unload for at least another 2 hours per item picked up, 
			 -- so slimes don't just grab killed players' items and despawn.
			 
			break --Pick up only one item per step
		end
	end
end

tmw_slimes.drop_items = function(self, pos)
	if self.stomach then
		for _,item in ipairs(self.stomach) do
			minetest.add_item({x=pos.x + math.random()/2,y=pos.y+0.5,z=pos.z+math.random()/2}, item)
		end
	end
end

tmw_slimes.animate = function(ent)
	if not (ent and minetest.registered_entities[ent.name] and ent.object) then return end
	local pos = ent.object:get_pos()
	local velocity = ent.object:get_velocity()
	local is_liquid_below = ((minetest.registered_nodes[minetest.get_node({x=pos.x,y=pos.y-0.5,z=pos.z}).name] or {liquidtype = "none"}).liquidtype == "none")
	local land_movement = (minetest.registered_entities[ent.name].mesh == "slime_land.b3d") or not is_liquid_below
	if velocity.y ~= 0 then
		if not land_movement and (math.abs(velocity.x) > math.abs(velocity.y) or math.abs(velocity.z) > math.abs(velocity.y)) then
			mobs.set_animation(ent, "move")
			return
		end
		if velocity.y > 0 then
			mobs:set_animation(ent, "jump")
			return
		else
			mobs:set_animation(ent, "fall")
			return
		end
	end
	if velocity.x ~= 0 or velocity.z ~= 0 then
		mobs:set_animation(ent, "move")
		return
	end
	mobs:set_animation(ent, "idle")
end

--Land model
tmw_slimes.colors["poisonous"] = "#205:200"
tmw_slimes.add_slime("poisonous")
tmw_slimes.colors["jungle"] = "#0A1:180"
tmw_slimes.add_slime("jungle")
tmw_slimes.colors["savannah"] = "#204004:200"
tmw_slimes.add_slime("savannah")
tmw_slimes.colors["icy"] = "#8BF:160"
tmw_slimes.add_slime("icy")

--Land model (underground)

tmw_slimes.colors["mineral"] = "#584000:225"
tmw_slimes.add_slime("mineral")
tmw_slimes.colors["dark"] = "#000:220"
tmw_slimes.add_slime("dark")

if minetest.get_modpath("other_worlds") then
	tmw_slimes.colors["alien"] = "#800:220"
	tmw_slimes.add_slime("alien", true)
end

--Liquid model

tmw_slimes.colors["cloud"] = "#EEF:180"
tmw_slimes.add_slime("cloud", true)

tmw_slimes.colors["algae"] = "#0C9:180"
tmw_slimes.add_slime("algae", true)

tmw_slimes.colors["ocean"] = "#00C:200"
tmw_slimes.add_slime("ocean", true)

tmw_slimes.colors["lava"] = "#F80:190"
tmw_slimes.add_slime("lava", true)

minetest.register_craft({
	output = "tmw_slimes:live_nucleus",
	recipe = {"tmw_slimes:lava_goo","tmw_slimes:ocean_goo","tmw_slimes:mineral_goo"},
	type="shapeless"
})


tmw_slimes.colors["uber"] = "#FD0:200"
dofile(tmw_slimes.path.."uber.lua")

minetest.register_abm({
	nodenames = {"group:harmful_slime"},
	interval = 2,
	chance = 1,
	action = function(pos, node)
		local dmg = minetest.registered_nodes[node.name].groups.harmful_slime
		for _,ent in pairs(minetest.get_objects_inside_radius(pos, 1.75)) do
			if ent:is_player() then
				ent:punch(ent, nil, {damage_groups={fleshy=dmg}}, nil)
			else
				local luaent = ent:get_luaentity()
				if luaent and 
					luaent._cmi_is_mob and 
					not string.find(node.name, string.sub(luaent.name, 11, -7).."_goo")
				then
					ent:punch(ent, nil, {damage_groups={fleshy=dmg}}, nil)
				end
			end 
		end
	end
})
