local S = minetest.get_translator("tsm_pyramids")

local mod_cmi = minetest.get_modpath("cmi") ~= nil

local mummy_walk_limit = 1
local mummy_chillaxin_speed = 1
local mummy_animation_speed = 10
-- Note: This is currently broken due to a bug in Irrlicht, leave at 0
local mummy_animation_blend = 0

-- Default player appearance
local mummy_mesh = "tsm_pyramids_mummy.x"
local mummy_texture = {"tsm_pyramids_mummy.png"}
local mummy_hp = 20
local mummy_drop = "default:papyrus"

local sound_normal = "mummy"
local sound_hit = "mummy_hurt"
local sound_dead = "mummy_death"

local spawner_check_range = 17
local spawner_max_mobs = 6

local function get_animations()
	return {
		stand_START = 74,
		stand_END = 74,
		sit_START = 81,
		sit_END = 160,
		lay_START = 162,
		lay_END = 166,
		walk_START = 74,
		walk_END = 105,
		mine_START = 74,
		mine_END = 105,
		walk_mine_START = 74,
		walk_mine_END = 105
	}
end

local npc_model = {}
local npc_anim = {}
local npc_sneak = {}
local ANIM_STAND = 1
local ANIM_SIT = 2
local ANIM_LAY = 3
local ANIM_WALK  = 4
local ANIM_WALK_MINE = 5
local ANIM_MINE = 6

local function hit(self)
	local prop = {
		mesh = mummy_mesh,
		textures = {"tsm_pyramids_mummy.png^tsm_pyramids_hit.png"},
	}
	self.object:set_properties(prop)
	minetest.after(0.4, function(self)
		local prop = {textures = mummy_texture,}
		if self ~= nil and self.object ~= nil then
			self.object:set_properties(prop)
		end
	end, self)
end

local function mummy_update_visuals_def(self)
	npc_anim = 0 -- Animation will be set further below immediately
	local prop = {
		mesh = mummy_mesh,
		textures = mummy_texture,
	}
	self.object:set_properties(prop)
end

local MUMMY_DEF = {
	hp_max = mummy_hp,
	physical = true,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	visual_size = {x=8,y=8},
	mesh = mummy_mesh,
	textures = mummy_texture,
	makes_footstep_sound = true,
	npc_anim = 0,
	timer = 0,
	turn_timer = 0,
	vec = 0,
	yaw = 0,
	yawwer = 0,
	state = 1,
	jump_timer = 0,
	punch_timer = 0,
	sound_timer = 0,
	envdmg_timer = 0,
	attacker = "",
	attacking_timer = 0,

	-- CMI stuff
	-- Track last cause of damage for cmi.notify_die
	last_damage_cause = { type = "unknown" },
	_cmi_is_mob = true,
	description = S("Mummy"),
}

local spawner_DEF = {
	hp_max = 1,
	physical = false,
	pointable = false,
	visual = "mesh",
	visual_size = {x=3.3,y=3.3},
	mesh = mummy_mesh,
	textures = mummy_texture,
	makes_footstep_sound = false,
	timer = 0,
	automatic_rotate = math.pi * 2.9,
}

spawner_DEF.on_activate = function(self)
	mummy_update_visuals_def(self)
	self.object:set_velocity({x=0, y=0, z=0})
	self.object:set_acceleration({x=0, y=0, z=0})
	self.object:set_armor_groups({immortal=1})

end

spawner_DEF.on_step = function(self, dtime)
	self.timer = self.timer + 0.01
	local n = minetest.get_node_or_nil(self.object:get_pos())
	if self.timer > 1 then
		if n and n.name and n.name ~= "tsm_pyramids:spawner_mummy" then
			self.object:remove()
		end
	end
end

spawner_DEF.on_punch = function(self, hitter)

end

MUMMY_DEF.on_activate = function(self, staticdata, dtime_s)
	if mod_cmi then
		cmi.notify_activate(self, dtime_s)
	end
	mummy_update_visuals_def(self)
	self.anim = get_animations()
	self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, mummy_animation_speed, mummy_animation_blend)
	self.npc_anim = ANIM_STAND
	self.object:set_acceleration({x=0,y=-20,z=0})--20
	self.state = 1
	self.object:set_armor_groups({fleshy=130})
end

MUMMY_DEF.on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	if mod_cmi then
		cmi.notify_punch(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
	end
	self.attacker = puncher

	if damage > 0 then
		self.last_damage = {
			type = "punch",
			puncher = puncher,
		}
	end
	if puncher ~= nil then
		minetest.sound_play(sound_hit, {pos = self.object:get_pos(), loop = false, max_hear_distance = 10, gain = 0.4})
		if time_from_last_punch >= 0.45 then
			hit(self)
			self.direction = {x=self.object:get_velocity().x, y=self.object:get_velocity().y, z=self.object:get_velocity().z}
			self.punch_timer = 0
			self.object:set_velocity({x=dir.x*mummy_chillaxin_speed,y=5,z=dir.z*mummy_chillaxin_speed})
			if self.state == 1 then
				self.state = 8
			elseif self.state >= 2 then
				self.state = 9
			end
		end
	end
end

MUMMY_DEF.on_death = function(self, killer)
	minetest.sound_play(sound_dead, {pos = self.object:get_pos(), max_hear_distance = 10 , gain = 0.3})
	-- Drop item on death
	local count = math.random(0,3)
	if count > 0 then
		local pos = self.object:get_pos()
		pos.y = pos.y + 1.0
		minetest.add_item(pos, mummy_drop .. " " .. count)
	end
	if mod_cmi then
		cmi.notify_die(self, self.last_damage)
	end
end

MUMMY_DEF.on_step = function(self, dtime)
	if mod_cmi then
		cmi.notify_step(self, dtime)
	end
	self.timer = self.timer + 0.01
	self.turn_timer = self.turn_timer + 0.01
	self.jump_timer = self.jump_timer + 0.01
	self.punch_timer = self.punch_timer + 0.01
	self.attacking_timer = self.attacking_timer + 0.01
	self.sound_timer = self.sound_timer + dtime + 0.01

	local current_pos = self.object:get_pos()
	local current_node = minetest.get_node(current_pos)
	if self.time_passed == nil then
		self.time_passed = 0
	end

	-- Environment damage
	local def = minetest.registered_nodes[current_node.name]
	local dps = def.damage_per_second
	local dmg = 0
	local dmg_node, dmg_pos
	if dps ~= nil and dps > 0 then
		dmg = dps
	end
	-- Damage from node
	if dmg < 4 and (minetest.get_item_group(current_node.name, "water") ~= 0 or minetest.get_item_group(current_node.name, "lava") ~= 0) then
		dmg = 4
	end
	-- Damage by suffocation
	if (def.walkable == nil or def.walkable == true)
	and (def.drowning == nil or def.drowning == 0)
	and (def.damage_per_second == nil or def.damage_per_second <= 0)
	and (def.collision_box == nil or def.collision_box.type == "regular")
	and (def.node_box == nil or def.node_box.type == "regular")
	and (def.groups and def.groups.disable_suffocation ~= 1) then
		dmg = dmg + 1
	end
	self.envdmg_timer = self.envdmg_timer + dtime
	if dmg > 0 then
		if self.envdmg_timer >= 1 then
			self.envdmg_timer = 0
			self.object:set_hp(self.object:get_hp()-dmg)
			self.last_damage = {
				type = "environment",
				pos = current_pos,
				node = current_node,
			}
			if self.object:get_hp() <= 0 then
				if self.on_death then
					self.on_death(self)
				end
				self.object:remove()
			else
				hit(self)
				self.sound_timer = 0
				minetest.sound_play(sound_hit, {pos = current_pos, max_hear_distance = 10, gain = 0.4})
			end
		end
	 else
		self.time_passed = 0
	 end

	--update moving state every 1 or 2 seconds
	if self.state < 3 then
		if self.timer > math.random(1,2) then
			if self.attacker == "" then
				self.state = math.random(1,2)
			else self.state = 1 end
			self.timer = 0
		end
	end

	--play sound
	if self.sound_timer > math.random(5,35) then
		minetest.sound_play(sound_normal, {pos = current_pos, max_hear_distance = 10, gain = 0.2})
		self.sound_timer = 0
	end

	--after punched
	if self.state >= 8 then
		if self.punch_timer > 0.15 then
			if self.state == 9 then
				self.object:set_velocity({x=self.direction.x*mummy_chillaxin_speed,y=-20,z=self.direction.z*mummy_chillaxin_speed})
				self.state = 2
			elseif self.state == 8 then
				self.object:set_velocity({x=0,y=-20,z=0})
				self.state = 1
			end
		end
	end

	--STANDING
	if self.state == 1 then
		self.yawwer = true
		self.attacker = ""
		for  _,object in ipairs(minetest.get_objects_inside_radius(self.object:get_pos(), 4)) do
			if object:is_player() then
				self.yawwer = false
				local NPC = self.object:get_pos()
				local PLAYER = object:get_pos()
				self.vec = {x=PLAYER.x-NPC.x, y=PLAYER.y-NPC.y, z=PLAYER.z-NPC.z}
				self.yaw = math.atan(self.vec.z/self.vec.x)+math.pi^2
				if PLAYER.x > NPC.x then
					self.yaw = self.yaw + math.pi
				end
				self.yaw = self.yaw - 2
				self.object:set_yaw(self.yaw)
				self.attacker = object
			end
		end

		if self.attacker == "" and self.turn_timer > math.random(1,4) then
			self.yaw = 360 * math.random()
			self.object:set_yaw(self.yaw)
			self.turn_timer = 0
			self.direction = {x = math.sin(self.yaw)*-1, y = -20, z = math.cos(self.yaw)}
		end
		self.object:set_velocity({x=0,y=self.object:get_velocity().y,z=0})
		if self.npc_anim ~= ANIM_STAND then
			self.anim = get_animations()
			self.object:set_animation({x=self.anim.stand_START,y=self.anim.stand_END}, mummy_animation_speed, mummy_animation_blend)
			self.npc_anim = ANIM_STAND
		end
		if self.attacker ~= "" then
			self.direction = {x = math.sin(self.yaw)*-1, y = -20, z = math.cos(self.yaw)}
			self.state = 2
		end
	end
	--WALKING
	if self.state == 2 then

		if self.direction ~= nil then
			self.object:set_velocity({x=self.direction.x*mummy_chillaxin_speed,y=self.object:get_velocity().y,z=self.direction.z*mummy_chillaxin_speed})
		end
		if self.turn_timer > math.random(1,4) and not self.attacker then
			self.yaw = 360 * math.random()
			self.object:set_yaw(self.yaw)
			self.turn_timer = 0
			self.direction = {x = math.sin(self.yaw)*-1, y = -20, z = math.cos(self.yaw)}
		end
		if self.npc_anim ~= ANIM_WALK then
			self.anim = get_animations()
			self.object:set_animation({x=self.anim.walk_START,y=self.anim.walk_END}, mummy_animation_speed, mummy_animation_blend)
			self.npc_anim = ANIM_WALK
		end

		if self.attacker ~= "" and minetest.settings:get_bool("enable_damage") then
			local s = self.object:get_pos()
			local p = self.attacker:get_pos()
			if (s ~= nil and p ~= nil) then
				local dist = ((p.x-s.x)^2 + (p.y-s.y)^2 + (p.z-s.z)^2)^0.5

				if dist < 2 and self.attacking_timer > 0.6 then
				self.attacker:punch(self.object, 1.0,  {
					full_punch_interval=1.0,
					damage_groups = {fleshy=1}
				})
					self.attacking_timer = 0
				end
			end
		end
	end
end

minetest.register_entity("tsm_pyramids:mummy", MUMMY_DEF)
minetest.register_entity("tsm_pyramids:mummy_spawner", spawner_DEF)


--spawn-egg/spawner

minetest.register_craftitem("tsm_pyramids:spawn_egg", {
	description = S("Mummy Spawn Egg"),
	_doc_items_longdesc = S("Can be used to create a hostile mummy."),
	_doc_items_usagehelp = S("Place the egg to create a mummy on this spot. Careful, it will probably attack immediately!"),
	inventory_image = "tsm_pyramids_mummy_egg.png",
	liquids_pointable = false,
	stack_max = 99,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end

		-- am I clicking on something with existing on_rightclick function?
		local node = minetest.get_node(pointed_thing.under)
		if placer and not placer:get_player_control().sneak then
			if minetest.registered_nodes[node.name] and minetest.registered_nodes[node.name].on_rightclick then
				return minetest.registered_nodes[node.name].on_rightclick(pointed_thing.under, node, placer, itemstack) or itemstack
			end
		end

		minetest.add_entity(pointed_thing.above,"tsm_pyramids:mummy")
		if not minetest.settings:get_bool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end,

})

-- Spawn a mummy at position
function tsm_pyramids.spawn_mummy_at(pos, number)
	local node = minetest.get_node(pos)
	if node.name ~= "air" then
		return
	end
	for _=1, number do
		minetest.add_entity(pos,"tsm_pyramids:mummy")
	end
end

local spawnersounds
if default.node_sound_metal_defaults then
	spawnersounds = default.node_sound_metal_defaults()
else
	spawnersounds = default.node_sound_stone_defaults()
end

minetest.register_node("tsm_pyramids:spawner_mummy", {
	description = S("Mummy Spawner"),
	_doc_items_longdesc = S("A mummy spawner causes hostile mummies to appear in its vicinity as long it exists."),
	paramtype = "light",
	tiles = {"tsm_pyramids_spawner.png"},
	is_ground_content = false,
	drawtype = "allfaces",
	groups = {cracky=1,level=1},
	drop = "",
	on_construct = function(pos)
		pos.y = pos.y - 0.28
		minetest.add_entity(pos,"tsm_pyramids:mummy_spawner")
	end,
	on_destruct = function(pos)
		for  _,obj in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
			if not obj:is_player() then 
				if obj ~= nil and obj:get_luaentity().name == "tsm_pyramids:mummy_spawner" then
					obj:remove()	
				end
			end
		end
	end,
	sounds = spawnersounds,
})

-- Attempt to spawn a mummy at a random appropriate position around pos.
-- Criteria:
-- * Must be close to pos
-- * Not in sunlight
-- * Must be air on top of a non-air block
-- * No more than 6 mummies in area
-- * Player must be near is player_near_required is true
function tsm_pyramids.attempt_mummy_spawn(pos, player_near_required)
	local player_near = false
	local mobs = 0
	for  _,obj in ipairs(minetest.get_objects_inside_radius(pos, spawner_check_range)) do
		if obj:is_player() then
			player_near = true
		else
			if obj:get_luaentity() and obj:get_luaentity().name == "tsm_pyramids:mummy" then
				mobs = mobs + 1
			end
		end
	end
	if player_near or (not player_near_required) then
		if mobs < spawner_max_mobs then
			local offset = {x=5,y=2,z=5}
			local nposses = minetest.find_nodes_in_area(vector.subtract(pos, offset), vector.add(pos,offset), "air")
			local tries = math.min(6, #nposses)
			for i=1, tries do
				local r = math.random(1, #nposses)
				local npos = nposses[r]
				-- Check if mummy has 2 nodes of free space
				local two_space = false
				-- Check if mummy has something to walk on
				local footing = false
				-- Find the lowest node
				for y=-1, -5, -1 do
					npos.y = npos.y - 1
					local below = minetest.get_node(npos)
					if minetest.registered_items[below.name].liquidtype ~= "none" then
						break
					end
					if below.name ~= "air" then
						if y < -1 then
							two_space = true
						end
						npos.y = npos.y + 1
						footing = true
						break
					end
				end
				local light = minetest.get_node_light(npos, 0.5)
				if not two_space then
					local above = minetest.get_node({x=npos.x, y=npos.y+1, z=npos.z})
					if above.name == "air" then
						two_space = true
					end
				end
				if footing and two_space and light < 15 then
					tsm_pyramids.spawn_mummy_at(npos, 1)
					break
				else
					table.remove(nposses, r)
				end
			end
		end
	end
end

if not minetest.settings:get_bool("only_peaceful_mobs") then
	minetest.register_abm({
		nodenames = {"tsm_pyramids:spawner_mummy"},
		interval = 2.0,
		chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			tsm_pyramids.attempt_mummy_spawn(pos, true)
		end,
	})
end

if minetest.get_modpath("awards") then
	awards.register_achievement("tsm_pyramids_no_mummy_spawner", {
		title = S("No more mummies!"),
		description = S("Destroy a mummy spawner by digging."),
		secret = true,
		icon = "tsm_pyramids_spawner.png",
		trigger = {
			type = "dig",
			node = "tsm_pyramids:spawner_mummy",
			target = 1
		}
	})
end
