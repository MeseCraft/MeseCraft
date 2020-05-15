-- Bone alias
local BODY = "Body"
local HEAD = "Head"
local CAPE = "Cape"
local LARM = "Arm_Left"
local RARM = "Arm_Right"
local LLEG = "Leg_Left"
local RLEG = "Leg_Right"

-- Version of player model
local DEFAULT_PLAYER_MODEL_VERSION = "MTG_4_Jun_2017"

local VALID_PLAYER_MODEL_VERSIONS = {
	MTG_4_Jun_2017 = true,
	MTG_4_Nov_2017 = true,
}

local LEGACY_PLAYER_MODEL_VERSIONS = {
	default_character_v1 = true,
	default_character_v2 = true,
	default_character_v3 = true,
}

local BONE_POSITIONS = {
	MTG_4_Jun_2017 = {
		[BODY] = {x = 0,   y = -3.5, z = 0},
		[HEAD] = {x = 0,   y = 6.75, z = 0},
		[CAPE] = {x = 0,   y = 6.75, z = 1.2},
		[LARM] = {x = 3,   y = 5.75, z = 0},
		[RARM] = {x = -3,  y = 5.75, z = 0},
		[LLEG] = {x = 1,   y = 0,    z = 0},
		[RLEG] = {x = -1,  y = 0,    z = 0},

		body_sit = {x = 0, y = -5.5, z = 0},
		body_lay = {x = 0, y = -5.5, z = 0},
	},
	MTG_4_Nov_2017 = {
		[BODY] = {x = 0,   y = 6.25, z = 0},
		[HEAD] = {x = 0,   y = 6.5,  z = 0},
		[CAPE] = {x = 0,   y = 6.5,  z = 1.2},
		[LARM] = {x = 3,   y = 5.5,  z = 0},
		[RARM] = {x = -3,  y = 5.5,  z = 0},
		[LLEG] = {x = 1,   y = 0,    z = 0},
		[RLEG] = {x = -1,  y = 0,    z = 0},

		body_sit = {x = 0, y = -5, z = 0},
		body_lay = {x = 0, y = -5, z = 0},
	},
}

local BONE_ROTATIONS = {
	MTG_4_Jun_2017 = {
		[BODY] = {x = 0, y = 0, z = 0},
		[HEAD] = {x = 0, y = 0, z = 0},
		[CAPE] = {x = 0, y = 0, z = 0},
		[LARM] = {x = 0, y = 0, z = 0},
		[RARM] = {x = 0, y = 0, z = 0},
		[LLEG] = {x = 0, y = 0, z = 0},
		[RLEG] = {x = 0, y = 0, z = 0},

		body_sit = {x = 0,   y = 0, z = 0},
		body_lay = {x = 270, y = 0, z = 0},
	},
	MTG_4_Nov_2017 = {
		[BODY] = {x = 0, y = 0, z = 0},
		[HEAD] = {x = 0, y = 0, z = 0},
		[CAPE] = {x = 0, y = 0, z = 0},
		[LARM] = {x = 0, y = 0, z = 0},
		[RARM] = {x = 0, y = 0, z = 0},
		[LLEG] = {x = 0, y = 0, z = 0},
		[RLEG] = {x = 0, y = 0, z = 0},

		body_sit = {x = 0,   y = 0, z = 0},
		body_lay = {x = 270, y = 0, z = 0},
	},
}

if tonumber(string.sub(minetest.get_version().string, 1, 1)) and tonumber(string.sub(minetest.get_version().string, 1, 1)) > 4 then
	for _,skip in pairs(BONE_POSITIONS) do
		for name, pos in pairs(skip) do
			if name == "Body" then 
				pos.y = pos.y + 10 --Quick maths!
			end
		end
	end
end

local PLAYER_MODEL_VERSION = (function()
	local version = minetest.settings:get("playeranim.model_version")
	if version == nil or version == "" then
		version = DEFAULT_PLAYER_MODEL_VERSION
	end

	if LEGACY_PLAYER_MODEL_VERSIONS[version] then
		error("The model version '" .. version .. "' is no longer suppported")
	elseif not VALID_PLAYER_MODEL_VERSIONS[version] then
		error("Invalid value for playeranim.model_version in minetest.conf: " .. version)
	end

	return version
end)()

local BONE_POSITION = BONE_POSITIONS[PLAYER_MODEL_VERSION]
local BONE_ROTATION = BONE_ROTATIONS[PLAYER_MODEL_VERSION]
if not BONE_POSITION or not BONE_ROTATION then
	error("Internal error: invalid player_model_version: " .. PLAYER_MODEL_VERSION)
end

return BONE_POSITION, BONE_ROTATION
