local ANIMATION_SPEED = tonumber(minetest.settings:get("playeranim.animation_speed")) or 3.1
local ANIMATION_SPEED_SNEAK = tonumber(minetest.settings:get("playeranim.animation_speed_sneak")) or 0.8
local BODY_ROTATION_DELAY = math.max(math.floor(tonumber(minetest.settings:get("playeranim.body_rotation_delay")) or 7), 1)
local BODY_X_ROTATION_SNEAK = tonumber(minetest.settings:get("playeranim.body_x_rotation_sneak")) or 6.0

local BONE_POSITION, BONE_ROTATION = (function()
	local modname = minetest.get_current_modname()
	local modpath = minetest.get_modpath(modname)
	return dofile(modpath .. "/model.lua")
end)()

local get_animation = player_api and player_api.get_animation or default.player_get_animation
if not get_animation then
	error("player_api.get_animation or default.player_get_animation is not found")
end

local function get_animation_speed(player)
	if player:get_player_control().sneak then
		return ANIMATION_SPEED_SNEAK
	end
	return ANIMATION_SPEED
end

local math_deg = math.deg
local function get_pitch_deg(player)
	return math_deg(player:get_look_vertical())
end

local players_animation_data = setmetatable({}, {
	__index = {
		init_player = function(self, player)
			self[player] = {
				time = 0,
				yaw_history = {},
				bone_rotations = {},
				bone_positions = {},
				previous_animation = 0,
			}
		end,

		-- time
		get_time = function(self, player)
			return self[player].time
		end,

		increment_time = function(self, player, dtime)
			self[player].time = self:get_time(player) + dtime
		end,

		reset_time = function(self, player)
			self[player].time = 0
		end,

		-- yaw_history
		get_yaw_history = function(self, player)
			return self[player].yaw_history -- Return mutable reference
		end,

		add_yaw_to_history = function(self, player)
			local yaw = player:get_look_horizontal()
			local history = self:get_yaw_history(player)
			history[#history + 1] = yaw
		end,

		clear_yaw_history = function(self, player)
			if #self[player].yaw_history > 0 then
				self[player].yaw_history = {}
			end
		end,

		-- bone_rotations
		get_bone_rotation = function(self, player, bone)
			return self[player].bone_rotations[bone]
		end,

		set_bone_rotation = function(self, player, bone, rotation)
			self[player].bone_rotations[bone] = rotation
		end,

		-- bone_positions
		get_bone_position = function(self, player, bone)
			return self[player].bone_positions[bone]
		end,

		set_bone_position = function(self, player, bone, position)
			self[player].bone_positions[bone] = position
		end,

		-- previous_animation
		get_previous_animation = function(self, player)
			return self[player].previous_animation
		end,

		set_previous_animation = function(self, player, animation)
			self[player].previous_animation = animation
		end,
	}
})

minetest.register_on_joinplayer(function(player)
	players_animation_data:init_player(player)
end)

local vector_add, vector_equals = vector.add, vector.equals
function rotate_bone(player, bone, rotation, position_optional)
	local previous_rotation = players_animation_data:get_bone_rotation(player, bone)
	local rotation = vector_add(rotation, BONE_ROTATION[bone])

	local previous_position = players_animation_data:get_bone_position(player, bone)
	local position = BONE_POSITION[bone]
	if position_optional then
		position = vector_add(position, position_optional)
	end

	if not previous_rotation
	or not previous_position
	or not vector_equals(rotation, previous_rotation)
	or not vector_equals(position, previous_position) then
		player:set_bone_position(bone, position, rotation)
		players_animation_data:set_bone_rotation(player, bone, rotation)
		players_animation_data:set_bone_position(player, bone, position)
	end
end

-- Animation alias
local STAND = 1
local WALK = 2
local MINE = 3
local WALK_MINE = 4
local SIT = 5
local LAY = 6

-- Bone alias
local BODY = "Body"
local HEAD = "Head"
local CAPE = "Cape"
local LARM = "Arm_Left"
local RARM = "Arm_Right"
local LLEG = "Leg_Left"
local RLEG = "Leg_Right"

local math_sin, math_cos, math_pi = math.sin, math.cos, math.pi
local ANIMATIONS = {
	[STAND] = function(player, _time)
		rotate_bone(player, BODY, {x = 0, y = 0, z = 0})
		rotate_bone(player, CAPE, {x = 0, y = 0, z = 0})
		rotate_bone(player, LARM, {x = 0, y = 0, z = 0})
		rotate_bone(player, RARM, {x = 0, y = 0, z = 0})
		rotate_bone(player, LLEG, {x = 0, y = 0, z = 0})
		rotate_bone(player, RLEG, {x = 0, y = 0, z = 0})
	end,

	[LAY] = function(player, _time)
		rotate_bone(player, HEAD, {x = 0, y = 0, z = 0})
		rotate_bone(player, CAPE, {x = 0, y = 0, z = 0})
		rotate_bone(player, LARM, {x = 0, y = 0, z = 0})
		rotate_bone(player, RARM, {x = 0, y = 0, z = 0})
		rotate_bone(player, LLEG, {x = 0, y = 0, z = 0})
		rotate_bone(player, RLEG, {x = 0, y = 0, z = 0})
		rotate_bone(player, BODY, BONE_ROTATION.body_lay, BONE_POSITION.body_lay)
	end,

	[SIT] = function(player, _time)
		rotate_bone(player, LARM, {x = 0,  y = 0, z = 0})
		rotate_bone(player, RARM, {x = 0,  y = 0, z = 0})
		rotate_bone(player, LLEG, {x = 90, y = 0, z = 0})
		rotate_bone(player, RLEG, {x = 90, y = 0, z = 0})
		rotate_bone(player, BODY, BONE_ROTATION.body_sit, BONE_POSITION.body_sit)
	end,

	[WALK] = function(player, time)
		local speed = get_animation_speed(player)
		local sin = math_sin(time * speed * math_pi)

		rotate_bone(player, CAPE, {x = -35 * sin - 35, y = 0, z = 0})
		rotate_bone(player, LARM, {x = -55 * sin,      y = 0, z = 0})
		rotate_bone(player, RARM, {x = 55 * sin,       y = 0, z = 0})
		rotate_bone(player, LLEG, {x = 55 * sin,       y = 0, z = 0})
		rotate_bone(player, RLEG, {x = -55 * sin,      y = 0, z = 0})
	end,

	[MINE] = function(player, time)
		local speed = get_animation_speed(player)

		local cape_sin = math_sin(time * speed * math_pi)
		local rarm_sin = math_sin(2 * time * speed * math_pi)
		local rarm_cos = -math_cos(2 * time * speed * math_pi)
		local pitch = 90 - get_pitch_deg(player)

		rotate_bone(player, CAPE, {x = -5 * cape_sin - 5,     y = 0,             z = 0})
		rotate_bone(player, LARM, {x = 0,                     y = 0,             z = 0})
		rotate_bone(player, RARM, {x = 10 * rarm_sin + pitch, y = 10 * rarm_cos, z = 0})
		rotate_bone(player, LLEG, {x = 0,                     y = 0,             z = 0})
		rotate_bone(player, RLEG, {x = 0,                     y = 0,             z = 0})
	end,

	[WALK_MINE] = function(player, time)
		local speed = get_animation_speed(player)

		local sin = math_sin(time * speed * math_pi)
		local rarm_sin = math_sin(2 * time * speed * math_pi)
		local rarm_cos = -math_cos(2 * time * speed * math_pi)
		local pitch = 90 - get_pitch_deg(player)

		rotate_bone(player, CAPE, {x = -35 * sin - 35,        y = 0,             z = 0})
		rotate_bone(player, LARM, {x = -55 * sin,             y = 0,             z = 0})
		rotate_bone(player, RARM, {x = 10 * rarm_sin + pitch, y = 10 * rarm_cos, z = 0})
		rotate_bone(player, LLEG, {x = 55 * sin,              y = 0,             z = 0})
		rotate_bone(player, RLEG, {x = -55 * sin,             y = 0,             z = 0})
	end,
}

local function set_animation(player, animation, force_animate)
	local animation_changed
			= (players_animation_data:get_previous_animation(player) ~= animation)

	if force_animate or animation_changed then
		players_animation_data:set_previous_animation(player, animation)
		ANIMATIONS[animation](player, players_animation_data:get_time(player))
	end
end

local function rotate_head(player)
	local head_x_rotation = -get_pitch_deg(player)
	rotate_bone(player, HEAD, {x = head_x_rotation, y = 0, z = 0})
end

local table_remove, math_deg = table.remove, math.deg
local function rotate_body_and_head(player)
	local body_x_rotation = (function()
		return (player:get_player_control().sneak) and BODY_X_ROTATION_SNEAK or 0
	end)()

	local body_y_rotation = (function()
		local yaw_history = players_animation_data:get_yaw_history(player)
		if yaw_history then
			local body_yaw = table_remove(yaw_history, 1)
			local player_yaw = player:get_look_horizontal()
			return math_deg(player_yaw - body_yaw)
		else
			return 0
		end
	end)()

	rotate_bone(player, BODY, {x = body_x_rotation, y = body_y_rotation, z = 0})

	local head_x_rotation = -get_pitch_deg(player)
	rotate_bone(player, HEAD, {x = head_x_rotation, y = -body_y_rotation, z = 0})
end


local function animate_player(player, dtime)
	local animation = get_animation(player).animation

	-- Yaw history
	if animation == "lay" or animation == "sit" then
		players_animation_data:clear_yaw_history(player)
	else
		players_animation_data:add_yaw_to_history(player)
	end
	
	local minSpeed = 0.5
	local rClick = false
	local control = player:get_player_control()
	if control.sneak then
		minSpeed = 0.25
	end
	if control.RMB then
		rClick = true 
	end
	
	
	if math.abs(player:get_player_velocity().x) < minSpeed and math.abs(player:get_player_velocity().z) < minSpeed then
		if animation == "walk" then animation = "stand" 
		elseif animation == "walk_mine" then animation = "mine" end
	end
	-- Increment animation time
	if animation == "walk"
	or animation == "mine"
	or animation == "walk_mine" or rClick then
		players_animation_data:increment_time(player, dtime)
	else
		players_animation_data:reset_time(player)
	end

	-- Set animation
	if animation == "stand" then
		if rClick then
			set_animation(player, MINE, true)
		else
			set_animation(player, STAND)
		end
	elseif animation == "lay" then
		set_animation(player, LAY)
	elseif animation == "sit" then
		set_animation(player, SIT)
	elseif animation == "walk" then
		if rClick then
			set_animation(player, WALK_MINE, true)
		else
			set_animation(player, WALK, true)
		end
	elseif animation == "mine" then
		set_animation(player, MINE, true)
	elseif animation == "walk_mine" then
		set_animation(player, WALK_MINE, true)
	end

	-- Rotate body and head
	if animation == "lay" then
		-- Do nothing
	elseif animation == "sit" then
		rotate_head(player)
	else
		rotate_body_and_head(player)
	end
end

local minetest_get_connected_players = minetest.get_connected_players
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest_get_connected_players()) do
		animate_player(player, dtime)
	end
end)
